import 'package:flutter/cupertino.dart';

class UserTile extends StatefulWidget {
  final String userName;
  final String userId;

  const UserTile({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
