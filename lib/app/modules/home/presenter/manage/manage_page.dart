import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/manage/manage_store.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  late ManageStore store;
  final LayoutStore layoutStore = Modular.get<LayoutStore>();

  @override
  void initState() {
    super.initState();
    store = Modular.get<ManageStore>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Verificação de Permissão
            Observer(builder: (context) {
              if (layoutStore.permissions.isEmpty) {
                return const Center(
                  child: AppText(
                    text: 'Você não tem permissão para acessar esta página.',
                    fontSize: 16,
                    color: Colors.red,
                  ),
                );
              }
              if (layoutStore.permissions[0]['permission_type'] == "FULL") {
                return Column(
                  children: [
                    _backButton(),

                    // BODY
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 50, right: 50, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: "Gerenciamento",
                            fontSize: 24,
                            fontWeight: 'bold',
                            color: Colors.black,
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: "Usuários",
                                fontSize: 20,
                                fontWeight: 'bold',
                                color: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // BOTÃO DE HABILITAR USUÁRIO
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController
                                              emailController =
                                              TextEditingController();
                                          return AlertDialog(
                                            title: const Text(
                                                'Digite o email do usuário'),
                                            content: TextField(
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                hintText: 'Email',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await store
                                                      .enableOrDisableUser(
                                                          email: emailController
                                                              .text,
                                                          enable: true);
                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: const Text('Habilitar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const AppText(
                                        text: "Habilitar Usuário",
                                        fontSize: 16,
                                        fontWeight: 'medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  // BOTÃO DE DESABILITAR USUÁRIO
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController
                                              emailController =
                                              TextEditingController();
                                          return AlertDialog(
                                            title: const Text(
                                                'Digite o email do usuário'),
                                            content: TextField(
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                hintText: 'Email',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await store
                                                      .enableOrDisableUser(
                                                          email: emailController
                                                              .text,
                                                          enable: false);
                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child:
                                                    const Text('Desabilitar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const AppText(
                                        text: "Desabilitar Usuário",
                                        fontSize: 16,
                                        fontWeight: 'medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const AppText(
                                text: "Administradores",
                                fontSize: 20,
                                fontWeight: 'bold',
                                color: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // BOTÃO DE HABILITAR ADMIN
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController
                                              emailController =
                                              TextEditingController();
                                          TextEditingController daysController =
                                              TextEditingController();
                                          return AlertDialog(
                                            title: const Text(
                                                'Digite o email do administrador e a quantidade de dias'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: emailController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Email',
                                                  ),
                                                ),
                                                TextField(
                                                  controller: daysController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Quantidade de dias (Ex: 30)',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  int days = int.tryParse(
                                                          daysController
                                                              .text) ??
                                                      0;
                                                  await store.setPermission(
                                                    email: emailController.text,
                                                    days: days,
                                                    permissionType: 'FULL',
                                                  );
                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: const Text(
                                                    'Habilitar Admin'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const AppText(
                                        text: "Habilitar Admin",
                                        fontSize: 16,
                                        fontWeight: 'medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: AppText(
                  text: 'Você não tem permissão para acessar esta página.',
                  fontSize: 16,
                  color: Colors.red,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 40, top: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.wine),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors.wine,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  AppText(
                    text: "Voltar",
                    fontSize: 12,
                    fontWeight: 'medium',
                    color: AppColors.wine,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
