import 'package:latlong2/latlong.dart';

import '../../core/enums/activity_mode.dart';
import '../../domain/entity/activity.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.id,
    required super.userId,
    required super.mileage,
    required super.steps,
    required super.activityId,
    required super.activityImg,
    required super.status,
    required super.mode,
    required super.dateTime,
    required super.duration,
    required super.durationInSeconds,
    required super.coordinates,
    required super.pointsEarned,
    required super.caloriesBurn,
  });

  factory ActivityModel.fromRemote(Map<String, dynamic> map) {
    Map<String, dynamic>? activity = map['activity'];
    return ActivityModel(
      id: map['id'],
      userId: map['user_id'],
      steps: map['steps'],
      activityId: map['activity_id'],
      mileage: map['mileage'],
      duration: map['duration_seconds'] != null
          ? Duration(seconds: map['duration_seconds'])
          : null,
      mode: _parseActivityMode(map['activity_id'] as int),
      status: activity != null ? activity['status'] : null,
      activityImg: activity != null ? activity['activity_img'] : null,
      durationInSeconds: map['duration_seconds'],
      caloriesBurn: map['calories_burn'],
      pointsEarned: map['points_earned'],
      dateTime: map['createdAt'],
      coordinates: _parseCoordFromRemote(map),
    );
  }

  static List<LatLng> _parseCoordFromRemote(Map<String, dynamic> data) {
    List<dynamic>? coordFromRemote = data['coordinates'];

    if (coordFromRemote == null) {
      return [];
    }

    List<LatLng> coordinates = coordFromRemote.map((coord) {
      final lat = coord['lat'] != null ? double.parse(coord['lat']) : 0.0;
      final long = coord['long'] != null ? double.parse(coord['long']) : 0.0;

      return LatLng(lat, long);
    }).toList();

    return coordinates;
  }

  static ActivityMode _parseActivityMode(int activityId) {
    switch (activityId) {
      case 1:
        return ActivityMode.Berjalan;
      case 3:
        return ActivityMode.Berlari;
      default:
        return ActivityMode.Berjalan;
    }
  }
}
