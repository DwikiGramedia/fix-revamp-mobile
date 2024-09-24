import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_state.dart';
import 'package:revamp_eperpus_mobile/View/CategoryBooks/CategoryBooksNewView.dart';

import '../../Utils/Style.dart';
import '../../model/CatalogesDataModel.dart';

class CategoryListNewView extends StatefulWidget {
  CatalogData catalog;
  CategoryListNewView({required this.catalog});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryListNewViewState();
  }
}

class CategoryListNewViewState extends State<CategoryListNewView> {
  @override
  void initState() {
    // TODO: implement initState
    context
        .read<CategoryListCubit>()
        .getCategoryCatalog(widget.catalog.href ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;

    Widget categoryList() {
      return BlocBuilder<CategoryListCubit, CategoryListState>(
          builder: (context, state) {
        if (state is CategorylistLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetCategorylistSuccess) {
          var dataCategory = state.model.meta.facets[1].values;
          return SizedBox(
            height: size.height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: dataCategory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryBooksNewView(
                                  category: dataCategory[index].value,
                                  catalog: widget.catalog)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blueGrey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dataCategory[index].value,
                              style: subhead2,
                            ),
                            Text(
                              "${dataCategory[index].count}",
                              style: paragraph4,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.category),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: categoryList(),
        ),
      ),
    );
  }
}
