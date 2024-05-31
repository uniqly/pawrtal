import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/models/user/app_user.dart';
import 'package:pawrtal/test/placeholder_images.dart';

class TestUser extends AppUser {
  final String _pfpString;
  final String _bannerString;
  final String _dispalyName;
  final String _handle;
  final String _location;
  final String _bio;
  final int _followsCount;
  final int _followersCount;

  TestUser(super.uid, this._pfpString, this._bannerString, this._dispalyName, this._handle,
      this._location, this._bio, this._followsCount, this._followersCount);

  @override
  String get pfp => _pfpString;
  @override
  String get banner => _bannerString;
  @override
  String get displayName => _dispalyName;
  @override
  String get handle => _handle;
  @override
  String get bio => _bio;
  @override
  String? get location => _location;
  @override
  int get followerCount => _followersCount;
  @override
  int get followsCount => _followsCount;
}

final mainUser = TestUser('0', pfpMe, banner1, 'fiyora', 'samoyedfluffy',
    'Singapore', 'Hello, its a me samoyed', 841, 30400);