import 'package:chat_app/pages/chat_list_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;

  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
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
                widget.userName,
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
                onTap: () {
                  nextScreenReplace(context, const ChatListPage());
                },
                selectedColor: Theme.of(context).primaryColor,
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
                  nextScreenReplace(context, const ChatListPage());
                },
                selectedColor: Theme.of(context).primaryColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                title: const Text(
                  "Group",
                  style: TextStyle(color: Colors.black),
                ),
                leading: const Icon(Icons.group),
              ),
              ListTile(
                onTap: () {},
                selected: true,
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
                                  nextScreenReplace(context, const LoginPage());
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 200,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Full Name", style: TextStyle(fontSize: 17)),
                  Text(widget.userName, style: const TextStyle(fontSize: 17)),
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email", style: TextStyle(fontSize: 17)),
                  Text(widget.email, style: const TextStyle(fontSize: 17)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
