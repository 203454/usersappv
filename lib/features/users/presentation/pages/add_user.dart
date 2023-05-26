import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/presentation/blocs/users_bloc.dart';

class FormAddUser extends StatefulWidget {
  final User? userModel;
  final String actionButton;
  const FormAddUser({Key? key, this.userModel, required this.actionButton})
      : super(key: key);
  @override
  State<FormAddUser> createState() => _FormAddUserState();
}

class _FormAddUserState extends State<FormAddUser> {
  late UserBloc userBloc;
  final _formKey = GlobalKey<FormState>();

  late StreamSubscription<ConnectivityResult> subscription;
  bool internetConnection = false;
  List<UsersEvent> eventsUpdate = [];
  late SharedPreferences prefs;
  String? userDataStr = "";

  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'last_name': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);

    updateData();
    if (widget.userModel != null) {
      _controllers['name']!.text = widget.userModel!.name;
      _controllers['last_name']!.text = widget.userModel!.lastName;
      _controllers['username']!.text = widget.userModel!.username;
      _controllers['email']!.text = widget.userModel!.email;
    }

    fetchData();
  }

  Future<void> updateData() async {
    if (mounted) {
      for (var event in eventsUpdate) {
        userBloc.add(event); // Usar la referencia local del BlocProvider
      }
      eventsUpdate.clear();
    }
  }

  Future<void> fetchData() async {
    prefs = await SharedPreferences.getInstance();
    userDataStr = prefs.getString('usuarios');
  }

  Future<void> setData(updatedUserDataStr) async {
    await prefs.setString('usuarios', updatedUserDataStr);
  }

  @override
  void dispose() {
    updateData();

    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  // context.read<UserBloc>().add(GetUsers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añadir libro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildTextFields(),
            )),
      ),
      bottomNavigationBar: internetConnection
          ? ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (widget.userModel != null) {
                    final nuevoUsuario = User(
                      id: widget.userModel?.id,
                      username: _controllers['username']!.text,
                      name: _controllers['name']!.text,
                      email: _controllers['email']!.text,
                      lastName: _controllers['last_name']!.text,
                    );
                    BlocProvider.of<UserBloc>(context)
                        .add(UpdateUser(nuevoUsuario));
                  } else {
                    final nuevoUsuario = User(
                      username: _controllers['username']!.text,
                      name: _controllers['name']!.text,
                      email: _controllers['email']!.text,
                      lastName: _controllers['last_name']!.text,
                    );
                    context.read<UserBloc>().add(AddUser(nuevoUsuario));
                    // BlocProvider.of<UserBloc>(context).add(AddUser(nuevoUsuario));
                  }
                }
              },
              child: Text(widget.actionButton),
            )
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (widget.userModel != null) {
                    final nuevoUsuario = User(
                      id: widget.userModel?.id,
                      username: _controllers['username']!.text,
                      name: _controllers['name']!.text,
                      email: _controllers['email']!.text,
                      lastName: _controllers['last_name']!.text,
                    );
                    String? userDataStr = prefs.getString('usuarios');
                    if (userDataStr != null) {
                      List<dynamic> dataUsers = jsonDecode(userDataStr);
                      int idToUpdate = nuevoUsuario.id!;
                      for (int i = 0; i < dataUsers.length; i++) {
                        var user = dataUsers[i];
                        if (user['id'] == idToUpdate) {
                          user['username'] = nuevoUsuario.username;
                          user['name'] = nuevoUsuario.name;
                          user['email'] = nuevoUsuario.email;
                          user['lastName'] = nuevoUsuario.lastName;
                          break;
                        }
                      }
                      String updatedUserDataStr = jsonEncode(dataUsers);
                      prefs.clear();
                      prefs.setString('usuarios', updatedUserDataStr);
                      setData(updatedUserDataStr);
                      eventsUpdate.add(UpdateUser(nuevoUsuario));
                      context.read<UserBloc>().add(GetUsersOffline());
                      print('Editado offline');
                    }
                  } else {
                    // Codigo para agregar un usuario
                    final nuevoUsuario = User(
                      username: _controllers['username']!.text,
                      name: _controllers['name']!.text,
                      email: _controllers['email']!.text,
                      lastName: _controllers['last_name']!.text,
                    );

                    String? userDataStr = prefs.getString('usuarios');
                    List<dynamic> dataUsers = [];
                    if (userDataStr != null) {
                      dataUsers = jsonDecode(userDataStr);
                    }
                    dataUsers.add(nuevoUsuario.toJson());
                    String updatedUserDataStr = jsonEncode(dataUsers);
                    prefs.setString('usuarios', updatedUserDataStr);
                    setData(updatedUserDataStr);
                    eventsUpdate.add(AddUser(nuevoUsuario));
                    context.read<UserBloc>().add(GetUsersOffline());
                  }
                }
                Navigator.pop(context);
              },
              child: Text(widget.actionButton),
            ),
    );
  }

  List<Widget> _buildTextFields() {
    return _controllers.keys.map((key) {
      return TextField(
        controller: _controllers[key],
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        decoration: InputDecoration(
          hintText: key,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 231, 0, 0),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(169, 0, 0, 0),
              width: 2.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
