import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:usersappv/features/users/presentation/pages/TestWidget.dart';
import 'package:usersappv/features/users/presentation/pages/list_users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<ConnectivityResult> subscription;
  bool internetConnection = true;

  @override
  void initState() {
    super.initState();
    // Escucha los cambios en la conectividad
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        if (result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {
          internetConnection = true;
          print('Estás conectado a internet');
        } else {
          internetConnection = false;
          print('No estás conectado a ninguna red');
        }
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel(); // Cancela la suscripción al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return internetConnection
        ? const ListUsers()
        : TestWd(internetConnection: internetConnection);
  }
}
