import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:internet_connection_checking_flutter/connection_alert.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool? result;
  bool? _isConnected;
  late StreamSubscription<InternetStatus> listener;
  BuildContext? _dialogContext;
  bool isFirstTime=true;

  @override
  void initState() {
    super.initState();
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
     if (status==InternetStatus.connected) {
      if(!isFirstTime){
        _showInternetStatusDialog(status == InternetStatus.connected);
      }
      }
      else{
        _showInternetStatusDialog(status == InternetStatus.connected);
      }
           isFirstTime = false;
      setState(() {
        _isConnected = (status == InternetStatus.connected);
      });
    });
  }

  void _showInternetStatusDialog(bool isConnected) {
    // Close previous dialog if it exists
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
    }

    // Show new dialog
    showDialog(
      context: context,
      builder: (context) {
        _dialogContext = context; // Store the context of the current dialog
        return InternetAlert(isConnected: isConnected);
      },
    ).then((_) {
      _dialogContext = null; // Clear the dialog context after it is closed
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internet Connection Check"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Connection Status : ${result == true ? "Connected" : "Not Connected"}"),
                 Text("Stream Connection Status : ${_isConnected==true?"Connected":"Not Connected"}"),SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () async {
                  result = await InternetConnection().hasInternetAccess;
                  print("Connection Status :$result");
                  setState(() {});
                },
                child: Text("Check Connection Status"))
          ],
        ),
      ),
    );
  }
}
