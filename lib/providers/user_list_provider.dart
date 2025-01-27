import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class UserListProvider extends ChangeNotifier {
  List<UserModel> users = []; //TODO IMPLEMENTAR FIREBASE
  bool isLoading = true;
  late UserModel selectedUser;


  UserListProvider() {
    cargarUser();
    selectedUser = UserModel(email: '', contrasena: '');
  }

  newUser(UserModel user,
      {required String email, required String contrasena, int? id}) async {
    final newUser = UserModel(
      email: email,
      contrasena: contrasena,
      id: id,
    );

    await DBProvider.db.newUser(newUser);
    users.add(newUser);
    notifyListeners();
  }

  Future<List<UserModel>> cargarUser() async {
    isLoading = true;
    notifyListeners();
    final users = await DBProvider.db.getUserAll();
    if (users == null) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    this.users = [...users];
    isLoading = false;
    notifyListeners();
    return this.users;
  }

  Future<bool> checkUserExists(
      {required String email, required String contrasena}) async {
    //TODO cambiar con firebase
    final users = await DBProvider.db.getUserEmail(email);
    return users != null &&
        users.any(
            (user) => user.email == email && user.contrasena == contrasena);
  }

  deleteById(int? id) async {
    if (id != null) {
      await DBProvider.db.deleteUserById(id);
      cargarUser();
    }
  }


/*
  update(user) async {
    await DBProvider.db.updateUser(user);
    cargarUser();
  }
*/
}
