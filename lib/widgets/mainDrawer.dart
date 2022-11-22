import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/user.model.dart';
import '../pages/account.dart';
import '../pages/home.dart';
import '../pages/places.dart';
import '../pages/support.dart';

Drawer mainDrawer(BuildContext context, Account account, String imagepath) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      children: [
        //Drawer Header
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: Image.file(
                  File(imagepath),
                  fit: BoxFit.cover,
                ).image,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account != null ? account.name : "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(account != null ? account.email : ""),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),

        //Drawer Body
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: account,
                  imagepath: imagepath,
                ),
              ),
            );
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.green,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlacesPage(),
              ),
            );
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.cube_box,
              color: Colors.green,
            ),
            title: Text(
              "Places",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.person_outline, color: Colors.green),
            title: Text(
              "Account",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SupportPage(),
              ),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.help_outline, color: Colors.green),
            title: Text(
              "Support",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Share.share(
                'check out this city navigation helper https://example.com',
                subject: 'City Navigation Helper!');
          },
          child: const ListTile(
            leading: Icon(
              CupertinoIcons.share,
              color: Colors.green,
            ),
            title: Text(
              "Share",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.logout, color: Colors.green),
            title: Text(
              "Logout",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}
