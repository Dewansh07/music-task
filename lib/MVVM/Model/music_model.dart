

class MusicModel {
  final String title;
  final String url;
  final String image;
  final String artist;

  MusicModel({
    required this.title,
    required this.url,
    required this.image,
    required this.artist,
  });

  factory MusicModel.fromMap(Map<dynamic, dynamic> map) {
    return MusicModel(
      title: map['title'],
      url: map['url'],
      image: map['img'],
      artist: map['artist'],
    );
  }



}