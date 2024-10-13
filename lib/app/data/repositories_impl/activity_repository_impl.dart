import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/failure.dart';
import '../../domain/entity/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity/activity_remote_datasource.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDatasource _remoteDatasource;

  ActivityRepositoryImpl({
    required ActivityRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, Activity>> createActivity({
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  }) async {
    try {
      final activity = await _remoteDatasource.createActivity(
        activityId: activityId,
        duration: duration,
        mileage: mileage,
        steps: steps,
        coordinates: coordinates,
      );
      return right(activity);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivity() async {
    try {
      final activities = await _remoteDatasource.getActivity();
      return right(activities);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }
}
