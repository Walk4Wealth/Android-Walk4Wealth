import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entity/user.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, User>> updateUser();
  Future<void> deleteUser();
}
