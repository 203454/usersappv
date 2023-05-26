import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';
import 'package:usersappv/features/users/domain/repositories/user_respository.dart';

class AddUsersUsecase {
  final UserRepository userRepository;
  AddUsersUsecase(this.userRepository);

  Future<User> execute(User user) async {
    return await userRepository.addUser(user);
  }
}
