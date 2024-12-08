import 'package:flutter/material.dart';
import 'package:mzn_news/providers/news_provider.dart';
import 'package:mzn_news/screens/home.dart';
import 'package:mzn_news/screens/news_details_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        )
      ],
      child: MaterialApp(
        title: 'MZN News',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home(),
        routes: {
          NewsDetailsApp.routeName: (ctx) => const NewsDetailsApp(),
        },
      ),
    );
  }
}
