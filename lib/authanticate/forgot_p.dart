import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        // iconTheme: IconButton(onPressed: () {}, icon: Icon(Icons.abc_sharp)),
      ),
      body: Column(
        children: [
          Text("Enter your email to reset your password."),
          TextFormField(
            controller: _emailController,
            cursorColor: Colors.red,
            decoration: InputDecoration(label: Text("Email")),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) => email != null ? 'Enter your Email' : null,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.065,
              child: ElevatedButton(
                  onPressed: (() {}),
                  child: FittedBox(
                    child: Text(
                      'Find',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(width: 3, color: Colors.red),
                      ))))
        ],
      ),
    );
  }
}
