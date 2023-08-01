import 'package:flutter/material.dart';

class DiscoverMusic extends StatelessWidget {
  const DiscoverMusic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 80, 0, 0),
      child: Text(
        'Rediscover the\nMagic of Melodies',
        style: TextStyle(fontWeight:FontWeight.bold, color:  Colors.grey.shade400.withOpacity(0.2), fontSize: 40),
      ),
    );
  }
}

