import 'dart:async';
import 'package:clique_king/clique_king.dart';
import 'package:clique_king/form/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

class RegisterForm extends StatefulWidget {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
              const Text("Please fill in the form below to register"),

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
                validator: (value) {
                  String sanVal = sanitizeUserName(value);
                  print("val: $value sanVal: $sanVal sanVal.isEmpty: ${sanVal.isNotEmpty}");
                  return Future.value(sanitizeUserName(value).isNotEmpty);
                },
                debounceDelay: debounceDuration,
                controller: widget.usernameController,
                isEmptyMessage: "Please enter a username.",
                isInvalidMessage: "Username can not be empty or only whitespace.",
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Username',
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

              DebounceField(
                validator: (value) => Future.value(equals(value, widget.passwordController.text)),
                debounceDelay: debounceDuration,
                controller: widget.passwordConfirmController,
                obscureText: true,
                isEmptyMessage: "Please confirm your password.",
                isInvalidMessage: "Passwords must be the same.",
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Confirm Password',
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<UserBloc>(context)
                        .add(UserRegister(
                        email: widget.emailController.text,
                        password: widget.passwordController.text,
                        name: widget.usernameController.text
                    ));
                  }
                },
                child: const Text("Register"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}