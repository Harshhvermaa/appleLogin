import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SignInPage(title: "Apple Sign In"));
  }
}

class GreetingPage extends StatelessWidget {
  final _user;

  const GreetingPage({user}) : _user = user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greetings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('display name: ${_user.displayName}'),
            Text('email: ${_user.email}'),
            Text('provider id: ${_user.providerId}'),
            MaterialButton(
                color: Colors.lightGreen,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final String _stateDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   _stateDescription,
            // ),
            SizedBox(
              width: 150,
              child: SignInWithAppleButton(
                onPressed: () async {
                  final appleIdCredential =
                      await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                    webAuthenticationOptions: WebAuthenticationOptions(
                      clientId: "<CLIENT_ID>",
                      redirectUri: Uri.parse(
                        "",
                      ),
                    ),
                  );

                  // get an OAuthCredential
                  final credential = OAuthProvider(
                    'apple.com',
                  ).credential(
                    idToken: appleIdCredential.identityToken,
                    accessToken: appleIdCredential.authorizationCode,
                  );

                  // use the credential to sign in to firebase
                  await FirebaseAuth.instance.signInWithCredential(credential);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
