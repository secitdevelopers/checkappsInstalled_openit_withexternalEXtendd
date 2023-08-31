import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Launcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoLauncherScreen(),
    );
  }
}

class VideoLauncherScreen extends StatelessWidget {
  Future<void> _launchURL(BuildContext context, String url) async {
    bool isAppInstalled = await DeviceApps.isAppInstalled('com.google.android.youtube');

    if (isAppInstalled) {
      // If the app is installed, try to launch the URL
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open the video. Try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } else {
      // If the app is not installed, prompt the user to install it
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('App not installed'),
          content: Text(
              'yt is not installed on your device. Do you want to install it?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Install'),
              onPressed: () {
                launch('https://play.google.com/store/apps/details?id=com.google.android.youtube&hl=en_US');
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('apps'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchURL(context, 'https://www.youtube.com/watch?v=KfHQWHqnIuM');
          },
          child: Text('Play Video'),
        ),
      ),
    );
  }
}
