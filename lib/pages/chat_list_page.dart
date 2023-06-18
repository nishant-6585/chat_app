import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/user_search_page.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/user_tile.dart';
import 'group_chat_list_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  AuthService authService = AuthService();
  Stream? userListStream;
  String userName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    geUserListStream();
  }

  void getUserData() async {
    await HelperFunction.getUserEmail().then((value) {
      email = value!;
    });
    await HelperFunction.getUserName().then((value) {
      userName = value!;
    });
  }

  geUserListStream() async {
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getOneToOneChatList()
        .then((snapshot) {
      setState(() {
        userListStream = snapshot;
      });
    });
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const UserSearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Chat List",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Chat",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.chat),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(context, const GroupChatListPage());
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Group Chat",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.group),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Profile ",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.person),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.settings),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut().whenComplete(() {
                                nextScreenReplace2(context, const LoginPage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: userList(),
    );
  }

  userList() {
    return StreamBuilder(
      stream: userListStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['oneToOne'] != null) {
            if (snapshot.data['oneToOne'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['oneToOne'].length,
                itemBuilder: (BuildContext context, int index) {
                  int reverseIndex =
                      snapshot.data['oneToOne'].length - index - 1;
                  return UserTile(
                      userId: getId(snapshot.data['oneToOne'][reverseIndex]),
                      userName:
                          getName(snapshot.data['oneToOne'][reverseIndex]));
                },
              );
            } else {
              return noUsersWidget();
            }
          } else {
            return noUsersWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noUsersWidget() {
    return const Text(
      "There are no users added to chat list. Please tap on search icon on top right and search for user to start chatting with",
      textAlign: TextAlign.center,
    );
  }
}
