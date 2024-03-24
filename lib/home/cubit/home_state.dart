import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.loading() = Loading;
  const factory HomeState.logout() = Logout;
  const factory HomeState.successLogout() = SuccessLogout;

  const factory HomeState.success() = Success;
  const factory HomeState.error() = Error;
}

extension HomeStateExtention on HomeState {
  bool get isInitial => this is _Initial;

  bool get isLoading => this is Loading;
  bool get isLogout => this is Logout;
  bool get isSuccessLogout => this is SuccessLogout;

  bool get isSuccess => this is Success;
  bool get isError => this is Error;
}
