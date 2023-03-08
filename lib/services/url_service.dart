import 'package:url_launcher/url_launcher.dart';

class UrlService {
  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  launchEmail () async{
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@goasbar.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Support',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  launchWebsite() async {
    if (!await launchUrl(Uri.parse("https://www.goasbar.com/"))) {
      throw 'Could not launch https://www.goasbar.com/';
    }
  }

  launchLink({String? link}) async {
    if (!await launchUrl(Uri.parse("https://www.goasbar.com/experience/$link"))) {
      throw 'Could not launch https://www.goasbar.com/';
    }
  }

  launchPhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+966 (483) -565 9898",
    );
    await launchUrl(launchUri);
  }
}