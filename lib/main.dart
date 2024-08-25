import 'package:flutter/material.dart';
import 'package:gitsearch/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'screens/searchscreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GitHubProvider()),
      ],
      child: GithubSearchApp(),
    ),
  );
}

class GithubSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub User Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GithubSearchPage(),
    );
  }
}
