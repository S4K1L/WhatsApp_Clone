import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user_model.dart';

class UserDataNotifier extends StateNotifier<UserModel?> {
  UserDataNotifier() : super(null);

  // Function to update the user data
  void updateUser(UserModel user) {
    state = user;
  }

  // Optionally, you can also create a function to clear the user data
  void clearUser() {
    state = null;
  }
}
