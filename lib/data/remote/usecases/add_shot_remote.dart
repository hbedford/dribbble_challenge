import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddShotRemote {
  Future<bool> add(Shot shot) async {
    final controller = injection.get<LoginController>();
    var uri = Uri.parse("https://api.dribbble.com/v2/shots");
    var request = new MultipartRequest("POST", uri);
    var multipartFile = await MultipartFile.fromPath(
        "image", shot.file.value.path,
        contentType: MediaType('image',
            shot.isJpg ? 'jpeg' : shot.file.value.path.split('.').last));
    request.files.add(multipartFile);
    request.fields.addAll(Map.from(shot.toJson));
    request.fields.removeWhere((key, value) => value == null);
    request.headers['Authorization'] = 'Bearer ${controller.token}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      StreamedResponse response = await request.send();
      prefs.setBool('lostConnection', false);
      return response.reasonPhrase == 'Accepted';
    } catch (e) {
      prefs.setBool('lostConnection', true);
      return false;
    }
  }
}
