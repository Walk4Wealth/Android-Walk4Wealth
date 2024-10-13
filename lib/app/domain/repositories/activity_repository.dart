import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';

import '../../core/error/failure.dart';
import '../entity/activity.dart';

abstract interface class ActivityRepository {
  Future<Either<Failure, Activity>> createActivity({
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  });

  Future<Either<Failure, List<Activity>>> getActivity();
}
