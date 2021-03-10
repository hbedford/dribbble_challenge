import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:flutter/material.dart';

class HomeController {
  ValueNotifier<List<Shot>> list = ValueNotifier<List<Shot>>([]);
  HomeController();
}
