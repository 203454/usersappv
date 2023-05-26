import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usersappv/features/users/presentation/blocs/users_bloc.dart';
import 'package:usersappv/features/users/presentation/pages/TestWidget.dart';
import 'package:usersappv/features/users/presentation/pages/home.dart';
import 'package:usersappv/features/users/presentation/pages/list_users.dart';
import 'package:usersappv/usecase_config.dart';

UsecaseConfig usecaseConfig = UsecaseConfig();
bool internetConnection = true;

// void updateConnectivityStatus(ConnectivityResult result) {
//   if (result == ConnectivityResult.wifi ||
//       result == ConnectivityResult.mobile) {
//     internetConnection = true;
//     print('Estás conectado a internet');
//   } else {
//     print('No estás conectado a ninguna red');
//     internetConnection = false;
//   }
// }

void main() {
  Connectivity connectivity = Connectivity();
  WidgetsFlutterBinding.ensureInitialized();

  // connectivity.onConnectivityChanged.listen(updateConnectivityStatus);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
            create: (BuildContext context) => UserBloc(
                  getUserUseCase: usecaseConfig.getUsersUsecase!,
                  deleteUsersUsecase: usecaseConfig.deleteUsersUsecase!,
                  addUsersUsecase: usecaseConfig.addUsersUsecase!,
                  updateUsersUsecase: usecaseConfig.updateUserUseCase!,
                )),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        color: const Color.fromARGB(255, 1, 1, 1),
        // home: internetConnection ? const ListUsers() : const TestWd(),
        home: const HomeScreen(),
      ),
    );
  }
}
