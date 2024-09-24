import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_state.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/rating_card_tile.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/information_rating_component.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/rating_bar.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_list_model.dart';

class ReviewProductView extends StatefulWidget {
  final ItemInfoModel model;
  const ReviewProductView({Key? key, required this.model}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReviewProductViewState();
  }
}

class ReviewProductViewState extends State<ReviewProductView>
    with SingleTickerProviderStateMixin {
  bool animation = true;
  @override
  void initState() {
    // TODO: implement initState
    context.read<ReviewListCubit>().getBookReviewList(
          context,
          bookId: widget.model.id!,
        );
    super.initState();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() => animation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // TODO: implement build
    return BlocBuilder<ReviewListCubit, ReviewListState>(
        builder: (context, state) {
      ReviewListRes reviewListRes = state.props[0] as ReviewListRes;
      List<Review> dataList = state.props[1] as List<Review>;
      final int ratingOne = reviewListRes.metadata!['ratings']['1'];
      final int ratingTwo = reviewListRes.metadata!['ratings']['2'];
      final int ratingThree = reviewListRes.metadata!['ratings']['3'];
      final int ratingFour = reviewListRes.metadata!['ratings']['4'];
      final int ratingFive = reviewListRes.metadata!['ratings']['5'];
      final double ratingAverage = reviewListRes.metadata!['ratings']['total'];
      final int ratingTotal = reviewListRes.metadata!['resultset']['limit'];
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.reviews,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            // Rating Widget
            SliverToBoxAdapter(
              child: Container(
                width: size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$ratingAverage/5",
                              style: h4Title,
                            ),
                            RatingbarWidget(
                              currentRating: ratingAverage,
                              opacityRating: 1.0,
                              sizeIcon: 20,
                            ),
                            Text("dari $ratingTotal ulasan")
                          ],
                        ),
                        const VerticalDivider(
                          thickness: 2,
                          endIndent: 40,
                          indent: 40,
                          width: 10,
                          color: Colors.black,
                        ),
                        GestureDetector(
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InformationRatingComponent(
                                allTotalRating: ratingTotal.toDouble(),
                                sizeIcon: 12,
                                opacityRating: 1.0,
                                totalRating: ratingFive,
                                currentRating: 5,
                                isAnimation: animation,
                              ),
                              InformationRatingComponent(
                                allTotalRating: ratingTotal.toDouble(),
                                sizeIcon: 12,
                                opacityRating: 1.0,
                                totalRating: ratingFour,
                                currentRating: 4,
                                isAnimation: animation,
                              ),
                              InformationRatingComponent(
                                allTotalRating: ratingTotal.toDouble(),
                                sizeIcon: 12,
                                opacityRating: 1.0,
                                totalRating: ratingThree,
                                currentRating: 3,
                                isAnimation: animation,
                              ),
                              InformationRatingComponent(
                                allTotalRating: ratingTotal.toDouble(),
                                sizeIcon: 12,
                                opacityRating: 1.0,
                                totalRating: ratingTwo,
                                currentRating: 2,
                                isAnimation: animation,
                              ),
                              InformationRatingComponent(
                                allTotalRating: ratingTotal.toDouble(),
                                sizeIcon: 12,
                                opacityRating: 1.0,
                                totalRating: ratingOne,
                                currentRating: 1,
                                isAnimation: animation,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // SizedBox(
                    //   width: size.width,
                    //   height: 48,
                    //   child: Button(
                    //     style: h3Title.copyWith(color: Colors.white),
                    //     title: AppLocalizations.of(context)!.writeReview,
                    //     radius: 12,
                    //     onTap: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) {
                    //           return Dialog(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             child: PostReviewDialog(
                    //               model: widget.model,
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     },
                    //     color: primaryColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              sliver: SliverAnimatedList(
                itemBuilder: (context, index, animation) {
                  Review item = dataList[index];
                  return RatingCardTile(item: item);
                },
                initialItemCount: dataList.length,
              ),
            ),
          ],
        ),
      );
    });
  }
}
