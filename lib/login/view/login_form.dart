import 'dart:async';
import 'package:clique_king/clique_king.dart';
import 'package:clique_king/form/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

class LoginForm extends StatefulWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final Duration debounceDuration = const Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.aspectIsLandscape ? landscapeContentWidth : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Please enter your credentials below"),

              const SizedBox(height: 10),

              DebounceField(
                validator: (value) => Future.value(isEmail(value)),
                debounceDelay: debounceDuration,
                controller: widget.emailController,
                isEmptyMessage: "Please enter an email address.",
                isInvalidMessage: "Please enter a valid email address.",
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Email',
                ),
              ),

              const SizedBox(height: 10),

              DebounceField(
                validator: (value) => Future.value(value.length >= minimumPasswordLength),
                debounceDelay: debounceDuration,
                controller: widget.passwordController,
                obscureText: true,
                isEmptyMessage: "Please enter a password.",
                isInvalidMessage: "Password must be longer than $minimumPasswordLength characters.",
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Password',
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<UserBloc>(context).add(UserLogin(email: widget.emailController.text, password: widget.passwordController.text));
                  }
                },
                child: const Text("Log in"),
              ),

            ],
          ),
        ),
      ),
    );
  }

}