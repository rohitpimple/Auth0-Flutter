import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutterdemo/widgets/login.dart';
import 'package:flutterdemo/widgets/profile.dart';

const appScheme = 'flutterdemo';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  late String errorMessage;
  Credentials? _credentials;
  late Auth0 auth0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Login',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Auth0 Login'),
        ),
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : _credentials != null
                  ? Profile(logoutAction, _credentials?.user)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials =
          await auth0.webAuthentication(scheme: appScheme).login();

      setState(() {
        isBusy = false;
        _credentials = credentials;
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: appScheme).logout();

    setState(() {
      _credentials = null;
    });
  }

  void initState() {
    super.initState();

    auth0 = Auth0('dev-6npj05nvhxx0nyq4.us.auth0.com',
        'p3dGll1K6qlKX6lv08IstZnV7YgaMZE5');
    errorMessage = '';
  }
}
