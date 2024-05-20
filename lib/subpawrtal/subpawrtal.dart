import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/test/placeholder_images.dart';

class SubPawrtal {
  final String name;
  final String _pictureString;

  SubPawrtal(this.name, [this._pictureString = '']);

  AssetImage get portalPfp { 
    try {
      return AssetImage(_pictureString);
    } catch (e) {
      log('invalid assset: $_pictureString', error: e);
      return const AssetImage(noPfp);
    }
  }
}