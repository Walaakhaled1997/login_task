import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/login/cubit/auth_cubit.dart';
import 'package:login_task/login/cubit/auth_state.dart';
import 'package:login_task/widgets/center_loading.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);


  void _onStateChangeListener(BuildContext context, AuthState state) {
    if (state.isSuccess) {
    } else if (state.isSuccessNavigateNext) {
      state.mapOrNull(successNavigateNext: (data) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => data.screen,
          ),
        );
      });
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      lazy: false,
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
          listener: _onStateChangeListener,
          builder: (ctx, state) {
            final cubit = AuthCubit.get(ctx);
            return Scaffold(
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: emailController,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    textField(
                      hint: 'Password',
                      controller: passwordController,
                      inputType: TextInputType.text,
                      isObscure: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: state.isAuthLoading
                          ? const CenterCircularLoading()
                          : TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                cubit.login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text);
                              },
                              child: const Text("LOGIN",
                                  style: TextStyle(fontSize: 20)),
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  textField({
    bool? isObscure,
    Widget? suffixIcon,
    required TextEditingController controller,
    required TextInputType inputType,
    required String hint,
    required Icon prefixIcon,
  }) {
    final ValueNotifier<bool> isFocused = ValueNotifier(false);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ValueListenableBuilder(
          valueListenable: isFocused,
          builder: (context, value, child) {
            final Color? color = (isFocused.value) ? Colors.blue : null;

            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: color ?? Colors.grey,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FocusScope(
                onFocusChange: (value) {
                  isFocused.value = !isFocused.value;
                },
                child: TextFormField(
                  obscureText: isObscure ?? false,
                  controller: controller,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    icon: prefixIcon,
                    suffixIcon: suffixIcon,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
