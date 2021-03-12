import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Shot {
  int id;
  int remoteId;
  String title;
  String description;
  String publishedAt;
  String updateAt;
  String image;
  List<String> attachments;
  ValueNotifier<File> file;
  ValueNotifier<String> textError;
  ValueNotifier<bool> haveImage;

  TextEditingController titleEdit;
  TextEditingController descriptionEdit;
  Shot() {
    this.attachments = [];
    this.titleEdit = TextEditingController();
    this.descriptionEdit = TextEditingController();
    this.file = ValueNotifier<File>(null);
    this.textError = ValueNotifier<String>(null);
    this.haveImage = ValueNotifier<bool>(true);
  }
  Shot.fromJson(Map map) {
    this.id = map['id'];
    this.remoteId = map['id'];
    this.title = map['title'];

    this.description = map['description'];
    this.publishedAt = map['published_at'];
    this.updateAt = map['update_at'];
    this.image = map['images']['normal'];
    this.attachments = List<String>.from(
        map['attachments'].map((data) => data['url']).toList());
    this.file = ValueNotifier<File>(null);
    this.textError = ValueNotifier<String>(null);
  }
  Shot.fromMap(Map map) {
    this.id = map['id'];
    this.remoteId = map['remoteid'];
    this.title = map['title'];
    this.description = map['description'];
    this.publishedAt = map['published_at'];
    this.updateAt = map['update_at'];
    this.image = map['normal'];
    /*   this.attachments = List<String>.from(
        map['attachments']?.map((data) => data['url']).toList()); */
    this.file = ValueNotifier<File>(null);
    this.textError = ValueNotifier<String>(null);
  }
  addImageFile(File value) => file.value = value;
  changeErrorText(String value) => textError.value = value;
  changeHaveImage(bool value) => haveImage.value = value;
  Map get toJson => {
        'title': titleEdit.text,
        'description':
            descriptionEdit.text.isNotEmpty ? descriptionEdit.text : null,
      };
  Future<Map<String, dynamic>> get toMap async {
    if (file.value == null) {
      file.value = await _fileFromImageUrl();
    }
    List<int> imageBytes = await file.value.readAsBytes();
    String img = base64Encode(imageBytes);
    return {
      'title': title ?? titleEdit.text,
      'remoteid': remoteId,
      'image': img,
    };
  }

  Future<File> _fileFromImageUrl() async {
    final response = await http.get(image);

    final documentDirectory = await getApplicationDocumentsDirectory();

    final f = File(join(documentDirectory.path, 'image.jpg'));

    f.writeAsBytesSync(response.bodyBytes);

    return f;
  }

  bool get isValidTitle => titleEdit.text.isNotEmpty;
  bool get isValidImage => file.value != null;
  bool get isValidShot => isValidTitle && isValidImage;
  String get formatFile =>
      file.value != null ? file.value.path.split('.').last : null;
  bool get isJpg => formatFile != null
      ? formatFile == 'jpg' || formatFile == 'jpeg'
          ? true
          : false
      : null;
  List<String> get othersImages {
    List<String> list = List.filled(3, null);

    return list;
  }
}
