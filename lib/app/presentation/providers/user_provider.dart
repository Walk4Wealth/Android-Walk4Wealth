import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/request_state.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecases/user/get_user.dart';
import '../../domain/usecases/user/update_user.dart';

class UserProvider extends ChangeNotifier {
  // use case
  final GetUser _getUser;
  final UpdateUser _updateUser;

  UserProvider({
    required UpdateUser updateUser,
    required GetUser getUser,
  })  : _updateUser = updateUser,
        _getUser = getUser;

  RequestState _state = RequestState.INIT;
  RequestState get state => _state;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  File? _imgProfile;

  dynamic getImgProfile() {
    if (_imgProfile != null) {
      return FileImage(_imgProfile!);
    }
    return const AssetImage(AssetImg.noProfile);
  }

  //* get profile
  Future<void> getProfile() async {
    // loading
    _setState(RequestState.LOADING);

    // get user
    final profile = await _getUser.call();

    // state
    profile.fold(
      (failure) {
        _setState(RequestState.FAILURE);

        // set error message
        _errorMessage = failure.message;
        notifyListeners();
      },
      (user) {
        _setState(RequestState.SUCCESS);

        // set user
        _user = user;
        notifyListeners();
      },
    );
  }

  //* update profile
  void updateProfile() async {
    final newProfile = await _updateUser.call();

    newProfile.fold(
      (failure) {},
      (newUser) {
        _user = newUser;
        notifyListeners();
      },
    );
  }

  void updateImgProfile(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return _materialBottomSheet(context);
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imgProfile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Widget _materialBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Update foto profil',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              'Ambil dari kamera',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: const Icon(Iconsax.camera),
            onTap: () async {
              Navigator.pop(context);
              await _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            title: Text(
              'Ambil dari galeri',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: const Icon(Iconsax.gallery),
            onTap: () async {
              Navigator.pop(context);
              await _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _setState(RequestState state) {
    _state = state;
    notifyListeners();
  }
}
