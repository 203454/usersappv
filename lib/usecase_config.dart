import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:usersappv/features/users/data/datasources/user_remote_data_source.dart';
import 'package:usersappv/features/users/data/repositories/user_repository_impl.dart';
import 'package:usersappv/features/users/domain/usecases/add_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/delete_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/edit_users_usecase.dart';
import 'package:usersappv/features/users/domain/usecases/get_users_usecase.dart';

class UsecaseConfig {
  GetUsersUsecase? getUsersUsecase;
  DeleteUsersUsecase? deleteUsersUsecase;
  AddUsersUsecase? addUsersUsecase;
  UpdateUsersUsecase? updateUserUseCase;
  UserRemoteDataSource? userRemoteDataSourceImp;
  UserRepositoryImpl? userRepositoryImpl;

  UsecaseConfig() {
    userRemoteDataSourceImp = UserRemoteDataSourceImpl();

    userRepositoryImpl =
        UserRepositoryImpl(userRemoteDataSource: userRemoteDataSourceImp!);
    getUsersUsecase = GetUsersUsecase(userRepositoryImpl!);
    deleteUsersUsecase = DeleteUsersUsecase(userRepositoryImpl!);
    addUsersUsecase = AddUsersUsecase(userRepositoryImpl!);
    updateUserUseCase = UpdateUsersUsecase(userRepositoryImpl!);
  }
}
