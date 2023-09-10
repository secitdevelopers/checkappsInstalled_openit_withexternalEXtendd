import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Installed Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InstalledAppsScreen(),
    );
  }
}

class InstalledAppsScreen extends StatefulWidget {
  @override
  _InstalledAppsScreenState createState() => _InstalledAppsScreenState();
}

class _InstalledAppsScreenState extends State<InstalledAppsScreen> {
  TextEditingController _controller = TextEditingController();

  Future<void> checkAppInstalled(BuildContext context) async {
    bool isInstalled = await DeviceApps.isAppInstalled(_controller.text);
    if (isInstalled) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('App Installed'),
            content: Text('The app is installed on your device.'),
            actions: <Widget>[
              TextButton(
                child: Text('Open App'),
                onPressed: () {
                  DeviceApps.openApp(_controller.text);
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('App Not Installed'),
            content: Text('The app is not installed on your device.'),
            actions: <Widget>[
              TextButton(
                child: Text('Install from Play Store'),
                onPressed: () {
                  launch(
                      'https://play.google.com/store/apps/details?id=${_controller.text}');
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Installed Apps")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter Package Name'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => checkAppInstalled(context),
            child: Text('Check if App is Installed'),
          ),
          Expanded(
            child: FutureBuilder<List<Application>>(
              future: DeviceApps.getInstalledApplications(
                includeSystemApps: false,
                includeAppIcons: true,
                onlyAppsWithLaunchIntent: true,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Application>? apps = snapshot.data;
                  return ListView.builder(
                    itemCount: apps!.length,
                    itemBuilder: (context, index) {
                      Application app = apps[index];

                      // Check if the application includes an icon
                      if (app is ApplicationWithIcon) {
                        return ListTile(
                          leading: Image.memory(app.icon),
                          // Display the app icon here
                          title: Text(app.appName),
                          onTap: () {
                            DeviceApps.openApp(app.packageName);
                          },
                        );
                      } else {
                        // This is in case the app does not have an icon, though it should since you requested it
                        return ListTile(
                          title: Text(app.appName),
                          onTap: () {
                            DeviceApps.openApp(app.packageName);
                          },
                        );
                      }
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

