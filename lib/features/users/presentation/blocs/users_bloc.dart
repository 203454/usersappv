import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/domain/usecases/add_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/delete_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/edit_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/get_users_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'users_event.dart';
part 'users_state.dart';

class UserBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUsecase getUserUseCase;
  final DeleteUsersUsecase deleteUsersUsecase;
  final AddUsersUsecase addUsersUsecase;
  final UpdateUsersUsecase updateUsersUsecase;

  UserBloc({
    required this.getUserUseCase,
    required this.deleteUsersUsecase,
    required this.addUsersUsecase,
    required this.updateUsersUsecase,
  }) : super(Loading()) {
    on<UsersEvent>((event, emit) async {
      if (event is GetUsers) {
        print("Get users event");
        try {
          emit(Loading());
          List<User> response = await getUserUseCase.execute();
          emit(Loaded(users: response));
        } catch (e) {
          emit(Error(error: '${e}error en get'));
        }
      } else if (event is GetUsersOffline) {
        print("GetOffline users event");
        try {
          emit(Loading());
          final prefs = await SharedPreferences.getInstance();
          String? userDataStr = prefs.getString('usuarios');
          if (userDataStr != null) {
            var dataUsersGotten = convert
                .jsonDecode(userDataStr)
                .map<UserModel>((data) => UserModel.fromJson(data))
                .toList();
            emit(Loaded(users: dataUsersGotten));
          }
        } catch (e) {
          emit(Error(error: '${e}error en getoffline'));
        }
      } else if (event is DeleteUser) {
        print("delete users event");
        try {
          await deleteUsersUsecase.execute(event.idUser);
          emit(UserDeleted());
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      } else if (event is AddUser) {
        print("Add users event");
        try {
          await addUsersUsecase.execute(event.user);
          emit(UserAdded());
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      } else if (event is UpdateUser) {
        print("update users event");
        try {
          await updateUsersUsecase.execute(event.user);
          emit(UserUpdated());
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      } else if (event is UpdateUser) {
        print("update users event");
        try {
          await updateUsersUsecase.execute(event.user);
          emit(UserUpdated());
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }
    });
  }
}
