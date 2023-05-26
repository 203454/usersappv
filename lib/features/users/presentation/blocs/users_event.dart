part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsers extends UsersEvent {}

class GetUsersOffline extends UsersEvent {}

class DeleteUser extends UsersEvent {
  final int idUser;
  DeleteUser(this.idUser);
}

class AddUser extends UsersEvent {
  final User user;
  AddUser(this.user);
}

class UpdateUser extends UsersEvent {
  final User user;
  UpdateUser(this.user);
}
