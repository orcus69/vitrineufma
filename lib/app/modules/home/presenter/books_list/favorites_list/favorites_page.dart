import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';

class FavoritesListPage extends StatefulWidget {
  FavoritesListPage({super.key});

  @override
  State<FavoritesListPage> createState() => _FavoritesListPageState();
}

class _FavoritesListPageState extends State<FavoritesListPage> {
  late ReadingListStore store;
  int? favoriteListIndex;
  bool isLogged = false;
  late ILocalStorage storage;
  late Map boxData;

  @override
  void initState() {
    super.initState();

    store = Modular.get<ReadingListStore>();

    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    isLogged = ((boxData["id"] ?? '')).isNotEmpty;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await store.getMaterialList();

      try {
        favoriteListIndex = store.readingList.indexWhere(
          (list) => list['name'] == 'aee20c6a981fe6633c17340037ebb6472f1d8eb9',
        );

        if (favoriteListIndex != -1) {
          await store
              .getMaterialFromList(store.readingList[favoriteListIndex!]['id']);
        } else {
          favoriteListIndex = null;
        }
      } catch (e) {
        print('Erro ao buscar lista de favoritos: $e');
      }

      store.getMaterialFromList(favoriteListIndex ?? 0);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SearchModal(expanded: false,),
                  _backButton(),
                  // LISTA DE MATERIAIS
                  Observer(builder: (context) {
                    if (store.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (favoriteListIndex == null ||
                        store.readingList.isEmpty) {
                      return Container(
                        height: height * 0.3,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: 'Nenhuma lista de favoritos encontrada',
                                fontSize: AppFontSize.fz06,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 70,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: const AppText(
                                    fontWeight: 'bold',
                                    fontSize: AppFontSize.fz07,
                                    text: 'Sua lista de favoritos',
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.cutGrey, width: 0.5),
                                ),
                                // Use um SizedBox para definir a altura
                                child: SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: store.listBooks.length,
                                    itemBuilder: (context, index) {
                                      var book = store.listBooks[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            // store.setSelectedBook(book);
                                            Modular.to.pushNamed('/home/books/${book.id}',);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.lightGrey),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Imagem do livro
                                                Container(
                                                  height: 150,
                                                  width: 100,
                                                  child: Image.network(
                                                    book.coverImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Center(
                                                        child:
                                                            Icon(Icons.error),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                // Detalhes do livro
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 400,
                                                        child: AppText(
                                                          text: book.title,
                                                          fontWeight: 'bold',
                                                          fontSize:
                                                              AppFontSize.fz07,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      SizedBox(
                                                        width: 200,
                                                        child: AppText(
                                                          text: book.author
                                                                  .isNotEmpty
                                                              ? book.author
                                                                          .length >
                                                                      1
                                                                  ? 'de ${book.author[0]} e outros'
                                                                  : 'de ${book.author[0]}'
                                                              : 'Autor desconhecido',
                                                          fontSize:
                                                              AppFontSize.fz06,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                    ],
                                                  ),
                                                ),
                                                // Botão de excluir
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color:
                                                          AppColors.lightGrey),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              '${book.title}'),
                                                          content: Text(
                                                              'Você deseja remover este item da lista?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              child: Text(
                                                                  'Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    Colors.red,
                                                              ),
                                                              child: const Text(
                                                                  'Remover'),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await store
                                                                      .removeItemFromList(
                                                                    id: book.id,
                                                                    idList: store
                                                                            .readingList[
                                                                        favoriteListIndex ??
                                                                            0]['id'],
                                                                  );
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      store
                                                                          .listBooks
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                } catch (e) {
                                                                  debugPrint(
                                                                      'Erro ao remover item: $e');
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 50,
                  ), // FOOTER
                  const FooterVitrine(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 20, top: 20),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ],
      ),
    );
  }
}
