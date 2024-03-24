import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/home/screens/admin_screen.dart';
import 'package:login_task/home/screens/customer_screen.dart';
import 'package:login_task/login/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  AuthCubit() : super(const AuthState.initial());

  Future login({required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      emit(AuthState.authLoading());
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      var collection = FirebaseFirestore.instance.collection('user');
      var docSnapshot = await collection.doc(result.user?.uid).get();
      if (docSnapshot.exists) {
        await collection.doc(result.user?.uid).update({'logged': true});
        Map<String, dynamic>? data = docSnapshot.data();

        if (data?['type'] == 1) {
          emit(AuthState.successNavigateNext(AdminScreen(
            uid: result.user?.uid ?? '',
          )));
        } else {
          emit(AuthState.successNavigateNext(CustomerScreen(
            uid: result.user?.uid ?? '',
          )));
        }
      }
    } catch (e) {
      emit(AuthState.error());
      print("Error: $e");
    }
  }
}
