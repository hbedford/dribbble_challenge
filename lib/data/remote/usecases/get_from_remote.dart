import 'package:dribbble_challenge/domain/entities/shot.dart';
import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/login/login_controller.dart';
import 'package:http/http.dart';

class GetFromRemote {
  Future<List<Shot>> fetch() async {
    final controller = injection.get<LoginController>();
    HttpAdapter httpClient = HttpAdapter(Client());

    try {
      var res = await httpClient.request(
        url:
            'https://api.dribbble.com/v2/user/shots?access_token=${controller.token}',
        method: 'get',
      );
      print(res);
      return res == null
          ? null
          : res.map<Shot>((shot) => Shot.fromJson(shot)).toList();
    } catch (e) {
      return null;
    }
  }
}
