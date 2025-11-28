import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Reference to your home data node
  DatabaseReference get homeDataRef => _database.ref('home_data');

  // Get reference for a specific room
  DatabaseReference roomRef(String roomName) {
    return homeDataRef.child(roomName);
  }

  // Stream for real-time updates
  Stream<DatabaseEvent> getRoomStream(String roomName) {
    return roomRef(roomName).onValue;
  }

  // Update a specific field in a room (only updates existing documents)
  Future<void> updateRoomField(
    String roomName,
    String field,
    dynamic value,
  ) async {
    try {
      // Check if data exists first
      final snapshot = await roomRef(roomName).get();
      if (snapshot.exists) {
        // Data exists, update it
        await roomRef(roomName).update({field: value});
      } else {
        // Data doesn't exist
        print(
          'Warning: Node $roomName does not exist. Please initialize it first.',
        );
      }
    } catch (e) {
      print('Error updating $roomName.$field: $e');
      rethrow;
    }
  }

  // Update entire room data
  Future<void> updateRoom(String roomName, Map<String, dynamic> data) async {
    await roomRef(roomName).update(data);
  }

  // Initialize room data if it doesn't exist
  Future<void> initializeRoomIfNeeded(
    String roomName,
    Map<String, dynamic> defaultData,
  ) async {
    final snapshot = await roomRef(roomName).get();
    if (!snapshot.exists) {
      await roomRef(roomName).set(defaultData);
    }
  }

  // Get room data from Firebase
  Future<Map<String, dynamic>?> getRoomData(String roomName) async {
    try {
      final snapshot = await roomRef(roomName).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Error getting $roomName data: $e');
      return null;
    }
  }
}
