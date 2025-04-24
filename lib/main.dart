import 'dart:convert';
import 'package:cash_book_mobile/providers/objectbox_provider.dart';
import 'package:cash_book_mobile/src/transaction_page.dart';
import 'package:cash_book_mobile/src/user_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  runApp(
      const ProviderScope(
        child: MyApp(),
      )
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return MaterialApp(
      title: 'My Cashbook',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.black54),
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home:
      objectBoxAsync.when(
        data: (objectBox) {
          int userId = objectBox.getSelectedUserId();
          if (userId == 0) {
            return const UserSelectionPage();
          } else {
            return TransactionPage(user_id: userId,);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
