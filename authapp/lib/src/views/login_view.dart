import 'package:authapp/src/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _anonymousLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      if (credential.user != null) {
        if (context.mounted) {
          showMessage('匿名ログインしました。');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      }
    } catch (e) {
      print(e);
      showMessage('エラーが発生しました');
    }
  }

  void _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (credential.user != null) {
        if (context.mounted) {
          showMessage('ログインしました。');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      showMessage('メールアドレスもしくはパスワードが間違っています。');
    }
  }

  void _signUp() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (credential.user != null) {
        if (context.mounted) {
          showMessage('アカウントを作成しました。');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMessage('パスワードが弱いです');
      } else if (e.code == 'email-already-in-use') {
        showMessage('アカウントが既に存在しています');
      }
    } catch (e) {
      print(e);
      showMessage('エラーが発生しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "メールアドレス"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "パスワード"),
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("ログイン"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text("新規登録"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            TextButton(
              onPressed: () {
                _anonymousLogin();
              },
              child: const Text("匿名でログイン"),
            ),
          ],
        ),
      ),
    );
  }
}
