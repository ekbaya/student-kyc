import 'package:flutter/material.dart';
import 'package:students_kyc_app/models/user.model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Account user;
  bool userFetched = false;
  @override
  void initState() {
    // fetchCurrentUser();
    super.initState();
  }

  // fetchCurrentUser() async {
  //   user = await AuthController.getUserAccount(AppConfig.auth.currentUser!.uid);
  //   setState(() {
  //     userFetched = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () {
                // Navigator.pushAndRemoveUntil<dynamic>(
                //   context,
                //   MaterialPageRoute<dynamic>(
                //     builder: (BuildContext context) => const WelcomePage(),
                //   ),
                //   (route) => false,
                // );
              },
              child: const Text("Logout")),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey[50],
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userFetched ? user.name : "...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Account Info",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.email_outlined,
                  color: Colors.blue,
                ),
                title: const Text("Email"),
                subtitle: Text(userFetched ? user.email : "...",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black)),
              ),
              ListTile(
                leading: const Icon(
                  Icons.phone_outlined,
                  color: Colors.blue,
                ),
                title: const Text("Registration"),
                subtitle: Text(
                  userFetched ? user.registration : "...",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
