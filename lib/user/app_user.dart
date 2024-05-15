import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/test/placeholder_images.dart';

class AppUser {
  final String uid;
  
  // TODO: Integrate firebase with users
  // temp solution for display name
  String _tempDisplayName;
  String _tempPfpString;

  AppUser._(this.uid, [this._tempDisplayName = '', this._tempPfpString = '']);

  // create test user
  AppUser.testUser(String uid, {String name = '', String pfp = ''}) : this._(uid, name, pfp);

  AssetImage get pfp {
    try {
      return AssetImage(_tempPfpString);
    } catch (e) {
      log('invalid assset: $_tempPfpString', error: e);
      return const AssetImage(noPfp);
    }
  }

  String get displayName => _tempDisplayName;

  // TODO: implement get friends from database
  Stream<AppUser> get following async* {
    var friends = [ 
      AppUser._('1', 'furryfriend', pfpOther),
      AppUser._('2', 'thatfriend1'),
    ];
    for (var friend in friends) {
      yield friend;
    }
  }

}