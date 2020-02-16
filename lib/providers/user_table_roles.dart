import 'package:cloud_firestore/cloud_firestore.dart';

class UserTableRoles {
  final String uid;
  UserTableRoles({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(bool isAdmin, String email) async {
    return await usersCollection
        .document(uid)
        .setData({'isAdmin': false, 'email': email});
  }
}
