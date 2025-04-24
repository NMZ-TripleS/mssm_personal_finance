import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'user_fetch_provider.g.dart';

@riverpod
Future<List<Map<String, dynamic>>> fetchUsers(Ref ref) async {
  final response =
  await http.get(Uri.parse('https://fm.hcf-itsolution.com/api/v1/user'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception("Failed to fetch users");
  }
}