import 'package:cash_book_mobile/store/models.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:cash_book_mobile/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }


  // Save a User to ObjectBox
  void saveUser(User user) {
    final userBox = store.box<User>(); // Access the box for the User entity
    userBox.removeAll();
    userBox.put(user); // Save the user to the box
  }
  // Get the first User from ObjectBox
  int getSelectedUserId(){
    final userBox = store.box<User>(); // Access the box for the User entity
    final firstUser = userBox
        .getAll()
        .isNotEmpty ? userBox
        .getAll()
        .first : null;
    if(firstUser != null) {
      return firstUser.user_id;
    } else {
      return 0;
    }
  }
}