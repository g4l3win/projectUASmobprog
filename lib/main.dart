import 'package:flutter/material.dart';
import 'package:quizdb/screens/SignIn.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

//fungsi main itu titik masuk aplikasi flutter.dipanggil saat aplikasi lagi dijalankan
//run(MyApp()) memulai aplikasi flutter dengan widget root myApp
void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'basic_channelDescription',
      ),
    ],
    debug: true,
  );
  // Request notification permission if it's not already granted
  requestNotificationPermission();
  runApp(MyApp());
}

// Function to request notification permission from the user
void requestNotificationPermission() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // Show the permission request dialog
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

//MyApp ADALAH root widget dari aplikasi
//root widget adalah widget pertama yang dibuat dalam hierarki widget
//MyApp mengembalikan widget MaterialApp yang mengatur tema, judul, halaman utama aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuis Interaktif',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Signin(), //halaman home/ utama SignIn()
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
