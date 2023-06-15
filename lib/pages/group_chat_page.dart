import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const GroupChatPage(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
