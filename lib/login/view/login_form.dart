import 'dart:async';
import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Timer? _debounce;
  bool isValidating = false;
  bool isValid = false;
  bool isDirty = false;
  bool isWaiting = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
  }

  Future<bool> validate(String text) async {
    setState(() {
      isValidating = true;
    });
    final bool isValid = isEmail(text);
    isValidating = false;
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (isValidating) {
                  return "Validating...";
                }
                if (value?.isEmpty ?? false) {
                  return "Please enter an email address.";
                }
                if (!isWaiting && !isValid) {
                  return "Please enter a valid email address.";
                }
                return null;
              },
              onChanged: (text) async {
                isDirty = true;
                if (text.isEmpty) {
                  setState(() {
                    isValid = false;
                  });
                  cancelTimer();
                  return;
                }
                isWaiting = true;
                cancelTimer();
                _debounce = Timer(const Duration(seconds: 2), () async {
                  isWaiting = false;
                  isValid = await validate(text);
                  setState(() {});
                  isValidating = false;
                });
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Password',
                // hintText: "Mandatory, can't be empty",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<UserBloc>(context).add(UserLogin(email: emailController.text, password: passwordController.text));
                }
              },
              child: const Text("Log in"),
            ),

          ],
        ),
      ),
    );
  }

}