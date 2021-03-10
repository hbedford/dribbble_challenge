import 'dart:io';

import 'package:flutter/material.dart';

class Shot {
  int id;
  String title;
  String description;
  String publishedAt;
  String updateAt;
  String image;
  ValueNotifier<File> file;

  final TextEditingController titleEdit = TextEditingController();
  final TextEditingController descriptionEdit = TextEditingController();
  Shot() : this.file = ValueNotifier<File>(null);
  Shot.fromJson(Map map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.publishedAt = map['published_at'];
    this.updateAt = map['update_at'];
    this.image = map['images']['normal'];
    this.file = ValueNotifier<File>(null);
  }
  addImageFile(File value) => file.value = value;

  Map get toJson => {
        'id': this.id,
        'title': this.title,
        'description': this.description,
      };
  bool get isValidTitle => titleEdit.text.isNotEmpty;
  bool get isValidImage => file != null;
  bool get isValidShot => isValidTitle && isValidImage;

  List<String> get othersImages {
    List<String> list = List.filled(3, null);

    return list;
  }
}
