import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:flutter/material.dart';

class ShotController {
  final ValueNotifier<Shot> shot = ValueNotifier<Shot>(null);
  ShotController();
  changeShot(Shot value) => shot.value = value;
}
