import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_task/MVVM/View/home_view.dart';
import 'package:music_task/MVVM/ViewModel/audio_player_view_model.dart';
import 'package:music_task/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AudioPlayerViewModel().fetchSongsFromFirebaseStorage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player task',
      theme: ThemeData(
        sliderTheme: SliderThemeData(
            trackHeight: 1,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}
