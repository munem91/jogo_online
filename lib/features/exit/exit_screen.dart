import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var audioCubit = BlocProvider.of<AudioCubit>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/settingscreen.png",
              fit: BoxFit.fill,
            ),
            Positioned(
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width * 0.2,
              child: GestureDetector(
                onTap: () async {
                  await audioCubit.playSound1('sound/knopka.mp3');
                  
                  if (context.mounted) {
                    
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                child: Image.asset(
                  "assets/images/back.png",
                  scale: 1.2,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/plaska.png"),
                      ),
                    ),

                    

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Exit",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),

                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            Column(
                              children: [
                                Text(
                                  "Yes",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 30, right: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      await audioCubit
                                          .playSound1('sound/knopka.mp3');
                                      if (context.mounted) {
                                        
                                        SystemNavigator.pop();
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Image.asset(
                                        audioCubit.isButton1SoundEnabled
                                            ? "assets/images/off.png"
                                            : "assets/images/on.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            
                            Column(
                              children: [
                                Text(
                                  "No",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 30, right: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      await audioCubit
                                          .playSound1('sound/knopka.mp3');
                                      if (context.mounted) {
                                        
                                        Navigator.of(context)
                                            .pushReplacementNamed('/');
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Image.asset(
                                        audioCubit.isButton2SoundEnabled
                                            ? "assets/images/on.png"
                                            : "assets/images/off.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

      
 



























































