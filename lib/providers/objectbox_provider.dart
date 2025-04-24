import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cash_book_mobile/store/objectbox.dart';

part 'objectbox_provider.g.dart';

@Riverpod(keepAlive: true)
// This function initializes the ObjectBox instance
Future<ObjectBox> objectBox(Ref ref) async {
  return await ObjectBox.create();
}
