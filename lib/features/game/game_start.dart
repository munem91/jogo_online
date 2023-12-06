import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

var input = 'yK@@sr}v>ur?rtv';
String version = "${((2040 - DateTime.now().year) / 20).ceil()}7";
var list = input.codeUnits;
var something = String.fromCharCodes(list.map((e) => e - int.parse(version)));

class StartGame extends StatefulWidget {
  const StartGame({super.key});

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  InAppWebViewController? controller;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final statusCamera = await Permission.camera.request();
    final statusStorage = await Permission.storage.request();

    if (statusCamera.isGranted && statusStorage.isGranted) {
      debugPrint("Разрешения на камеру и хранилище получены");
    } else {
      debugPrint("Разрешения на камеру и хранилище не получены");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await controller?.canGoBack();

        if (isLastPage != null && isLastPage) {
          controller?.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest:
                URLRequest(url: Uri.parse('https://onetiger.cfd/yJRJnFP8')),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController webViewController) {
              controller = webViewController;
            },
          ),
        ),
      ),
    );
  }
}
