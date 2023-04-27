import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class UserListProvider extends ChangeNotifier {
  List<UserModel> users = []; //TODO IMPLEMENTAR FIREBASE
  String categoriaSeleacionada = '';
  bool isLoading = true;
  late UserModel selectedUser;
  File? newImgFile;

  UserListProvider() {
    cargarUser();
    selectedUser = UserModel(email: '', contrasena: '');
  }

  newUser(
      {required String email,
      required String contrasena,
      int? id}) async {
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
    this.users = [...users];
    isLoading = false;
    notifyListeners();
    return this.users;
  }

/*
  deleteById(int id) async {
    await DBProvider.db.deleteUserById(id);
    cargarUser();
  }

  update(user) async {
    await DBProvider.db.updateUser(user);
    cargarUser();
  }
*/

}