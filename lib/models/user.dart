class UserId {
  final String uid;

  UserId({
    required this.uid,
  });
}

class UserData {
  final String uid;
  late final String name;
  late final String sport;
  late final int strength;
  UserData(
      {required this.name,
      required this.uid,
      required this.sport,
      required this.strength});
}
