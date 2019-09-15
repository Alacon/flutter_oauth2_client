import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'extract_token_info.dart';

final authorizationEndpoint =
    Uri.parse("https://identityurl/connect/authorize");
final tokenEndpoint = Uri.parse("https://identityurl/connect/token");
final identifier = "IDENTITYSERVER_CLIENT_ID";
final secret = "SOME_SECRET";
final redirectUrl = Uri.parse("https://notused");
final credentialsFile = new File("~/.myapp/credentials.json");
final _scopes = ['openid ', 'profile'];

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  oauth2.AuthorizationCodeGrant grant;
  oauth2.Client _client;

  Uri _uri;

  @override
  void initState() {
    super.initState();
    grant = new oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint,
        secret: secret);
    _uri = grant.getAuthorizationUrl(redirectUrl, scopes: _scopes);
    initUrlListener();
  }

  // This is used for the callback to the app
  // The url should be registered in AndroidManifest.xml and Info.plist
  initUrlListener() {
    getUriLinksStream().listen((Uri uri) async {
      var client = await grant.handleAuthorizationResponse(uri.queryParameters);
      setState(() {
        _client = client;
      });
    });
  }

  signin() async {
    
    // Use this to decide which idp to use, Google or GitHub and so on
    // var parameters = {"acr_values": "idp:AzureAD"}; 
    // var idpUri = addQueryParameters(_uri, parameters);
    //var url =  idpUri.toString();


    var url = _uri.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: new Text("Sign in"),
          onPressed: () => {signin()},
        ),
      ),
      body: Center(
        child: Padding(
          child: Column(
            children: <Widget>[
              Text(_client?.credentials?.accessToken ?? 'Not signed in yet'),
              // ExtractTokenInfo(token: _client?.credentials?.accessToken), // Uncomment to display name from claims
            ],
          ),
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        ),
      ),
    );
  }
}

Uri addQueryParameters(Uri url, Map<String, String> parameters) => url.replace(
    queryParameters: new Map.from(url.queryParameters)..addAll(parameters));
