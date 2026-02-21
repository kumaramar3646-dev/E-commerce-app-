
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/utility/ui_helper.dart';
import 'bloc/user_bloc.dart';
import 'bloc/user_event.dart';
import 'bloc/user_state.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isAccCreating = false;

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var mobNoController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();

  bool isPassVisible = false;

  bool isConfirmPassVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade200,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, please sign up..",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                controller: nameController,
                decoration: AppDecoration.mDecoration(
                  label: "Name",
                  hint: "Enter your name here..",
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                controller: emailController,
                decoration: AppDecoration.mDecoration(
                  label: "Email",
                  hint: "Enter your email here..",
                  mIcon: Icons.email_outlined,
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mob no";
                  } else if (value.length != 10) {
                    return "Please enter a valid mob no";
                  }
                  return null;
                },
                decoration: AppDecoration.mDecoration(
                  label: "Mobile No",
                  hint: "Enter your mobile no here..",
                  mIcon: Icons.phone_outlined,
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  } else if (!RegExp(
                      r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}''')
                      .hasMatch(value)) {
                    return "Password must be at least 8 characters \nand include uppercase, lowercase, digit, \nand special character.";
                  }
                  return null;
                },
                controller: passController,
                obscureText: !isPassVisible,
                decoration: AppDecoration.mDecoration(
                  label: "Password",
                  hint: "Enter your password here..",
                  isPass: true,
                  isPasswordVisible: isPassVisible,
                  onObscureTap: () {
                    isPassVisible = !isPassVisible;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (passController.text != confirmPassController.text) {
                    return "Password not matched";
                  }

                  return null;
                },
                obscureText: !isConfirmPassVisible,
                controller: confirmPassController,
                decoration: AppDecoration.mDecoration(
                  label: "Confirm Password",
                  hint: "Enter your confirm password here..",
                  isPass: true,
                  isPasswordVisible: isConfirmPassVisible,
                  onObscureTap: () {
                    isConfirmPassVisible = !isConfirmPassVisible;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserLoadingState) {
                      isAccCreating = true;
                    }

                    if (state is UserFailureState) {
                      isAccCreating = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${state.errorMsg}'), backgroundColor: Colors.red,));
                    }

                    if(state is UserSuccessState){
                      isAccCreating = false;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Account created successfully!!'), backgroundColor: Colors.green,));
                    }
                  },
                  builder: (context, state){
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade200,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          /// sign up work here
                          context.read<UserBloc>().add(
                            UserRegisterEvent(
                              email: emailController.text,
                              name: nameController.text,
                              mobNo: mobNoController.text,
                              pass: passController.text,
                            ),
                          );
                        }
                      },
                      child: isAccCreating ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Text('Creating Account...')
                        ],
                      ) : Text('SignUp'),
                    );
                  },
                ),
              ),
              SizedBox(height: 11),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Already have an account,'),
                        TextSpan(
                          text: ' Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade200,
                          ),
                        ),
                      ],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}