import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/client_catalog_item.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

class ClientCatalogGrid extends StatelessWidget {
  final List<LibraryProductModel> model;
  final int isDark;
  final PagingController<int, LibraryProductModel> pagingController;
  const ClientCatalogGrid({
    Key? key,
    required this.model,
    required this.isDark,
    required this.pagingController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 1.0,
          mainAxisExtent: 350,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ClientCatalogItem(
              data: model[index],
              isDark: isDark,
            );
          },
          childCount: model.length,
        ),
      ),
    );
  }
}
//return ClientCatalogItem(model: widget.model[index]);
