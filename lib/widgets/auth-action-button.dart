import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:students_kyc_app/locator.dart';
import 'package:students_kyc_app/models/user.model.dart';
import 'package:students_kyc_app/pages/home.dart';
import 'package:students_kyc_app/pages/welcome.dart';
import 'package:students_kyc_app/widgets/app_button.dart';
import 'package:students_kyc_app/services/camera.service.dart';
import 'package:students_kyc_app/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'app_text_field.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthActionButton extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  // ignore: library_private_types_in_public_api
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  final TextEditingController _nameTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  final TextEditingController _emailTextEdittingController =
      TextEditingController(text: '');

  final TextEditingController _registrationNumberTextEdittingController =
      TextEditingController(text: '');

  Account? predictedUser;

  Future _signUp(context) async {
    List predictedData = _mlService.predictedData;
    String name = _nameTextEditingController.text;
    String password = _passwordTextEditingController.text;
    String email = _emailTextEdittingController.text;
    String registration = _registrationNumberTextEdittingController.text;
    Account userToSave = Account(
      name: name,
      password: Crypt.sha256(password).toString(),
      email: email,
      registration: registration,
      modelData: predictedData,
    );
    //Register User to Firebase Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userToSave.email, password: password);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    await db
        .collection("users")
        .doc(userCredential.user!.uid)
        .set(userToSave.toMap());
    _mlService.setPredictedData([]);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const WelcomePage()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;
    if (Crypt(predictedUser!.password).match(password)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
            user: predictedUser!,
            imagepath: _cameraService.imagePath!,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  Future<Account?> _predictUser() async {
    Account? userAndPass = await _mlService.predict();
    return userAndPass;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          var user = await _predictUser();
          if (user != null) {
            predictedUser = user;
          }
        }
        PersistentBottomSheetController bottomSheetController =
            // ignore: use_build_context_synchronously
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Text(
                  'Welcome back, ${predictedUser!.name}.',
                  style: const TextStyle(fontSize: 20),
                )
              : widget.isLogin
                  ? const Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    )
                  : Container(),
          Column(
            children: [
              !widget.isLogin
                  ? AppTextField(
                      controller: _nameTextEditingController,
                      labelText: "Full Name",
                    )
                  : Container(),
              const SizedBox(height: 10),
              !widget.isLogin
                  ? AppTextField(
                      controller: _emailTextEdittingController,
                      labelText: "School Email",
                    )
                  : Container(),
              const SizedBox(height: 10),
              !widget.isLogin
                  ? AppTextField(
                      controller: _registrationNumberTextEdittingController,
                      labelText: "Registration No.",
                    )
                  : Container(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : AppTextField(
                      controller: _passwordTextEditingController,
                      labelText: "Password",
                      isPassword: true,
                    ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser != null
                  ? AppButton(
                      text: 'LOGIN',
                      onPressed: () async {
                        _signIn(context);
                      },
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                    )
                  : !widget.isLogin
                      ? AppButton(
                          text: 'SIGN UP',
                          onPressed: () async {
                            await _signUp(context);
                          },
                          icon: const Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
