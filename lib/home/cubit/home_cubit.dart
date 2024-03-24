import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/home/cubit/home_state.dart';
import 'package:login_task/login/cubit/auth_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  HomeCubit() : super(const HomeState.initial());

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? name;
  String? uid;

  Future<void> init() async {
    emit(const HomeState.loading());
    try {
      final User? user = auth.currentUser;
      uid = user?.uid ?? '';
      var collection = FirebaseFirestore.instance.collection('user');
      var docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        name = data?['name'];
      }
      emit(const HomeState.success());
    } catch (e) {
      emit(const HomeState.error());
      print("Error: $e");
    }
  }

  Future logout() async {
    try {
      emit(HomeState.logout());
      auth.signOut().then((value) async {
        var collection = FirebaseFirestore.instance.collection('user');
        var docSnapshot = await collection.doc(uid).get();
        if (docSnapshot.exists) {
          await collection.doc(uid).update({'logged': false});
        }
        emit(HomeState.successLogout());
      });
    } catch (e) {
      emit(const HomeState.error());
      print("Error: $e");
    }
  }
}
