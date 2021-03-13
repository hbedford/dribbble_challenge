import 'dart:io';

import 'package:dribbble_challenge/data/cache/use/cases/add_to_database.dart';
import 'package:dribbble_challenge/data/remote/usecases/add_shot_remote.dart';
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
  bool isJpg;
  changeShot(Shot value) => shot.value = value;

  Future getImage({bool send = false, BuildContext context}) async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      var image = decodeImage(file.readAsBytesSync());
      var img = copyResize(image, width: 400, height: 300);

      if (file.path.split('.').last == 'png')
        isJpg = false;
      else
        isJpg = true;
      File newFile = await File(pickedFile.path)
          .writeAsBytes(isJpg ? encodeJpg(img) : encodePng(img));
      shot.value.addImageFile(newFile);
      if (send) sendAttachment(context);
    } else {
      print('No image selected.');
    }
  }

  sendShot(BuildContext context) async {
    if (shot.value.isValidShot) {
      if (await AddShotRemote().add(shot.value)) {
        Navigator.pop(context, true);
      } else {
        print('b');
        await AddToDatabase().addWaiting(shot.value);
        Flushbar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          title: 'Ops, houve um problema',
          message:
              'Ocorreu algo de errado no enviado do Shot para remoto.\ Mas não se preocupe, quando voltar a conexão sera enviado',
        ).show(context);
      }
    } else {
      if (!shot.value.isValidImage) {
        shot.value.changeHaveImage(false);
      }
      if (!shot.value.isValidTitle) {
        shot.value.changeErrorText('É necessario inserir um titulo.');
      }
      Flushbar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        title: 'Ops, falta informações',
        message: 'É necessario ter a imagem e titulo para criar o Shot',
      ).show(context);
    }
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
