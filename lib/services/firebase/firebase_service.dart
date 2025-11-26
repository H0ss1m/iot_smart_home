import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to your home data collection
  CollectionReference get homeDataRef => _firestore.collection('home_data');

  // Get document reference for a specific room
  DocumentReference roomRef(String roomName) {
    return homeDataRef.doc(roomName);
  }

  // Stream for real-time updates
  Stream<DocumentSnapshot> getRoomStream(String roomName) {
    return roomRef(roomName).snapshots();
  }

  // Update a specific field in a room (only updates existing documents)
  Future<void> updateRoomField(
    String roomName,
    String field,
    dynamic value,
  ) async {
    try {
      // Check if document exists first
      final doc = await roomRef(roomName).get();
      if (doc.exists) {
        // Document exists, update it
        await roomRef(roomName).update({field: value});
      } else {
        // Document doesn't exist, this shouldn't happen if initialization worked
        // But if it does, we'll create it with the field (shouldn't reach here normally)
        print('Warning: Document $roomName does not exist. Please initialize it first.');
        // Optionally, you can throw an error instead:
        // throw Exception('Document $roomName does not exist. Initialize it first.');
      }
    } catch (e) {
      print('Error updating $roomName.$field: $e');
      rethrow;
    }
  }

  // Update entire room data
  Future<void> updateRoom(
    String roomName,
    Map<String, dynamic> data,
  ) async {
    await roomRef(roomName).set(data, SetOptions(merge: true));
  }

  // Initialize room data if it doesn't exist
  Future<void> initializeRoomIfNeeded(
    String roomName,
    Map<String, dynamic> defaultData,
  ) async {
    final doc = await roomRef(roomName).get();
    if (!doc.exists) {
      await roomRef(roomName).set(defaultData);
    }
  }

  // Get room data from Firebase
  Future<Map<String, dynamic>?> getRoomData(String roomName) async {
    try {
      final doc = await roomRef(roomName).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting $roomName data: $e');
      return null;
    }
  }
}

