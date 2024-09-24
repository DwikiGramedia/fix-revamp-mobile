import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/device_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/saved_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardBookBorrowedWidget extends StatelessWidget {
  String image;
  String title;
  String name;

  CardBookBorrowedWidget({
    required this.title,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      height: 256,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(1, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              height: 160,
              width: 136,
              fit: BoxFit.contain,
              imageUrl: image,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 5),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            name,
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
    );
  }
}

class CardBookDownloadedWidget extends StatelessWidget {
  int isDark;
  int id;
  String itemUrl;
  String detailUrl;
  String bookTitle;
  int bookId;
  CoverImage coverImage;
  String name;
  String downloadUrl;
  String expiresDate;

  CardBookDownloadedWidget({
    required this.isDark,
    required this.id,
    required this.itemUrl,
    required this.detailUrl,
    required this.bookTitle,
    required this.bookId,
    required this.coverImage,
    required this.name,
    required this.downloadUrl,
    required this.expiresDate,
  });

  bool isClosed = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return OpenContainer(
      closedColor: Colors.transparent,
      middleColor: isDark == 0 ? Colors.black38 : Colors.white,
      closedElevation: 0.0,
      transitionDuration: const Duration(milliseconds: 300),
      openBuilder: (context, action) {
        isClosed = false;
        return DetailProductView(
          id: id,
          itemUrl: itemUrl,
          detailUrl: detailUrl,
          bookTitle: bookTitle,
          bookId: bookId,
          coverImage: coverImage,
          downloadUrl: downloadUrl,
        );
      },
      closedBuilder: (context, VoidCallback openContainer) {
        if (!isClosed) {
          context.read<DeviceCollectionCubit>().getDeviceCollection();
          context
              .read<SavedCollectionCubit>()
              .getDataSaved();
        }
        return Container(
          width: 282,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(1, 1)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  width: 72,
                  height: 104,
                  fit: BoxFit.contain,
                  imageUrl: coverImage.href!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 164,
                        child: Text(
                          bookTitle,
                          style: h6Title.copyWith(fontSize: 15),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 164,
                        child: Text(
                          name,
                          style: subhead3.copyWith(
                              color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dueTime,
                          style: paragraph5.apply(color: Colors.redAccent),
                          maxLines: 2,
                        ),
                        Text(
                          expiresDate,
                          style: paragraph5,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
