import 'package:usersappv/features/users/data/datasources/user_remote_data_source.dart';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/domain/repositories/user_respository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    return await userRemoteDataSource.getUsers();
  }

  @override
  Future<void> deleteUser(int idUser) async {
    return await userRemoteDataSource.deleteUser(idUser);
  }

  @override
  Future<User> addUser(User user) async {
    return await userRemoteDataSource.addUser(user);
  }

  @override
  Future<User> updateUser(User user) async {
    return await userRemoteDataSource.updateUser(user);
  }
}
