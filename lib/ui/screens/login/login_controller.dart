import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController {
  final String clientId =
      'e33bae85741de3a0191aba225f64f0b06c4b9fa77110225f300c7c3af2f0addc';
  final String secretClient =
      '09ee717389eba9cd0d29cd5f7d27e3aa063d2f3eba2abefa76af40c76f83b3fc';

  String code;
  String token;

  static const stream = const EventChannel('poc.deeplink.flutter.dev/events');

  LoginController() {
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(String uri) async {
    closeWebView();
    changeCode(uri.split('=').last);
    print(code);
    getToken();
  }

  login() async {
    await launch(url, forceSafariVC: true, forceWebView: false);
  }

  changeCode(String value) => code = value;

  void getToken() async {
    HttpAdapter httpClient = HttpAdapter(Client());

    Map res = await httpClient.request(
      url:
          'https://dribbble.com/oauth/token?client_id=$clientId&client_secret=$secretClient&code=$code',
      method: 'post',
    );
    token = res['access_token'];
    saveToken(res['access_token']);
  }

  void saveToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = value;
    print(value + ' Token');
    if (token != null) {
      prefs.setString('token', value);
    }
  }

  String get url =>
      'https://dribbble.com/oauth/authorize?client_id=$clientId&redirect_uri=poc://deeplink.flutter.dev&scope=public+upload';
}
