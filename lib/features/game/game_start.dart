import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jogo_bbrbet_online/features/game/game_generator.dart';
import 'package:permission_handler/permission_handler.dart';

class StartGame extends StatefulWidget {
  const StartGame({super.key, this.generation_game});
  final String? generation_game;

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
            initialUrlRequest: URLRequest(url: Uri.parse(widget.generation_game!)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController gameController) {
              controller = gameController;
            },
          ),
        ),
      ),
    );
  }
}
