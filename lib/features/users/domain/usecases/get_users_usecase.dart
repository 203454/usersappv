import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/domain/repositories/user_respository.dart';

class GetUsersUsecase {
  final UserRepository userRepository;
  GetUsersUsecase(this.userRepository);

  Future<List<User>> execute() async {
    return await userRepository.getUsers();
  }
}
