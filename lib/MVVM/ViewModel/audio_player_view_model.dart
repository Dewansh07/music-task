import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_task/MVVM/Model/music_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  List<MusicModel> playlist = [];
  AudioPlayer player = AudioPlayer();
  FirebaseDatabase database = FirebaseDatabase.instance;
  int _currentIndex = -1;
  get currentIndex => _currentIndex;
  setCurrentIndex(i) {
    _currentIndex = i;
    notifyListeners();
  }

  bool isPlaying = false;
  Future<void> fetchSongsFromFirebaseStorage() async {
    try {
      playlist.clear();
      DatabaseReference _musicRef = database.ref();
      await (_musicRef.get()).then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          playlist.add(MusicModel.fromMap(value));
        });
      });
      print(playlist[0].url);
      notifyListeners();
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  void play() async {
    if (playlist.isEmpty) return;
    isPlaying = true;

    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        next();
      }
    });

    String url = playlist[_currentIndex].url;
    await player.setUrl(url);
    await player.play();
    notifyListeners();
  }

  void pause() async {
    log("paused");
    await player.pause();
    isPlaying = false;
    notifyListeners();
  }

  void next() {
    if (_currentIndex < playlist.length - 1) {
      _currentIndex++;
      play();
    } else {
      _currentIndex = 0;
      play();
    }
  }

  void resume() {
    log("resumed");
    player.play();
    isPlaying = true;
    notifyListeners();
  }

  void previous() {
    if (_currentIndex > 0) {
      _currentIndex--;
      play();
    } else {
      _currentIndex = playlist.length - 1;
      play();
    }
  }

  onDispose() {
    player.dispose();
  }

  void shufflePlaylist() {
    playlist.shuffle();
    notifyListeners();
  }

  //repeat current song
  void repeatSong() {
    player.setLoopMode(LoopMode.one);
  }
}
