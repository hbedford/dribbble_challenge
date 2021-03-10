import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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
  BuildContext context;
  ValueNotifier<bool> isLoading;
  static const stream = const EventChannel('poc.deeplink.flutter.dev/events');

  LoginController() {
    isLoading = ValueNotifier<bool>(false);
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(String uri) async {
    changeLoading(true);
    closeWebView();
    changeCode(uri.split('=').last);
    getToken();
  }

  login() async {
    await launch(url, forceSafariVC: true, forceWebView: false);
  }

  changeCode(String value) => code = value;

  void getToken() async {
    HttpAdapter httpClient = HttpAdapter(Client());

    try {
      Map res = await httpClient.request(
        url:
            'https://dribbble.com/oauth/token?client_id=$clientId&client_secret=$secretClient&code=$code',
        method: 'post',
      );
      token = res['access_token'];
      saveToken(res['access_token']);
      navigateTo('/home');
    } catch (e) {
      return null;
    }
  }

  void saveToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = value;
    if (value != null) {
      prefs.setString('token', value);
    }
  }

  Future<bool> checkToken() async {
    HttpAdapter httpClient = HttpAdapter(Client());

    try {
      final res = await httpClient.request(
          url: 'https://api.dribbble.com/v2/user',
          method: 'get',
          headers: {'Authorization': 'Bearer $token'});
      return res != null;
    } catch (e) {
      return false;
    }
  }

  void loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('token');
    if (value != null) {
      print(value + ' token');
      token = value;
      bool isValid = await checkToken();
      if (isValid) {
        navigateTo('/home');
      } else {
        navigateTo('/login');
        Future.delayed(Duration(seconds: 1), () {
          Flushbar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            title: 'Ops, houve um problema',
            message: 'Certifique que sua conexão esteja estavel.',
          ).show(context);
        });
      }
    } else
      navigateTo('/login');
  }

  changeContext(BuildContext ctxt) => context = ctxt;
  navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  changeLoading(bool value) => isLoading.value = value;

  String get url =>
      'https://dribbble.com/oauth/authorize?client_id=$clientId&redirect_uri=poc://deeplink.flutter.dev&scope=public+upload';
}
