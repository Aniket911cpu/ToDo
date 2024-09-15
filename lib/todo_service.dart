import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class TodoService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;

  TodoService(this._authService);

  Stream<QuerySnapshot> get todos {
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: _authService.user?.uid)
        .snapshots();
  }

  Future<void> addTodo(String title) async {
    await _firestore.collection('todos').add({
      'title': title,
      'userId': _authService.user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection('todos').doc(id).delete();
  }
}