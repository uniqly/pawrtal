import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/test/placeholder_images.dart';

class SubPawrtal {
  final String name;
  final String _pictureString;
  final String _bannerString;

  SubPawrtal(this.name, [this._pictureString = '', this._bannerString = '']);

  AssetImage get portalPfp { 
    try {
      return AssetImage(_pictureString);
    } catch (e) {
      log('invalid assset: $_pictureString', error: e);
      return const AssetImage(noPfp);
    }
  }
  
  AssetImage get banner { 
    try {
      return AssetImage(_bannerString);
    } catch (e) {
      log('invalid assset: $_bannerString', error: e);
      return const AssetImage(noPfp);
    }
  }
}