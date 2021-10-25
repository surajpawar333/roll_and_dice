import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:roll_dice_demo/src/screen/login/bloc/login_bloc.dart';
import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:roll_dice_demo/src/utils/custom_dialog.dart';
import 'package:roll_dice_demo/src/utils/dialog_status.dart';
import 'package:roll_dice_demo/src/widgets/custom_button.dart';
import 'package:roll_dice_demo/src/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late CustomDialogs customDialogs;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    nameController = new TextEditingController(text: '');
    emailController = new TextEditingController(text: '');
    passwordController = new TextEditingController(text: '');
    confirmPasswordController = new TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    customDialogs = CustomDialogs(context);

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.dialogStatus != current.dialogStatus || previous.isLogin != current.isLogin,
      listener: (context, state) {
        switch (state.dialogStatus) {
          case DialogStatus.unknown:
            break;

          case DialogStatus.loading:
            customDialogs.showLoadingDialog(message: state.loadingMessage);
            break;

          case DialogStatus.loginSuccess:
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, ConstantStrings.route_homepage);
            break;

          case DialogStatus.signUpSuccess:
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            customDialogs.showAlertDialog(title: 'Success', message: 'Success', positiveButtonText: 'Dismiss');
            break;

          case DialogStatus.error:
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            customDialogs.showAlertDialog(
                title: state.errorTitle, message: state.errorBody, positiveButtonText: 'Dismiss');
            break;
        }
        if (state.isLogin) {
          nameController = new TextEditingController(text: '');
          emailController = new TextEditingController(text: '');
          passwordController = new TextEditingController(text: '');
          confirmPasswordController = new TextEditingController(text: '');
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) => previous.isLogin != current.isLogin,
              builder: (context, isLoginState) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: SvgPicture.asset(ConstantStrings.diceImageLocation,
                          fit: BoxFit.contain, color: Theme.of(context).primaryColor, semanticsLabel: 'A red up arrow'),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: Text(
                        isLoginState.isLogin ? 'Login' : 'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    if (!isLoginState.isLogin)
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) => previous.username != current.username,
                        builder: (context, state) {
                          return CustomTextField(
                            editingController: nameController,
                            labelText: 'Username',
                            hintText: 'Enter username',
                            errorText: state.username.error,
                            onChange: (value) {
                              context.read<LoginBloc>().add(UsernameChanged(value));
                            },
                            prefixIcon: Icons.lock_outline,
                          );
                        },
                      ),
                    if (!isLoginState.isLogin) SizedBox(height: 10.0),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous.email != current.email,
                      builder: (context, state) {
                        return CustomTextField(
                          editingController: emailController,
                          labelText: 'Email ID',
                          hintText: 'Enter email',
                          errorText: state.email.error,
                          onChange: (value) {
                            context.read<LoginBloc>().add(EmailChanged(value));
                          },
                          prefixIcon: Icons.alternate_email_outlined,
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous.password != current.password,
                      builder: (context, state) {
                        return CustomTextField(
                          editingController: passwordController,
                          labelText: 'Password',
                          hintText: 'Enter password',
                          errorText: state.password.error,
                          isPassword: true,
                          onChange: (value) {
                            context.read<LoginBloc>().add(PasswordChanged(value));
                          },
                          prefixIcon: Icons.lock_outline,
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    if (!isLoginState.isLogin)
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
                        builder: (context, state) {
                          return CustomTextField(
                            editingController: confirmPasswordController,
                            labelText: 'Confirm Password',
                            hintText: 'Enter confirm password',
                            errorText: state.confirmPassword.error,
                            isPassword: true,
                            onChange: (value) {
                              context.read<LoginBloc>().add(ConfirmPasswordChanged(value));
                            },
                            prefixIcon: Icons.lock_outline,
                          );
                        },
                      ),
                    if (!isLoginState.isLogin) SizedBox(height: 20.0),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous.isValidate != current.isValidate,
                      builder: (context, state) {
                        return CustomButton(
                          text: isLoginState.isLogin ? "Login" : "Sign Up",
                          enabled: state.isValidate,
                          onTap: () {
                            if (state.isValidate) {
                              isLoginState.isLogin
                                  ? context.read<LoginBloc>().add(LoginSubmitted())
                                  : context.read<LoginBloc>().add(SignUpFormSubmitted());
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        context.read<LoginBloc>().add(ToggleForm());
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                              text: isLoginState.isLogin ? "Don't have an Account? " : "Already have an Account? ",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: isLoginState.isLogin ? 'Sign Up' : 'Log In',
                                  style: TextStyle(color: Theme.of(context).focusColor),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
