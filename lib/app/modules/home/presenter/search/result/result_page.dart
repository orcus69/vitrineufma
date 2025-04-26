import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/filtered_book_card.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/search_store.dart';

class ResultSearchPage extends StatefulWidget {
  SearchStore store = Modular.get<SearchStore>();
  ResultSearchPage({super.key});

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  List<Book> booksFiltered = [];
  @override
  void initState() {
    super.initState();
    booksFiltered = Modular.args.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          SearchModal(
            expanded: false,
          ),
          const SizedBox(height: 20),
          Observer(builder: (context) {
            if (widget.store.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (widget.store.booksFiltered.isEmpty) {
              return Center(
                child: SizedBox(
                  width: AppConst.maxContainerWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        child: InkWell(
                            onTap: () {
                              Modular.to.navigate('/home/books');
                              // store.back();
                            },
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                            )),
                      ),
                      const SizedBox(height: 80),
                      Center(child: Text("Nenhum resultado encontrado")),
                    ],
                  ),
                ),
              );
            }
            return Container(
              width: AppConst.maxContainerWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: InkWell(
                        onTap: () {
                          Modular.to.navigate('/home/books');
                          // store.back();
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.wine),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: AppColors.wine,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              AppText(
                                text: "Voltar",
                                fontSize: 12,
                                fontWeight: 'medium',
                                color: AppColors.wine,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Center(
                    child: Container(
                      width: AppConst.maxContainerWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              margin: const EdgeInsets.only(top: 60),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: "Filtros",
                                    fontSize: AppFontSize.fz07,
                                    fontWeight: 'bold',
                                  ),
                                  const SizedBox(height: 20),
                                  AppText(
                                    text: "Campo de busca",
                                    fontSize: AppFontSize.fz07,
                                    fontWeight: 'bold',
                                  ),
                                  const SizedBox(height: 10),
                                  AppText(
                                    text: widget.store.filter['name'],
                                    fontSize: AppFontSize.fz07,
                                    fontWeight: 'medium',
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: AppText(
                                    text:
                                        "${booksFiltered.length} resultados encontrados",
                                    fontSize: 16,
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: booksFiltered.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 12,
                                    mainAxisExtent: 300,
                                    mainAxisSpacing: 20,
                                    crossAxisCount: 4,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // store.setSelectedBook(widget.store.booksFiltered[index]);
                                      },
                                      child: FilteredBookCard(
                                          book:booksFiltered[index]),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
        ],
      )),
    ));
  }
}
