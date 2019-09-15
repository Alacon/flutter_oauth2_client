# flutter_oauth2_client

Flutter example for dart-lang/oauth2 package

Launch url to IdentityServer for Login

``` Dart
// Used to launch the url
import 'package:url_launcher/url_launcher.dart';

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
```

This is used for the callback to the app
The url should be registered in AndroidManifest.xml and Info.plist

``` Dart
final redirectUrl = Uri.parse("https://notused");
```

``` Dart
  initUrlListener() {
    getUriLinksStream().listen((Uri uri) async {
      var client = await grant.handleAuthorizationResponse(uri.queryParameters);
      setState(() {
        _client = client;
      });
    });
  }
```

``` Dart
import 'package:uni_links/uni_links.dart';
// Provides method for listening to url

getUriLinksStream().listen((Uri uri)
```
