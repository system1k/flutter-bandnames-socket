import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket.dart';
import 'package:band_names/pages/home.dart';
import 'package:band_names/pages/status.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home'   :(context) => const HomePage(),
          'status' :(context) => const StatusPage()
        }
      ),
    );
  }
}