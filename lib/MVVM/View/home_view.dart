import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_task/MVVM/ViewModel/audio_player_view_model.dart';
import 'package:music_task/widgets/bottom_player.dart';

import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    context.read<AudioPlayerViewModel>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomPlayer(),
        appBar: const _CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _DiscoverMusic(),
              FutureBuilder(
                future: context
                    .read<AudioPlayerViewModel>()
                    .fetchSongsFromFirebaseStorage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  context.read<AudioPlayerViewModel>().shufflePlaylist();
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: ((context, index) {
                      final song =
                          context.read<AudioPlayerViewModel>().playlist[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<AudioPlayerViewModel>()
                              .setCurrentIndex(index);
                          context.read<AudioPlayerViewModel>().play();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.network(
                                song.image,
                                fit: BoxFit.cover,
                                height: 180,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                              child: Text(
                                song.title,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 66, 198, 167),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                song.artist,
                                style: const TextStyle(
                                    color: Color.fromARGB(135, 52, 248, 45),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    itemCount:
                        context.read<AudioPlayerViewModel>().playlist.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Icon(
            Icons.person,
            size: 30,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 5),
          Text(
            'Enjoy your favorite music',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              iconColor: Color.fromARGB(255, 224, 54, 54),
              isDense: true,
              filled: true,
              fillColor: Color.fromARGB(255, 227, 227, 231),
              hintText: 'Search',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color.fromARGB(255, 80, 24, 24)),
              prefixIcon:
                  Icon(Icons.search, color: Color.fromARGB(255, 224, 54, 54)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
