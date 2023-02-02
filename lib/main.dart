import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/youtube/listing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const ListingPage(),
    );
  }
}

