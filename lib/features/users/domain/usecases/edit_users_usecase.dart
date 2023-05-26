import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/domain/repositories/user_respository.dart';

class UpdateUsersUsecase {
  final UserRepository userRepository;
  UpdateUsersUsecase(this.userRepository);

  Future<User> execute(User user) async {
    return await userRepository.updateUser(user);
  }
}
