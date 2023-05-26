import 'package:usersappv/features/users/domain/repositories/user_respository.dart';

class DeleteUsersUsecase {
  final UserRepository userRepository;
  DeleteUsersUsecase(this.userRepository);

  Future<void> execute(int idUser) async {
    return await userRepository.deleteUser(idUser);
  }
}
