import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitrine_ufma/app/core/components/custom_textfield.dart';
import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/detail_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/action_button.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/add_to_list_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/create_list_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/filtered_book_card.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/material_tags.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final store = Modular.get<DetailStore>();
  final layoutStore = Modular.get<LayoutStore>();
  Book? book;
  double? _rating;
  bool _favorited = false;

  void _isFavorited() {
    if (store.readingList.isNotEmpty) {
      for (var i = 0; i < store.readingList.length; i++) {
        if (store.readingList[i]['name'] ==
            'aee20c6a981fe6633c17340037ebb6472f1d8eb9') {
          var booksIdsInList =
              store.readingList[i]['listInfoMats'].map((e) => e['id']).toList();
          if (booksIdsInList.contains(store.book.id)) {
            setState(() {
              _favorited = true;
            });
            return;
          }
        }
      }
    }
    setState(() {
      _favorited = false;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await store.getBookById(int.parse(Modular.args.params['id']));
      

      book = store.book;
      // _rating = 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
      child: Container(
        child: SingleChildScrollView(child: Observer(builder: (context) {
          if (store.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (book == null) {
            return const Center(
              child: Text("Livro não encontrado"),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchModal(
                expanded: false,
              ),
              buildBookCard(context),
              const SizedBox(height: 20),
            ],
          );
        })),
      ),
    ));
  }

  Widget buildBookCard(BuildContext context) {
    return Center(
      child: Container(
        width: AppConst.maxContainerWidth,
        constraints: BoxConstraints(
          maxHeight: AppConst.maxContainerWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              child: InkWell(
                  onTap: () {
                Navigator.of(context).pop();
                    // store.back();
                  },
                  child: Container(
                    width: 80,
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                // horizontal: AppConst.sidePadding * 2,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem do livro
                  Container(
                    height: 400,
                    child: Image.network(
                      book!.coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título do livro
                        SelectableText(
                          book!.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        // AppText(
                        //   text: book!.title,
                        //   maxLines: 4,
                        //   fontSize: 20,
                        //   fontWeight: 'bold',
                        // ),
                        const SizedBox(height: 10),

                        // Autor do livro
                        AppText(text: book!.author[0], fontSize: 16),
                        const SizedBox(height: 10),

                        // Avaliação do livro
                        // Aqui deve buscar a media de avaliação do livro pela api
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              color: index < (_rating ?? 3)
                                  ? AppColors.yellow
                                  : AppColors.mediumGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const AppText(text: 'Resumo', fontSize: 16),
                        const SizedBox(height: 20),
                        AppText(
                          text: book!.abstract1,
                          textAlign: TextAlign.justify,
                          fontSize: 16,
                          maxLines: 20,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const AppText(text: 'Tags: ', fontSize: 16),
                            book!.tags.isEmpty
                                ? const AppText(text: 'Sem tags', fontSize: 16)
                                : MaterialTags(tags: book!.tags),
                            const SizedBox(width: 10),
                            if (layoutStore.permissions.isEmpty)
                            const SizedBox()
                            else if (layoutStore.permissions[0]['permission_type'] ==
                                "FULL")
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController tagController =
                                            TextEditingController();
                                        return AlertDialog(
                                          title: const Text('Adicionar Tag'),
                                          content: TextField(
                                            controller: tagController,
                                            decoration: const InputDecoration(
                                                hintText: "Digite a nova tag"),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (tagController
                                                    .text.isNotEmpty) {
                                                  await store.addTagToMaterial(
                                                    bookId: book!.id.toInt(),
                                                    tags: [
                                                          tagController.text
                                                              .toString()
                                                        ] +
                                                        book!.tags,
                                                  );

                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Adicionar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Tooltip(
                                    message: 'Adicionar Tag',
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.cutGrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () async {
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Remover todas as tags'),
                                          content: const Text(
                                              'Você tem certeza que deseja remover todas as tags deste material?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Remover'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      await store.addTagToMaterial(
                                          bookId: book!.id.toInt(), tags: []);
                                    }
                                  },
                                  child: const Tooltip(
                                    message: 'Remover todas as tags',
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.cutGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Observer(builder: (context) {
                    if (layoutStore.permissions.isEmpty) {
                      return Container();
                    }
                    if (layoutStore.permissions[0]['permission_type'] ==
                        "FULL") {
                      return InkWell(
                        onTap: () {
                          Modular.to.pushNamed(
                            '/register-material/edit',
                            arguments: store.book,
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppColors.black,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            AppText(
                              text: "Editar",
                              fontSize: AppFontSize.fz05,
                              fontWeight: 'medium',
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),

                  const SizedBox(
                    width: 20,
                  ),
                  //BOTÃO DE EXCLUIR
                  Observer(builder: (context) {
                    if (layoutStore.permissions.isEmpty) {
                      return Container();
                    }
                    if (layoutStore.permissions[0]['permission_type'] ==
                        "FULL") {
                      return InkWell(
                        onTap: () {
                          store.removeBook(store.book.id);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.delete,
                              color: AppColors.normalRed,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            AppText(
                              text: "Excluir",
                              fontSize: AppFontSize.fz05,
                              fontWeight: 'medium',
                              color: AppColors.normalRed,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConst.sidePadding * 2,
              ),
              child: Row(
                children: [
                  const AppText(text: 'Avalie: ', fontSize: 16),
                  Container(
                      child: GestureDetector(
                    onTap: () => layoutStore.permissions.isEmpty
                        ? showSnackbarError(
                            'Você precisa estar logado para avaliar um material',
                          )
                        : null,
                    child: RatingBar.builder(
                      // Aqui adicionar a avaliaçao feita pelo usuario deste material
                      initialRating: _rating ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      tapOnlyMode: true,
                      itemSize: 30.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: AppColors.yellow,
                      ),
                      ignoreGestures: layoutStore.permissions.isEmpty,
                      onRatingUpdate: (rating) async {
                        await store.setReview(
                            bookId: store.book.id.toInt(),
                            rating: rating.toDouble());
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                  )),
                  if (layoutStore.permissions.isNotEmpty &&
                      _rating != 0.0 &&
                      _rating != null)
                    InkWell(
                      onHover: (value) {
                        if (value) {
                          AppText(
                            text: 'Remover avaliação',
                            fontSize: 16,
                            color: AppColors.normalRed,
                          );
                        }
                      },
                      onTap: () async {
                        await store.deleteReview(bookId: store.book.id);
                        setState(() {
                          _rating = 0.0;
                        });
                      },
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: AppColors.normalRed,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConst.sidePadding * 2,
              ),
              child: Row(
                children: [
                  SizedBox(
                    child: PopupMenuButton<void Function()>(
                      color: AppColors.white,
                      iconColor: AppColors.white,
                      padding: EdgeInsets.zero,
                      tooltip: "",
                      shadowColor: AppColors.black.withOpacity(0.3),
                      splashRadius: 5,
                      surfaceTintColor: AppColors.white,
                      icon: const SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.mediumGrey,
                            ),
                            SizedBox(width: 10),
                            AppText(text: 'Adicionar a lista', fontSize: 16),
                          ],
                        ),
                      ),
                      onSelected: (value) => value(),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: () {
                            if (layoutStore.permissions.isEmpty) {
                              showSnackbarError(
                                'Você precisa estar logado para adicionar um livro a uma lista',
                              );
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (_) => CreateListModal(
                                bookId: store.book.id,
                              ),
                            );
                          },
                          child: const AppText(
                            text: 'Criar nova lista',
                            fontWeight: 'medium',
                            fontSize: AppFontSize.fz04,
                            color: AppColors.black,
                          ),
                        ),
                        PopupMenuItem(
                          value: () {
                            if (layoutStore.permissions.isEmpty) {
                              showSnackbarError(
                                'Você precisa estar logado para favoritar um livro',
                              );
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (_) => AddToListModal(
                                bookId: store.book.id,
                              ),
                            );
                          },
                          child: const AppText(
                            text: 'Adicionar a minha lista',
                            fontWeight: 'medium',
                            fontSize: AppFontSize.fz04,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Observer(builder: (context) {
                    if (store.loading) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.black,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        if (layoutStore.permissions.isEmpty) {
                          showSnackbarError(
                            'Você precisa estar logado para favoritar um livro',
                          );
                          return;
                        }
                        bool favoriteListExists = false;
                        int favoriteListIndex = -1;

                        // Verificar se a lista favoritos existe
                        for (var i = 0; i < store.readingList.length; i++) {
                          if (store.readingList[i]['name'] ==
                              'aee20c6a981fe6633c17340037ebb6472f1d8eb9') {
                            favoriteListExists = true;
                            favoriteListIndex = i;
                            break;
                          }
                        }

                        if (favoriteListExists) {
                          if (_favorited) {
                            await store.removeItemFromList(
                                id: store.book.id,
                                idList: store.readingList[favoriteListIndex]
                                    ['id']);
                            setState(() {
                              _favorited = false;
                            });
                            showSnackbarSuccess(
                                "Material removido da lista de favoritos");
                          } else {
                            await store.addItemsToList(
                                id: store.book.id,
                                idList: store.readingList[favoriteListIndex]
                                    ['id']);
                          }
                        } else {
                          await store.addFavorite(store.book.id);
                        }

                        await store.getMaterialList();
                        _isFavorited();
                      },
                      child: _favorited
                          ? const SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: AppColors.lightRed,
                                  ),
                                  SizedBox(width: 10),
                                  AppText(text: 'Favoritar', fontSize: 16),
                                ],
                              ),
                            )
                          : const SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: AppColors.mediumGrey,
                                  ),
                                  SizedBox(width: 10),
                                  AppText(text: 'Favoritar', fontSize: 16),
                                ],
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConst.sidePadding * 2,
              ),
              child: Row(
                children: [
                  ActionButton(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse(store.book.summary))) {
                        throw Exception('Could not launch');
                      }
                    },
                    text: 'Visualizar sumário',
                  ),
                  const SizedBox(width: 20),
                  ActionButton(
                    onTap: () async {
                      if (!await launchUrl(
                        Uri.parse(store.book.availability),
                      )) {
                        throw Exception('Could not launch');
                      }
                    },
                    text: 'Consultar disponibilidade',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConst.sidePadding * 2,
              ),
              child: Row(
                children: [
                  Builder(builder: (context) {
                    if (layoutStore.permissions.isEmpty) {
                      return Container();
                    }
                    return const ActionButton(
                      text: 'Adicionar tag',
                    );
                  }),
                  if (layoutStore.permissions.isNotEmpty)
                    const SizedBox(width: 20),
                  ActionButton(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse(store.book.address))) {
                        throw Exception('Could not launch');
                      }
                    },
                    text: 'Consultar endereço',
                  ),
                ],
              ),
            ),
            Observer(
              builder: (context) {
                if (!store.loading) {
                  if (store.relatedBooks.length > 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            SizedBox(width: 70),
                            AppText(
                              text: 'Materiais relacionados',
                              fontSize: 20,
                              fontWeight: 'bold',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width - 400,
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: store.relatedBooks.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,
                              mainAxisExtent: 300,
                              mainAxisSpacing: 20,
                              crossAxisCount: store.bookCount(
                                  MediaQuery.of(context).size.width - 400),
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Modular.to.pushNamed(
                                      'book/${store.relatedBooks[index].id}');
                                  // store
                                  //     .setSelectedBook(store.relatedBooks[index]);
                                },
                                child: FilteredBookCard(
                                    book: store.relatedBooks[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            SizedBox(width: 70),
                            AppText(
                              text: 'Materiais relacionados',
                              fontSize: 20,
                              fontWeight: 'bold',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: store.relatedBooks.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,
                              mainAxisExtent: 300,
                              mainAxisSpacing: 20,
                              crossAxisCount: store.bookCount(
                                  MediaQuery.of(context).size.width - 200),
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Modular.to.pushNamed(
                                      'book/${store.mostAccessedMaterials[index].id}');
                                  // store.setSelectedBook(
                                  //     store.mostAccessedMaterials[index]);
                                },
                                child: FilteredBookCard(
                                    book: store.mostAccessedMaterials[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
