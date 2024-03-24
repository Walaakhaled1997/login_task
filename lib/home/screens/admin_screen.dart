import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/home/cubit/home_cubit.dart';
import 'package:login_task/home/cubit/home_state.dart';
import 'package:login_task/login/screens/login_screen.dart';
import 'package:login_task/widgets/center_loading.dart';

class AdminScreen extends StatelessWidget {
  final String uid;

  const AdminScreen({Key? key, required this.uid}) : super(key: key);

  Future<void> _onStateChangeListener(
      BuildContext context, HomeState state) async {
    if (state.isSuccess) {
    } else if (state.isSuccessLogout) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  alertLogged(BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: const Text('Welcome', style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.indigo,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        left: 10,
        right: 10,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      lazy: false,
      create: (_) => HomeCubit()..init(),
      child: BlocConsumer<HomeCubit, HomeState>(
          listener: _onStateChangeListener,
          builder: (ctx, state) {
            final cubit = HomeCubit.get(ctx);

            return Scaffold(
              body: state.isLoading
                  ? const CenterCircularLoading()
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data!.data()!;
                          if (data['logged'] == true) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              alertLogged(context);
                            });
                          }
                        }
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(cubit.name ?? ''),
                               SizedBox(height: 30,),
                               Center(
                                 child:  state.isLogout
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
                                     cubit.logout();
                                   },
                                   child: const Text(
                                     "LOGOUT",
                                     style: TextStyle(fontSize: 20),
                                   ),
                                 ),
                               )
                              ],
                            ),
                          ),
                        );
                      }),
            );
          }),
    );
  }


}
