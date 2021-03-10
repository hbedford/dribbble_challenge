import 'dart:convert';
import 'dart:io';

import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class ShotController {
  final ValueNotifier<Shot> shot = ValueNotifier<Shot>(null);
  ShotController();

  changeShot(Shot value) => shot.value = value;

  Future getImage({bool send = false, BuildContext context}) async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      var image = decodeImage(file.readAsBytesSync());
      var img = copyResize(image, width: 400, height: 300);
      File newFile = await File(pickedFile.path).writeAsBytes(encodePng(img));
      shot.value.addImageFile(newFile);
      if (send) sendAttachment(context);
    } else {
      print('No image selected.');
    }
  }

  sendShot(BuildContext context) async {
    if (shot.value.isValidShot) {
      final controller = injection.get<LoginController>();
      var uri = Uri.parse("https://api.dribbble.com/v2/shots");
      var request = new MultipartRequest("POST", uri);
      var multipartFile = await MultipartFile.fromPath(
          "image", shot.value.file.value.path,
          contentType:
              MediaType('image', shot.value.file.value.path.split('.').last));
      request.files.add(multipartFile);
      request.fields.addAll(shot.value.toJson);
      request.headers['Authorization'] = 'Bearer ${controller.token}';

      StreamedResponse response = await request.send();
      print(response.reasonPhrase);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else
      Flushbar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        title: 'Ops, falta informações',
        message: 'É necessario ter a imagem e titulo para criar o Shot',
      ).show(context);
  }

  sendAttachment(BuildContext context) async {
    final controller = injection.get<LoginController>();
    print(shot.value.id);
    var uri = Uri.parse(
        "https://api.dribbble.com/v2/shots/${shot.value.id}/attachments");
    var request = new MultipartRequest("POST", uri);
    var multipartFile = await MultipartFile.fromPath(
        "file", shot.value.file.value.path,
        contentType:
            MediaType('image', shot.value.file.value.path.split('.').last));
    request.headers['Authorization'] = 'Bearer ${controller.token}';
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    if (response.statusCode == 403) {
      Flushbar(
        backgroundColor: Colors.red,
        title: 'Ops, ocorreu algo de errado',
        message:
            'Para enviar uma imagem é necessario ser membro de uma equipe. Para isso é necessario que você escolha um plano no Dribbble',
        duration: Duration(seconds: 10),
      ).show(context);
    }
  }
}
