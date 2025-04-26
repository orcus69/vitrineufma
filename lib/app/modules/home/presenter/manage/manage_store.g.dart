// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ManageStore on _ManageStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: '_ManageStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$setPermissionAsyncAction =
      AsyncAction('_ManageStoreBase.setPermission', context: context);

  @override
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) {
    return _$setPermissionAsyncAction.run(() => super.setPermission(
        email: email, days: days, permissionType: permissionType));
  }

  late final _$enableOrDisableUserAsyncAction =
      AsyncAction('_ManageStoreBase.enableOrDisableUser', context: context);

  @override
  Future<void> enableOrDisableUser(
      {required String email, required bool enable}) {
    return _$enableOrDisableUserAsyncAction
        .run(() => super.enableOrDisableUser(email: email, enable: enable));
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
