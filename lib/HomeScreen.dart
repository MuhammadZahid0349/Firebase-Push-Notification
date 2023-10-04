import 'dart:convert';

import 'package:fbn_app/Notification%20Screen/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("Deveice token: " + value);
    });
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
                onPressed: () {
                  notificationServices.getDeviceToken().then((value) async {
                    var data = {
                      'to': value.toString(), //replace with device token
                      'priority': 'high',
                      'notification': {
                        'title': 'Zahid',
                        'body': 'Channel Coding-z',
                      },

                      ///payload
                      'data': {'type': 'msg', 'id': 'zahid075'}
                    };
                    await http.post(
                        Uri.parse('https://fcm.googleapis.com/fcm/send'),
                        body: jsonEncode(data),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization':
                              'key=AAAA97YE1bY:APA91bGZCqUjoU7-0Eat5GzczhrjDveCXk80-eLTP3yO5Uj62yUHtHVEyJ8FnGUoAfCrnzC42bPi3H88uX7zAtDZKtcVE9zbZjq2AdWDdHxASMLnYKRsu5OIOwyxq9VottLOopqTC2a8'
                        });
                  });
                },
                child: Text("Send Notification"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
