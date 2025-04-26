import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'manage_store.g.dart';

class ManageStore = _ManageStoreBase with _$ManageStore;

abstract class _ManageStoreBase with Store {
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @observable
  bool loading = false;
  //SETAR PERMISSÃO
  @action
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    loading = true;
    var result = await infoMaterialUsecase.setPermission(
        email: email, days: days, permissionType: permissionType);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao definir permissão");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Permissão definida com sucesso");
      loading = false;
    });
  }

  @action
  Future<void> enableOrDisableUser(
      {required String email, required bool enable}) async {
    loading = true;
    var result = await infoMaterialUsecase.enableOrDisableUser(
        email: email, enable: enable);

    result.fold((l) {
      debugPrint("Error: $l");
      enable
          ? showSnackbarError("Erro ao habilitar usuário")
          : showSnackbarError("Erro ao desabilitar usuário");
      loading = false;
    }, (r) {
      debugPrint("Success");
      enable
          ? showSnackbarSuccess("Usuário habilitado com sucesso")
          : showSnackbarSuccess("Usuário desabilitado com sucesso");
      loading = false;
    });
  }
}
