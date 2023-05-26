import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usersappv/config/config.dart';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(int idUser);
  Future<User> addUser(User user);
  Future<User> updateUser(User user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      var dio = Dio();

      var response = await dio.get(url);

      if (response.statusCode == 200) {
        var datausers = (response.data as List<dynamic>)
            .map<UserModel>((data) => UserModel.fromJson(data))
            .toList();

        final prefs = await SharedPreferences.getInstance();
        final jsonData =
            jsonEncode(datausers); // Convertir a JSON los datos de usuarios
        prefs.setString('usuarios',
            jsonData); // Guardar solo los datos de usuarios en SharedPreferences

        return datausers;
      } else {
        throw Exception('Error fetching users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  @override
  Future<void> deleteUser(int idUser) async {
    Dio dio = Dio();
    await dio.delete('$url$idUser/',
        options: Options(
            sendTimeout: const Duration(milliseconds: 2500),
            receiveTimeout: const Duration(milliseconds: 2500)));
  }

  @override
  Future<User> addUser(User userModel) async {
    Dio dio = Dio();
    final response = await dio.post(
      url,
      data: {
        'username': userModel.name,
        'email': userModel.lastName,
        'name': userModel.email,
        'last_name': userModel.username,
      },
    );

    if (response.statusCode == 201 && response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to add user.');
    }
  }

  @override
  Future<User> updateUser(User userModel) async {
    Dio dio = Dio();
    final response = await dio.put(
      "$url${userModel.id}/",
      data: {
        'username': userModel.name,
        'email': userModel.lastName,
        'name': userModel.email,
        'last_name': userModel.username,
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update user.');
    }
  }
}
