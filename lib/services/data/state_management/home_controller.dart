import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/services/data/const_data/data.dart';
import 'package:iot_smart_home/services/firebase/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  // Flag to prevent update loops when syncing from Firebase
  bool _isUpdatingFromFirebase = false;

  // Flag to track if Firebase initialization is complete
  bool _isFirebaseInitialized = false;

  // Stream subscriptions
  StreamSubscription<DatabaseEvent>? _livingroomSubscription;
  StreamSubscription<DatabaseEvent>? _kitchenSubscription;
  StreamSubscription<DatabaseEvent>? _bedroomSubscription;

  // Livingroom state
  final RxBool livingroomLight = false.obs;
  final RxBool livingroomAc = true.obs;
  final RxDouble livingroomMoisture = 70.0.obs;
  final RxDouble livingroomTemperature = 25.0.obs;
  final RxBool livingroomDoor = false.obs;
  final RxBool livingroomWindow = false.obs;

  // Kitchen state
  final RxBool kitchenLight = true.obs;
  final RxBool kitchenDoor = true.obs;
  final RxDouble kitchenMoisture = 50.0.obs;
  final RxDouble kitchenTemperature = 25.0.obs;
  final RxBool kitchenWindow = true.obs;

  // Bedroom state
  final RxBool bedroomLight = false.obs;
  final RxBool bedroomAc = false.obs;
  final RxBool bedroomWindow = true.obs;
  final RxBool bedroomDoor = false.obs;
  final RxDouble bedroomMoisture = 50.0.obs;
  final RxDouble bedroomTemperature = 25.0.obs;

  // Alarm state
  final RxBool alarmActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load from Firebase first, fallback to data.dart if Firebase fails
    _loadInitialDataFromFirebase()
        .then((_) {
          _isFirebaseInitialized = true;
          _setupFirebaseListeners();
        })
        .catchError((error) {
          print('Error loading from Firebase, using local data: $error');
          // Fallback to local data if Firebase fails
          _loadInitialDataFromLocal();
          _initializeFirebaseData()
              .then((_) {
                _isFirebaseInitialized = true;
                _setupFirebaseListeners();
              })
              .catchError((e) {
                print('Error initializing Firebase: $e');
                _setupFirebaseListeners();
              });
        });
  }

  @override
  void onClose() {
    _livingroomSubscription?.cancel();
    _kitchenSubscription?.cancel();
    _bedroomSubscription?.cancel();
    super.onClose();
  }

  // Load initial data from Firebase (primary source)
  Future<void> _loadInitialDataFromFirebase() async {
    try {
      // Load livingroom data from Firebase
      final livingroomData = await _firebaseService.getRoomData('livingroom');
      if (livingroomData != null) {
        livingroomLight.value = livingroomData['light'] as bool? ?? false;
        livingroomAc.value = livingroomData['ac'] as bool? ?? true;
        livingroomMoisture.value =
            (livingroomData['moisture'] as num?)?.toDouble() ?? 70.0;
        livingroomTemperature.value =
            (livingroomData['temperature'] as num?)?.toDouble() ?? 25.0;
        livingroomDoor.value = livingroomData['door'] as bool? ?? false;
        livingroomWindow.value = livingroomData['window'] as bool? ?? false;
      } else {
        // Node doesn't exist, use local data
        throw Exception('Livingroom node not found');
      }

      // Load kitchen data from Firebase
      final kitchenData = await _firebaseService.getRoomData('kitchen');
      if (kitchenData != null) {
        kitchenLight.value = kitchenData['light'] as bool? ?? true;
        kitchenDoor.value = kitchenData['door'] as bool? ?? true;
        kitchenMoisture.value =
            (kitchenData['moisture'] as num?)?.toDouble() ?? 50.0;
        kitchenTemperature.value =
            (kitchenData['temperature'] as num?)?.toDouble() ?? 25.0;
        kitchenWindow.value = kitchenData['window'] as bool? ?? true;
      } else {
        throw Exception('Kitchen node not found');
      }

      // Load bedroom data from Firebase
      final bedroomData = await _firebaseService.getRoomData('bedroom');
      if (bedroomData != null) {
        bedroomLight.value = bedroomData['light'] as bool? ?? false;
        bedroomAc.value = bedroomData['ac'] as bool? ?? false;
        bedroomWindow.value = bedroomData['window'] as bool? ?? true;
        bedroomDoor.value = bedroomData['door'] as bool? ?? false;
        bedroomMoisture.value =
            (bedroomData['moisture'] as num?)?.toDouble() ?? 50.0;
        bedroomTemperature.value =
            (bedroomData['temperature'] as num?)?.toDouble() ?? 25.0;
      } else {
        throw Exception('Bedroom node not found');
      }

      // Update alarm state
      _updateAlarm();

      // Sync to data.dart for offline fallback
      _syncToLocalData();

      print('Data loaded from Firebase successfully');
    } catch (e) {
      print('Error loading from Firebase: $e');
      rethrow;
    }
  }

  // Load initial data from data.dart (fallback/default values)
  void _loadInitialDataFromLocal() {
    // Load livingroom data
    livingroomLight.value = livingroom[0]['light'] as bool;
    livingroomAc.value = livingroom[0]['ac'] as bool;
    livingroomMoisture.value = livingroom[0]['moisture'] as double;
    livingroomTemperature.value = livingroom[0]['temperature'] as double;
    livingroomDoor.value = livingroom[0]['door'] as bool;
    livingroomWindow.value = livingroom[0]['window'] as bool;

    // Load kitchen data
    kitchenLight.value = kitchen[0]['light'] as bool;
    kitchenDoor.value = kitchen[0]['door'] as bool;
    kitchenMoisture.value = kitchen[0]['moisture'] as double;
    kitchenTemperature.value = kitchen[0]['temperature'] as double;
    kitchenWindow.value = kitchen[0]['window'] as bool;

    // Load bedroom data
    bedroomLight.value = bedroom[0]['light'] as bool;
    bedroomAc.value = bedroom[0]['ac'] as bool;
    bedroomWindow.value = bedroom[0]['window'] as bool;
    bedroomDoor.value = bedroom[0]['door'] as bool? ?? false;
    bedroomMoisture.value = bedroom[0]['moisture'] as double;
    bedroomTemperature.value = bedroom[0]['temperature'] as double;

    // Load alarm data
    alarmActive.value = alarm[0]['alarm'] as bool;
  }

  // Sync current state to data.dart for offline fallback
  void _syncToLocalData() {
    // Sync livingroom
    livingroom[0]['light'] = livingroomLight.value;
    livingroom[0]['ac'] = livingroomAc.value;
    livingroom[0]['moisture'] = livingroomMoisture.value;
    livingroom[0]['temperature'] = livingroomTemperature.value;
    livingroom[0]['door'] = livingroomDoor.value;
    livingroom[0]['window'] = livingroomWindow.value;

    // Sync kitchen
    kitchen[0]['light'] = kitchenLight.value;
    kitchen[0]['door'] = kitchenDoor.value;
    kitchen[0]['moisture'] = kitchenMoisture.value;
    kitchen[0]['temperature'] = kitchenTemperature.value;
    kitchen[0]['window'] = kitchenWindow.value;

    // Sync bedroom
    bedroom[0]['light'] = bedroomLight.value;
    bedroom[0]['ac'] = bedroomAc.value;
    bedroom[0]['window'] = bedroomWindow.value;
    bedroom[0]['door'] = bedroomDoor.value;
    bedroom[0]['moisture'] = bedroomMoisture.value;
    bedroom[0]['temperature'] = bedroomTemperature.value;

    // Sync alarm
    alarm[0]['alarm'] = alarmActive.value;
  }

  // Initialize Firebase with current local values if documents don't exist
  Future<void> _initializeFirebaseData() async {
    try {
      // Initialize livingroom
      await _firebaseService.initializeRoomIfNeeded('livingroom', {
        'light': livingroomLight.value,
        'ac': livingroomAc.value,
        'moisture': livingroomMoisture.value,
        'temperature': livingroomTemperature.value,
        'door': livingroomDoor.value,
        'window': livingroomWindow.value,
      });

      // Initialize kitchen
      await _firebaseService.initializeRoomIfNeeded('kitchen', {
        'light': kitchenLight.value,
        'door': kitchenDoor.value,
        'moisture': kitchenMoisture.value,
        'temperature': kitchenTemperature.value,
        'window': kitchenWindow.value,
      });

      // Initialize bedroom
      await _firebaseService.initializeRoomIfNeeded('bedroom', {
        'light': bedroomLight.value,
        'ac': bedroomAc.value,
        'window': bedroomWindow.value,
        'door': bedroomDoor.value,
        'moisture': bedroomMoisture.value,
        'temperature': bedroomTemperature.value,
      });

      print('Firebase initialization complete');
    } catch (e) {
      // Handle Firebase errors (e.g., no internet connection)
      print('Error initializing Firebase data: $e');
    }
  }

  // Setup real-time Firebase listeners
  void _setupFirebaseListeners() {
    // Listen to livingroom changes
    _livingroomSubscription = _firebaseService
        .getRoomStream('livingroom')
        .listen(
          (event) {
            if (event.snapshot.exists && !_isUpdatingFromFirebase) {
              final data = Map<String, dynamic>.from(
                event.snapshot.value as Map,
              );
              _updateLivingroomFromFirebase(data);
            }
          },
          onError: (error) {
            print('Error listening to livingroom: $error');
          },
        );

    // Listen to kitchen changes
    _kitchenSubscription = _firebaseService
        .getRoomStream('kitchen')
        .listen(
          (event) {
            if (event.snapshot.exists && !_isUpdatingFromFirebase) {
              final data = Map<String, dynamic>.from(
                event.snapshot.value as Map,
              );
              _updateKitchenFromFirebase(data);
            }
          },
          onError: (error) {
            print('Error listening to kitchen: $error');
          },
        );

    // Listen to bedroom changes
    _bedroomSubscription = _firebaseService
        .getRoomStream('bedroom')
        .listen(
          (event) {
            if (event.snapshot.exists && !_isUpdatingFromFirebase) {
              final data = Map<String, dynamic>.from(
                event.snapshot.value as Map,
              );
              _updateBedroomFromFirebase(data);
            }
          },
          onError: (error) {
            print('Error listening to bedroom: $error');
          },
        );
  }

  // Update local state from Firebase (without triggering Firebase update)
  void _updateLivingroomFromFirebase(Map<String, dynamic> data) {
    _isUpdatingFromFirebase = true;
    livingroomLight.value = data['light'] as bool? ?? livingroomLight.value;
    livingroomAc.value = data['ac'] as bool? ?? livingroomAc.value;
    livingroomMoisture.value =
        (data['moisture'] as num?)?.toDouble() ?? livingroomMoisture.value;
    livingroomTemperature.value =
        (data['temperature'] as num?)?.toDouble() ??
        livingroomTemperature.value;
    livingroomDoor.value = data['door'] as bool? ?? livingroomDoor.value;
    livingroomWindow.value = data['window'] as bool? ?? livingroomWindow.value;

    // Sync to data.dart for offline fallback
    _syncToLocalData();

    _updateAlarm();
    _isUpdatingFromFirebase = false;
  }

  void _updateKitchenFromFirebase(Map<String, dynamic> data) {
    _isUpdatingFromFirebase = true;
    kitchenLight.value = data['light'] as bool? ?? kitchenLight.value;
    kitchenDoor.value = data['door'] as bool? ?? kitchenDoor.value;
    kitchenMoisture.value =
        (data['moisture'] as num?)?.toDouble() ?? kitchenMoisture.value;
    kitchenTemperature.value =
        (data['temperature'] as num?)?.toDouble() ?? kitchenTemperature.value;
    kitchenWindow.value = data['window'] as bool? ?? kitchenWindow.value;

    // Sync to data.dart for offline fallback
    _syncToLocalData();

    _updateAlarm();
    _isUpdatingFromFirebase = false;
  }

  void _updateBedroomFromFirebase(Map<String, dynamic> data) {
    _isUpdatingFromFirebase = true;
    bedroomLight.value = data['light'] as bool? ?? bedroomLight.value;
    bedroomAc.value = data['ac'] as bool? ?? bedroomAc.value;
    bedroomWindow.value = data['window'] as bool? ?? bedroomWindow.value;
    bedroomDoor.value = data['door'] as bool? ?? bedroomDoor.value;
    bedroomMoisture.value =
        (data['moisture'] as num?)?.toDouble() ?? bedroomMoisture.value;
    bedroomTemperature.value =
        (data['temperature'] as num?)?.toDouble() ?? bedroomTemperature.value;

    // Sync to data.dart for offline fallback
    _syncToLocalData();

    _updateAlarm();
    _isUpdatingFromFirebase = false;
  }

  // Livingroom methods - now sync to Firebase
  void setLivingroomLight(bool value) {
    if (_isUpdatingFromFirebase) return;
    livingroomLight.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'light', value);
    }
    _syncToLocalData();
  }

  void setLivingroomAc(bool value) {
    if (_isUpdatingFromFirebase) return;
    livingroomAc.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'ac', value);
    }
    _syncToLocalData();
  }

  void setLivingroomTemperature(double value) {
    if (_isUpdatingFromFirebase) return;
    livingroomTemperature.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'temperature', value);
    }
    _syncToLocalData();
  }

  void setLivingroomDoor(bool value) {
    if (_isUpdatingFromFirebase) return;
    livingroomDoor.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'door', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setLivingroomWindow(bool value) {
    if (_isUpdatingFromFirebase) return;
    livingroomWindow.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'window', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setLivingroomMoisture(double value) {
    if (_isUpdatingFromFirebase) return;
    livingroomMoisture.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('livingroom', 'moisture', value);
    }
    _syncToLocalData();
  }

  // Kitchen methods - now sync to Firebase
  void setKitchenLight(bool value) {
    if (_isUpdatingFromFirebase) return;
    kitchenLight.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('kitchen', 'light', value);
    }
    _syncToLocalData();
  }

  void setKitchenDoor(bool value) {
    if (_isUpdatingFromFirebase) return;
    kitchenDoor.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('kitchen', 'door', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setKitchenWindow(bool value) {
    if (_isUpdatingFromFirebase) return;
    kitchenWindow.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('kitchen', 'window', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setKitchenMoisture(double value) {
    if (_isUpdatingFromFirebase) return;
    kitchenMoisture.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('kitchen', 'moisture', value);
    }
    _syncToLocalData();
  }

  void setKitchenTemperature(double value) {
    if (_isUpdatingFromFirebase) return;
    kitchenTemperature.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('kitchen', 'temperature', value);
    }
    _syncToLocalData();
  }

  // Bedroom methods - now sync to Firebase
  void setBedroomLight(bool value) {
    if (_isUpdatingFromFirebase) return;
    bedroomLight.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'light', value);
    }
    _syncToLocalData();
  }

  void setBedroomAc(bool value) {
    if (_isUpdatingFromFirebase) return;
    bedroomAc.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'ac', value);
    }
    _syncToLocalData();
  }

  void setBedroomWindow(bool value) {
    if (_isUpdatingFromFirebase) return;
    bedroomWindow.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'window', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setBedroomDoor(bool value) {
    if (_isUpdatingFromFirebase) return;
    bedroomDoor.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'door', value);
    }
    _syncToLocalData();
    _updateAlarm();
  }

  void setBedroomMoisture(double value) {
    if (_isUpdatingFromFirebase) return;
    bedroomMoisture.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'moisture', value);
    }
    _syncToLocalData();
  }

  void setBedroomTemperature(double value) {
    if (_isUpdatingFromFirebase) return;
    bedroomTemperature.value = value;
    if (_isFirebaseInitialized) {
      _firebaseService.updateRoomField('bedroom', 'temperature', value);
    }
    _syncToLocalData();
  }

  // Alarm methods
  void _updateAlarm() {
    // Check if any window or door is open
    bool hasOpenWindow =
        kitchenWindow.value || bedroomWindow.value || livingroomWindow.value;
    bool hasOpenDoor =
        kitchenDoor.value || livingroomDoor.value || bedroomDoor.value;
    alarmActive.value = hasOpenWindow || hasOpenDoor;
    alarm[0]['alarm'] = alarmActive.value;
  }

  // Computed properties
  bool get hasOpenWindowOrDoor {
    return kitchenWindow.value ||
        bedroomWindow.value ||
        kitchenDoor.value ||
        livingroomDoor.value ||
        bedroomDoor.value ||
        livingroomWindow.value;
  }

  String get alarmMessage {
    int openWindows = 0;
    int openDoors = 0;

    if (kitchenWindow.value) openWindows++;
    if (bedroomWindow.value) openWindows++;
    if (livingroomWindow.value) openWindows++;
    if (kitchenDoor.value) openDoors++;
    if (livingroomDoor.value) openDoors++;
    if (bedroomDoor.value) openDoors++;

    if (openWindows > 0 && openDoors > 0) {
      return '$openWindows Window${openWindows > 1 ? 's' : ''} and $openDoors Door${openDoors > 1 ? 's' : ''} Open';
    } else if (openWindows > 0) {
      return '$openWindows Window${openWindows > 1 ? 's' : ''} Open';
    } else if (openDoors > 0) {
      return '$openDoors Door${openDoors > 1 ? 's' : ''} Open';
    }
    return '';
  }
}
