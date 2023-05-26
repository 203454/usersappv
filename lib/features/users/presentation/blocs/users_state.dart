part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class Loading extends UsersState {}

class Loaded extends UsersState {
  final List<User> users;
  Loaded({required this.users});
}

class Error extends UsersState {
  final String error;

  Error({required this.error});
}

class UserDeleted extends UsersState {}

class UserAdded extends UsersState {}

class UserUpdated extends UsersState {}
