import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/enums/request_state.dart';
import '../../core/routes/navigate.dart';
import '../../core/utils/dialog/w_dialog.dart';
import '../../domain/entity/activity.dart';
import '../../domain/usecases/activity/create_activity.dart';
import '../../domain/usecases/activity/get_activity.dart';
import 'tracking_provider.dart';
import 'user_provider.dart';

class ActivityProvider extends ChangeNotifier {
  final CreateActivity _createActivity;
  final GetActivity _getActivity;

  ActivityProvider({
    required CreateActivity createActivity,
    required GetActivity getActivity,
  })  : _createActivity = createActivity,
        _getActivity = getActivity;

  RequestState _getActivityState = RequestState.LOADING;
  RequestState get getActivityState => _getActivityState;

  Activity? _activity;
  Activity? get activity => _activity;

  var _activities = <Activity>[];
  List<Activity> get activities => _activities;

  String? _erroMessage;
  String? get errorMessage => _erroMessage;

  //* get activity
  Future<void> getActivity() async {
    // loading
    _getActivityState = RequestState.LOADING;
    notifyListeners();

    // get activity
    final activities = await _getActivity.call();

    // state
    activities.fold(
      (failure) {
        _erroMessage = failure.message;
        _getActivityState = RequestState.FAILURE;
        notifyListeners();
      },
      (activites) {
        _activities = activites;
        _erroMessage = null;
        _getActivityState = RequestState.SUCCESS;
        notifyListeners();
      },
    );
  }

  //* create activity
  Future<void> createActivity(
    BuildContext context, {
    required int activityId,
    required int duration,
    required int mileage,
    required int steps,
    required List<LatLng> coordinates,
  }) async {
    // loading
    WDialog.showLoading(context);

    // create activity
    final createActivity = await _createActivity.call(
      activityId: activityId,
      duration: duration,
      mileage: mileage,
      steps: steps,
      coordinates: coordinates,
    );

    // state
    createActivity.fold((failure) {
      WDialog.closeLoading();
      WDialog.showDialog(
        context,
        icon: const Icon(Icons.info_outline),
        title: 'Terjadi Kesalahan',
        message: '${failure.message} \n[${failure.code}]',
        actions: [
          DialogAction(
            label: 'Coba lagi',
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    }, (activity) {
      //set activity
      _activity = activity;
      notifyListeners();

      // ketika berhasil menyimpan aktivitas
      // maka reset data aktivitas dan update user untuk mendapatkan jumlah koin terbaru
      context.read<TrackingProvider>().resetTrackingData();
      context.read<UserProvider>().updateProfile();
      WDialog.closeLoading();
      Navigator.pushNamedAndRemoveUntil(
        context,
        To.ACTIVITY_SAVE_CONFIRM,
        (route) => route.isFirst,
      );
    });
  }
}
