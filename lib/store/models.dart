import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  int user_id=0;
  String? name;

  User(this.user_id,this.name);
}