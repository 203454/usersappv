import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/presentation/pages/add_user.dart';

import '../blocs/users_bloc.dart';

class TestWd extends StatefulWidget {
  final bool internetConnection;
  const TestWd({super.key, required this.internetConnection});

  @override
  State<TestWd> createState() => _TestWdState();
}

class _TestWdState extends State<TestWd> {
  // List<User> users = [];
  late UserBloc userBloc;

  late StreamSubscription<ConnectivityResult> subscription;
  bool internetConnection = false;
  late SharedPreferences prefs;
  String? userDataStr = "";

  List<UsersEvent> events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);

    context.read<UserBloc>().add(GetUsersOffline());
    updateData();
  }

// Este s
  Future<void> updateData() async {
    for (var event in events) {
      userBloc.add(event);
    }
    events.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST OFFLINE'),
      ),
      body: BlocBuilder<UserBloc, UsersState>(
        builder: (context, state) {
          if (state is Loaded) {
            return SingleChildScrollView(
              child: Column(
                  children: state.users.map((user) {
                return Slidable(
                  startActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FormAddUser(
                                    actionButton: 'Guardar usuario',
                                    userModel: user,
                                  )),
                        );
                      },
                      icon: Icons.edit,
                      backgroundColor: Colors.green,
                    )
                  ]),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar usuario'),
                                content: const Text(
                                    '¿Estás seguro de que quieres eliminar este usuario?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context
                                          .read<UserBloc>()
                                          .add(GetUsersOffline());
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (userDataStr != null) {
                                        int? idToDelete = user.id;
                                        List<dynamic> dataUsers =
                                            jsonDecode(userDataStr!);
                                        dataUsers.removeWhere(
                                            (user) => user['id'] == idToDelete);
                                        String updatedUserDataStr =
                                            jsonEncode(dataUsers);
                                        prefs.setString(
                                            'usuarios', updatedUserDataStr);
                                        print(updatedUserDataStr);
                                        events.add(DeleteUser(user.id!));
                                        context
                                            .read<UserBloc>()
                                            .add(GetUsersOffline());
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: const Color.fromARGB(255, 175, 76, 76),
                        icon: Icons.delete_forever,
                        label: 'delete',
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    color: const Color.fromARGB(31, 176, 176, 176),
                    child: ListTile(
                      title: Text(user.username),
                      subtitle:
                          Text('${user.name} ${user.lastName} | ${user.email}'),
                    ),
                  ),
                );
              }).toList()),
            );
          } else if (state is Loaded) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   style: ButtonStyle(
              //       elevation: MaterialStateProperty.all<double>(8.0)),
              //   onPressed: _refresh,
              //   child: const Icon(Icons.refresh),
              // ),
              const SizedBox(
                width: 10.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(8.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormAddUser(
                            actionButton: 'Agregar usuario ')),
                  );
                },
                child: const Icon(Icons.person_add_rounded),
              ),
            ],
          )),
    );
  }
}
