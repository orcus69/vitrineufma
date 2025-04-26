import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/svg_asset.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? icon;
  CustomAlertDialog({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ElasticIn(
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    Modular.to.pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              offset: const Offset(0, 8),
                              blurRadius: 8,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        constraints:
                            const BoxConstraints(maxWidth: 300, maxHeight: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: (15)),
                              child: Column(
                                children: [
                                  AppSvgAsset(
                                    image: icon ?? "caracol",
                                    color: AppColors.yellow,
                                    imageH: 80,
                                  ),
                                  SizedBox(
                                    height: (10),
                                  ),
                                  Text(
                                    "Atenção!",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: (15),
                                  ),
                                  Text(
                                    title, //"Você tem certeza que deseja sair?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: (10),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Divider(
                              color: AppColors.backgroundGrey,
                            ),
                            Container(
                              height: (65),
                              color: AppColors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        Modular.to.pop(true);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Sim",
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        Modular.to.pop(false);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Não",
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
