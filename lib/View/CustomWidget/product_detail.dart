// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-30 17:43:59
// @modify date 2022-03-30 17:43:59
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-30 17:43:59

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Helpers/ui_helper.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/product_data.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_state.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    Key? key,
    required this.productData,
    required this.isDarkTheme,
  }) : super(key: key);

  final ProductData productData;
  final bool isDarkTheme;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedPage = 0;
  int pageLength = 5;

  @override
  void initState() {
    super.initState();
    // context.read<ReviewListCubit>().getBookReviewList(
    //       context,
    //       bookId: widget.productData.id,
    //     );
  }

  final PageController _pageViewController =
      PageController(initialPage: 0, keepPage: false);

  Future<ProductData> fetchAlbum() async {
    final response = await http.get(Uri.parse(widget.productData.detailsHref));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ProductData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = widget.isDarkTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDarkTheme ? null : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? const Color(0xff121212) : Colors.white,
        foregroundColor: isDarkTheme ? null : Colors.blue[800],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: secondary),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.bookmark_border_rounded),
            label: const Text(' '),
            style: TextButton.styleFrom(
              primary: isDarkTheme ? whitePrimary : Colors.blue[800],
            ),
            onPressed: () {},
          ),
        ],
        title: Text(
          widget.productData.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDarkTheme ? secondary : Colors.blue[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, BoxConstraints viewportConstraints) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // ANCHOR - Product Image and Preview Function
                        const SizedBox(height: 20),
                        OpenContainer(
                          closedElevation: 0.0,
                          openElevation: 0.0,
                          middleColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedColor: Colors.transparent,
                          transitionType: ContainerTransitionType.fadeThrough,
                          transitionDuration: const Duration(
                            milliseconds: 1000,
                          ),
                          openBuilder: (context, action) {
                            return ProductPreview(
                              maxWidth: viewportConstraints.maxWidth,
                              maxHeight: viewportConstraints.maxHeight * 0.75,
                              imagesArray: widget.productData.previews,
                            );
                          },
                          closedBuilder: (context, openPreviewContainer) {
                            return GestureDetector(
                              onTap: openPreviewContainer,
                              child: productPreviewImages(
                                viewportConstraints.maxWidth,
                                300.0,
                                widget.productData.previews,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // ANCHOR - Product Name and Author
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Column(
                            children: [
                              Text(
                                widget.productData.title,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                widget.productData.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                              const Divider(
                                indent: 0,
                                endIndent: 0,
                                thickness: 2,
                                height: 30,
                              ),
                            ],
                          ),
                        ),

                        // ANCHOR - Product Rating, File Size, Page size, Stock
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: const Color.fromARGB(15, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Rating',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.productData.ratingAverage
                                                .toString() +
                                            '/5',
                                        style: const TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Page Size',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.productData.pageCount.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'File Size',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.productData.fileSize,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Stock',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.productData.currentlyAvailable
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ANCHOR - Borrow, Remind Me
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[800],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                icon: const Icon(Icons.alarm_rounded),
                                label: const Text('Ingatkan',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ))),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ANCHOR - Product Overview
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                'Overview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.productData.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ANCHOR - Product Reviews
                        BlocBuilder<ReviewListCubit, ReviewListState>(
                          builder: (context, state) {
                            if (state is ReviewListResState) {
                              return FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: false,
                                        child: TextButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                            Icons.arrow_back_ios_rounded,
                                            size: 19,
                                          ),
                                          label: const Text(
                                            'See all',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(),
                                        ),
                                      ),
                                      const Text(
                                        'Reviews',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<ReviewListCubit, ReviewListState>(
                          builder: (context, state) {
                            if (state is ReviewListResState) {
                              var size = MediaQuery.of(context).size;
                              bool isLoading = state.props[2] as bool;
                              List<Review> dataList =
                                  state.props[1] as List<Review>;
                              return Visibility(
                                visible: !isLoading && dataList.isNotEmpty,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1,
                                  ),
                                  itemBuilder: (context, index) {
                                    Review item = dataList[index];
                                    return SizedBox(
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.email!,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              Text(
                                                item.reviewDate!,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:
                                                UIHelper.buildRatingStarView(
                                              4,
                                              15.0,
                                            ),
                                          ),
                                          Text(
                                            item.reviewText!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: 2,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        Container(
                          height: 80,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  if (!widget.isDarkTheme)
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withAlpha(0),
                            Colors.white70,
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget productPreviewImages(maxWidth, maxHeight, List<String> imagesArray) =>
      Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: PageView.builder(
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
              itemCount: (imagesArray.isNotEmpty) ? imagesArray.length : 0,
              itemBuilder: (context, index) => Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.productData.coverImageHref,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 30,
                        ),
                      ),
                    ),
                    // child: Image.asset(
                    //   imagesArray[index],
                    // ),
                  ),
                ],
              ),
            ),
          ),
          (imagesArray.length > 1)
              ? Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: UIHelper.buildPageIndicator(
                      (imagesArray.isNotEmpty) ? imagesArray.length : 1,
                      selectedPage,
                      context,
                      indicatorSize: 8,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );

  // Column(
  //       //ProductData productData) => Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: PageView.builder(
  //             controller: _pageViewController,
  //             onPageChanged: (index) {
  //               setState(() {
  //                 selectedPage = index;
  //               });
  //             },
  //             itemBuilder: (context, index) {
  //               return FractionallySizedBox(
  //                 widthFactor: 0.8,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [Image.asset('assets/dummy/images/epub2.png')],
  //                 ),
  //               );
  //             },
  //             itemCount: pageLength,
  //           ),
  //         ),
  //         const SizedBox(height: 50),
  //         Container(
  //           height: 150,
  //           padding: const EdgeInsets.all(0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: UIHelper.buildPageIndicator(pageLength, selectedPage),
  //           ),
  //         ),
  //       ],
  //     );
}

class ProductPreview extends StatefulWidget {
  const ProductPreview({
    Key? key,
    required this.maxWidth,
    required this.maxHeight,
    this.imagesArray,
    this.imagePreview,
  }) : super(key: key);

  final double maxWidth;
  final double maxHeight;
  final List<String>? imagesArray;
  final List<ItemInfoPreview>? imagePreview;

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  int selectedPage = 0;

  int pageLength = 5;

  final PageController _pageViewController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        color: Colors.transparent,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.maxWidth,
                maxHeight: widget.maxHeight,
              ),
              child: PageView.builder(
                controller: _pageViewController,
                onPageChanged: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
                itemCount: (widget.imagesArray!.isNotEmpty)
                    ? widget.imagesArray!.length
                    : 1,
                itemBuilder: (context, index) => Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.imagePreview != null
                              ? widget.imagePreview![index].href!
                              : widget.imagesArray![index],
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            if (widget.imagesArray!.length > 1)
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: UIHelper.buildPageIndicator(
                    (widget.imagesArray!.isNotEmpty)
                        ? widget.imagesArray!.length
                        : 1,
                    selectedPage,
                    context,
                    indicatorSize: 8,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
