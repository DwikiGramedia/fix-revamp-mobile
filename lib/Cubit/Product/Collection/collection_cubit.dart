import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit() : super(CollectionInitial());

  PagingController<int, LibraryProductModel> collectionController =
      PagingController(firstPageKey: 0);
  int contentLimitCollection = 6;
  int offsetCollection = 0;
  List<LibraryProductModel> modelCollection = [];
  Catalog? catalogHref;

  bool isFirstInit = true;

  void initState() {
    emit(CollectionLoading());
    emit(GetListDataProductCollection(
      modelCollection: modelCollection,
      collectionController: collectionController,
      initContentCountCollection: contentLimitCollection,
      contentCountCollection: offsetCollection,
      isFirstInit: isFirstInit,
    ));
  }

  void resetCollection() {
    collectionController = PagingController(firstPageKey: 0);
    contentLimitCollection = 6;
    offsetCollection = 0;
    modelCollection.clear();
    modelCollection = [];
    isFirstInit = true;
  }

  Future<void> getCollectionList(
    BuildContext context, {
    int? pageKey,
    int? organizationId,
    int? catalogId,
  }) async {
    try {
      if (isFirstInit) {
        emit(CollectionLoading());

        //List<Catalog>? catalog = await ProductService().getCatalogSubs();
        // List<OrganizationModel>? organizationData = user?.organizations
        //     ?.where((element) => element.appname == ApiClient.instance.appname)
        //     .toList();
        // var index = 0;
        // var indexJ = 0;
        // List<Catalog> catalogData = [];
        // await debugLog(organizationData);
        // while (index < organizationData!.length) {
        //   Organization? organization = await ProductService()
        //       .getOrganization(organizationData[index].id);
        //   List<Catalog>? catalogList = organization?.catalog;

        //   for (var item in catalogList!) {
        //     catalogData.add(item);
        //   }
        //   index++;
        // }

        //catalogHref = catalogData.last;
        modelCollection = await ProductService().getProductsByCatalog(
            href:
                "${ApiClient.instance.baseUrl}organizations/1100769/shared-catalogs/15",
            offset: offsetCollection,
            limit: contentLimitCollection,
            queryString: "");
        if (modelCollection.length < contentLimitCollection) {
          collectionController.appendLastPage(modelCollection);
        } else {
          offsetCollection = offsetCollection + contentLimitCollection;
          final nextPageKey = contentLimitCollection + modelCollection.length;
          collectionController.appendPage(modelCollection, nextPageKey);
        }
        isFirstInit = false;
        emit(GetListDataProductCollection(
          modelCollection: modelCollection,
          collectionController: collectionController,
          initContentCountCollection: contentLimitCollection,
          contentCountCollection: offsetCollection,
          isFirstInit: isFirstInit,
        ));
      } else {
        modelCollection = await ProductService().getProductsByCatalog(
          href:
              "${ApiClient.instance.baseUrl}organizations/1100769/shared-catalogs/15",
          queryString: "",
          offset: offsetCollection,
          limit: contentLimitCollection,
        );
        if (modelCollection.length < contentLimitCollection) {
          collectionController.appendLastPage(modelCollection);
        } else {
          offsetCollection = offsetCollection + contentLimitCollection;
          final nextPageKey = contentLimitCollection + modelCollection.length;
          collectionController.appendPage(modelCollection, nextPageKey);
        }
        isFirstInit = false;
        emit(GetListDataProductCollection(
          modelCollection: modelCollection,
          collectionController: collectionController,
          initContentCountCollection: contentLimitCollection,
          contentCountCollection: offsetCollection,
          isFirstInit: isFirstInit,
        ));
      }
    } catch (e) {
      debugPrint('error: $e');
      if (e.toString() == "Force logout") {
        emit(CollectionUserForceLogout());
      } else {
        emit(GetListCollectionFailed(error: e.toString()));
      }
    }
  }
}
