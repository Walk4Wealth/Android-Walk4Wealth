import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/failure.dart';
import '../../entity/activity.dart';
import '../../repositories/activity_repository.dart';

class CreateActivity {
  final ActivityRepository _repository;

  CreateActivity({
    required ActivityRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, Activity>> call({
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  }) async {
    return await _repository.createActivity(
      activityId: activityId,
      duration: duration,
      mileage: mileage,
      steps: steps,
      coordinates: coordinates,
    );
  }
}
