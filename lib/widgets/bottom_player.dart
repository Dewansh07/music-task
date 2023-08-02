// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_task/MVVM/Model/music_model.dart';
import 'package:music_task/MVVM/ViewModel/audio_player_view_model.dart';
import 'package:provider/provider.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({Key? key});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerViewModel = context.watch<AudioPlayerViewModel>();
    final String formattedDuration =
        formatDuration(audioPlayerViewModel.player.duration);
    final MusicModel? currentSong = (audioPlayerViewModel.currentIndex != -1)
        ? audioPlayerViewModel.playlist[audioPlayerViewModel.currentIndex]
        : null;
    return audioPlayerViewModel.currentIndex == -1
        ? SizedBox()
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 23, 86, 173),
                  Color.fromARGB(255, 180, 21, 116),
                ],
              ),
            ),
            height: 185,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                currentSong?.title ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              currentSong?.artist ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Implement your logic for closing the player or going to the main player screen.
                        },
                        icon: Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(audioPlayerViewModel.player.position),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Color(0xFF254354),
                          min: 0,
                          max: audioPlayerViewModel.player.duration?.inSeconds
                                  .toDouble() ??
                              0,
                          value: audioPlayerViewModel.player.position.inSeconds
                              .toDouble(),
                          onChanged: (value) {
                            setState(() {
                              audioPlayerViewModel.player
                                  .seek(Duration(seconds: value.toInt()));
                            });
                          },
                        ),
                      ),
                      Text(
                        formattedDuration,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          onPressed: () {
                            audioPlayerViewModel.next();
                          },
                          icon: Icon(
                            Icons.repeat,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          audioPlayerViewModel.previous();
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          if (audioPlayerViewModel.isPlaying) {
                            audioPlayerViewModel.pause();
                          } else {
                            audioPlayerViewModel.resume();
                          }
                        },
                        shape: CircleBorder(),
                        color: Color(0xFF254354),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            audioPlayerViewModel.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          audioPlayerViewModel.next();
                        },
                        icon: Icon(
                          Icons.skip_next,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          onPressed: () {
                            audioPlayerViewModel.shufflePlaylist();
                          },
                          icon: Icon(
                            Icons.shuffle,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '0:00';

    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}
