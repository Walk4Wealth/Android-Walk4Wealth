import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_type.dart';
import '../../../core/network/device_connection.dart';
import '../../../core/network/dio_client.dart';
import '../../../domain/usecases/auth/get_token.dart';
import '../../models/activity_model.dart';

abstract interface class ActivityRemoteDatasource {
  Future<ActivityModel> createActivity({
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  });

  Future<List<ActivityModel>> getActivity();
}

class ActivityRemoteDatasourceImpl implements ActivityRemoteDatasource {
  final DioClient _dioClient;
  final GetToken _getToken;
  final DeviceConnection _connection;

  ActivityRemoteDatasourceImpl({
    required DioClient dioClient,
    required GetToken getToken,
    required DeviceConnection connection,
  })  : _dioClient = dioClient,
        _getToken = getToken,
        _connection = connection;

  @override
  Future<ActivityModel> createActivity({
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  }) async {
    if (await _connection.hasConnection()) {
      try {
        // convert data latlng ke Map<String, String>
        final coordinatesData = coordinates.map((coord) {
          return {
            'lat': coord.latitude.toString(),
            'long': coord.longitude.toString(),
          };
        }).toList();

        final token = _getToken.call().token;
        final response = await _dioClient.post(
          endpoint: '/activity',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'activity_id': activityId,
            'duration_seconds': duration,
            'mileage': mileage,
            'steps': steps,
            'coordinates': coordinatesData,
          },
        );

        log('berhasil membuat aktivitas, latlong yang dikirimkan $coordinatesData');

        // parsing data
        final activity = ActivityModel.fromRemote(response.data['data']);

        return activity;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<List<ActivityModel>> getActivity() async {
    if (await _connection.hasConnection()) {
      try {
        final token = _getToken.call().token;
        final response = await _dioClient.get(
          endpoint: '/activity/my-activity',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        // parsing data
        final activities = (response.data['data'] as List<dynamic>)
            .map((data) => ActivityModel.fromRemote(data))
            .toList();

        return activities;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }
}
