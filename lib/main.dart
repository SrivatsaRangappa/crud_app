import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_app/bloc/post_bloc.dart';
import 'package:flutter_crud_app/screens/post_screen.dart';
import 'package:flutter_crud_app/service/post_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(PostService())..add(FetchPostsEvent()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.teal),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade200),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      home: PostListScreen(),
    );
  }
}
