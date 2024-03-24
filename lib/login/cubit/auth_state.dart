import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.authLoading() = AuthLoading;

  const factory AuthState.successNavigateNext(Widget screen) =
  SuccessNavigateNext;

  const factory AuthState.success() = Success;

  const factory AuthState.loading() = Loading;
  const factory AuthState.error() = Error;

}

extension AuthStateExtention on AuthState {
  bool get isInitial => this is _Initial;

  bool get isAuthLoading => this is AuthLoading;
  bool get isSuccessNavigateNext => this is SuccessNavigateNext;


  bool get isLoading => this is Loading;



  bool get isSuccess => this is Success;
  bool get isError => this is Error;

}
