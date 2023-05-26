import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> deleteUser(int idUser);
  Future<User> addUser(User user);
  Future<User> updateUser(User user);
}
