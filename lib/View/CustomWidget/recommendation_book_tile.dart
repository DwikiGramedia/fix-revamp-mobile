import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/RecommendationBook/recommendation_book_cubit.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

import '../../Utils/style.dart';

class RecommendationBookWidget extends StatelessWidget {
  final int isDark;
  final int id;
  final String title;
  final String image;
  final String subtitle;
  final bool? isBookNew;
  const RecommendationBookWidget({
    required this.isDark,
    required this.id,
    required this.title,
    required this.image,
    required this.subtitle,
    this.isBookNew = false,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: BlocBuilder<RecommendationBookCubit, RecommendationBookState>(
        builder: (context, state) {
          LibraryProductModel? data;
          return OpenContainer(
            closedColor: Colors.transparent,
            middleColor: isDark == 0 ? Colors.black38 : Colors.white,
            closedElevation: 0.0,
            transitionDuration: const Duration(milliseconds: 1200),
            openBuilder: (context, action) {
              context
                  .read<RecommendationBookCubit>()
                  .getRecommendationDetail(id);
              data = context.read<RecommendationBookCubit>().bookDetail;
              if (data != null) {
                return DetailProductView(
                  id: data?.id,
                  itemUrl: data?.href,
                  detailUrl: data?.details!.href,
                  bookTitle: data?.title,
                  bookId: data?.id,
                  coverImage: data?.coverImage,
                );
              } else {
                return const Center(
                  child: Text('Buku Tidak Ditemukan'),
                );
              }
            },
            closedBuilder: (context, VoidCallback openContainer) {
              return GestureDetector(
                onTap: openContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isBookNew!
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Banner(
                              layoutDirection: TextDirection.ltr,
                              message: "New",
                              color: Colors.blue,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                              location: BannerLocation.topEnd,
                              child: CachedNetworkImage(
                                width: 136,
                                height: 175,
                                fit: BoxFit.fill,
                                imageUrl: image,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            width: 136,
                            height: 175,
                            fit: BoxFit.fill,
                            imageUrl: image,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 30,
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
                      subtitle,
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
            },
          );
        },
      ),
    );
  }
}
