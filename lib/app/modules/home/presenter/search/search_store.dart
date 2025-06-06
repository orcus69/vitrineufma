import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  TextEditingController searchController = TextEditingController();
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @observable
  List<Book> booksFiltered = <Book>[];
  @observable
  bool loading = false;

  @observable
  ObservableMap<String, dynamic> filter = <String, dynamic>{
    "value": "all",
    "name": "Todos os Campos"
  }.asObservable();

  //Filtros
  List filters = [
    {"value": "all", "name": "Todos os Campos"},
    {"value": "title", "name": "Título"},
    {"value": "author", "name": "Autor"},
    {"value": "matters", "name": "Assunto"},
    {"value": "tags", "name": "Tags"}
  ];
  //METODO DE APLICAÇÃO DE FILTRO
  @action
  void applyFilter(Map<String, dynamic> newFilter) {
    filter = ObservableMap<String, dynamic>.of(newFilter);
  }

  //METODOS DE BUSCA
  @action
  Future<void> searchWithFilters() async {
    search(searchController.text);
    
    // Modular.to.pushNamed('./result/${searchController.text}');
  
    booksFiltered.clear();
    
  }

  @action
  Future<void> search(String search) async {

    if (search.isEmpty) {
      loading = true;
      booksFiltered.clear();
      loading = false;
      return;
    }

    loading = true;

    print('Buscando $search com o filtro ${filter['value']}');

    var result = await infoMaterialUsecase.getFilteredMaterial(
        search, filter['value'], null);

    result.fold((l) {
      showSnackbarError(l.message);
    }, (r) {
      booksFiltered = List<Book>.of(r);

      Modular.to.pushNamed('./result/${searchController.text}', arguments: booksFiltered);
    });

    loading = false;
  }

  @action
  Future<void> advancedSearchMethod(Map<String, dynamic> query) async {
    try {
      loading = true;
      booksFiltered.clear();

      var result = await infoMaterialUsecase.getFilteredMaterial(
          searchController.text, filter['value'], query);

      result.fold((error) {
        debugPrint("Error: $error");
        loading = false;
      }, (books) {
        booksFiltered = List<Book>.from(books);
        if (booksFiltered.isEmpty) {
          // Handle empty results
          debugPrint("No results found");
        }
        // Navigate to search results page with the filtered books
        Modular.to.pushNamed('result', arguments: booksFiltered);
        loading = false;
      });
    } catch (e) {
      debugPrint("Error in advanced search: $e");
      loading = false;
    }
  }




}