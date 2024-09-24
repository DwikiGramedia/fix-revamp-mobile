import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

// ignore: must_be_immutable
class ClientCatalogItem extends StatelessWidget {
  LibraryProductModel data;
  int isDark;
  ClientCatalogItem({
    Key? key,
    required this.data,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: OpenContainer(
        closedColor: Colors.transparent,
        middleColor: isDark == 0 ? Colors.black38 : Colors.white,
        closedElevation: 0.0,
        transitionDuration: const Duration(milliseconds: 300),
        openBuilder: (context, action) => DetailProductView(
          id: data.id,
          itemUrl: data.href,
          detailUrl: data.details!.href,
          bookTitle: data.title,
          bookId: data.id,
          coverImage: data.coverImage,
          currentlyAvailable: data.currentlyAvailable ?? 0,
        ),
        closedBuilder: (context, VoidCallback openContainer) => GestureDetector(
          onTap: openContainer,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      height: 180,
                      width: 153,
                      fit: BoxFit.contain,
                      imageUrl: data.coverImage!.href!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 30,
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const Banner(
                          layoutDirection: TextDirection.ltr,
                          message: "New",
                          color: Colors.blue,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          location: BannerLocation.topEnd,
                          child: SizedBox(
                            height: 197,
                            width: 153,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  child: Text(
                    data.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  data.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
