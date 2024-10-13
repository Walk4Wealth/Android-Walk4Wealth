import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../core/enums/activity_mode.dart';

class Activity extends Equatable {
  final int id;
  final int userId;
  final int activityId;
  final String? activityImg;
  final int? steps;
  final String? status;
  final int? mileage;
  final ActivityMode? mode;
  final Duration? duration;
  final int? durationInSeconds;
  final int? pointsEarned;
  final num? caloriesBurn;
  final String? dateTime;
  final List<LatLng>? coordinates;

  const Activity({
    required this.id,
    required this.userId,
    required this.activityId,
    required this.activityImg,
    required this.mileage,
    required this.steps,
    required this.mode,
    required this.status,
    required this.duration,
    required this.pointsEarned,
    required this.dateTime,
    required this.durationInSeconds,
    required this.coordinates,
    required this.caloriesBurn,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      steps,
      activityId,
      activityImg,
      mileage,
      mode,
      duration,
      status,
      durationInSeconds,
      caloriesBurn,
      dateTime,
      coordinates,
      pointsEarned,
    ];
  }
}
