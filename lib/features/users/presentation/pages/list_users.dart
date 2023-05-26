import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usersappv/features/users/presentation/blocs/users_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:usersappv/features/users/presentation/pages/TestWidget.dart';
import 'package:usersappv/features/users/presentation/pages/add_user.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<dynamic> users = [];
  late StreamSubscription<ConnectivityResult> subscription;
  bool internetConnection = false;
  late UserBloc userBloc;
  List<UsersEvent> events = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    context.read<UserBloc>().add(GetUsers());
  }

  // Future<void> setData(updatedUserDataStr) async {
  //   prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('usuarios', updatedUserDataStr);
  // }

  void _refresh() {
    context.read<UserBloc>().add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Usuarios'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _refresh();
              },
            ),
          ],
        ),
        body: const OnlineActions(),
        bottomNavigationBar: Container(
            margin: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(8.0)),
                  onPressed: _refresh,
                  child: const Icon(Icons.refresh),
                ),
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
            )));
  }
}

class OnlineActions extends StatelessWidget {
  const OnlineActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UsersState>(builder: (context, state) {
      if (state is Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is Loaded) {
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
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<UserBloc>()
                                      .add(DeleteUser(user.id!));
                                  context.read<UserBloc>().add(GetUsers());

                                  Navigator.of(context).pop();
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
      } else if (state is Error) {
        return Center(
          child: Text(state.error, style: const TextStyle(color: Colors.red)),
        );
      } else {
        return Container();
      }
    });
  }
}
