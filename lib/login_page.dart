import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cadastro_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: ('e-mail'),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: ('senha'),
          ),obscureText: true,
          ),
          ElevatedButton(
              onPressed: (){
                login();
              },
            child: Text('Entrar'),
          ),
          TextButton(onPressed: (){
            Navigator.push(
                context,
              MaterialPageRoute(
                  builder: (context) => CadastroPage(),
              ),
            );
          }, child: Text('Criar Conta'),),
        ],
      ),
    );
  }

  login() async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
      );
      if(userCredential!=null){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Usuario não encontrado'),
              backgroundColor: Colors.redAccent,
          ),
        );
      }else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('password errada'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}