// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 02:55:42
// @modify date 2022-03-30 02:38:27
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 02:55:42

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Auth/register_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Locale/locale_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Borrow/borrow_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/BorrowHistory/borrow_hirstory_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Collection/collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DetailProduct/detail_product_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/device_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/saved_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DigitalCard/digital_card_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Library/product_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/PopularBook/popular_book_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/RecommendationBook/recommendation_book_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/book_rating_add_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/SearchBook/search_book_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/WatchList/watch_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Theme/theme_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Auth/forgot_password_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Service/MessagingService.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/ForgotPassword/forgot_password_view.dart';
import 'package:revamp_eperpus_mobile/View/Onboarding/onboarding.dart';
import 'package:revamp_eperpus_mobile/View/Product/SearchLibrary/search_book_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/AboutUs/about_us_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/BorrowingHistory/borrowing_history_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/ChangePassword/ChangePasswordView.dart';
import 'package:revamp_eperpus_mobile/View/Profile/DigItalCard/digital_card_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/EditProfile/edit_profile_view.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/View/SignUp/signup_view.dart';
import 'package:revamp_eperpus_mobile/View/Splash/splash_view.dart';
import 'package:revamp_eperpus_mobile/buffer_test.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';
import 'package:showcaseview/showcaseview.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      initColibrioReader();
    }
    // initDynamicLinks();
    // initService(context);
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      debugLog("onLink error: ${error.message}");
    });
  }

  Future<void> initService(BuildContext context) async {
    await MessagingService().openMessage(context);
  }

  void afterBuild() {
    // executes after build is done
    MessagingService().requestNotification();
    initDynamicLinks();
    initService(context);
    //setVersionAndToken();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => DetailProductCubit()),
        BlocProvider(create: (context) => BorrowCubit()),
        BlocProvider(create: (context) => BorrowHistoryCubit()),
        BlocProvider(create: (context) => WatchListCubit()),
        BlocProvider(create: (context) => DeviceCollectionCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => BookRatingAddCubit()),
        BlocProvider(create: (context) => ReviewListCubit()),
        BlocProvider(create: (context) => SearchBookCubit()),
        BlocProvider(create: (context) => RecommendationBookCubit()),
        BlocProvider(create: (context) => PopularBookCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => DigitalCardCubit()),
        BlocProvider(create: (context) => CollectionCubit()),
        BlocProvider(create: (context) => CategoryListCubit()),
        BlocProvider(create: (context) => CatalogCubit()),
        BlocProvider(create: (context) => SavedCollectionCubit()),
        BlocProvider(create: (context) => ForgotPasswordCubit()),
      ],
      child: BlocConsumer<ThemeCubit, ThemeState>(
        builder: (context, state) {
          context.read<ThemeCubit>().getDarkMode();

          return ShowCaseWidget(
            // disableBarrierInteraction: true,
            onStart: (index, key) {
              log('onStart: $index, $key');
            },
            onComplete: (index, key) {
              log('onComplete: $index, $key');
              if (index == 4) {
                SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle.light.copyWith(
                    statusBarIconBrightness: Brightness.light,
                    statusBarColor: Colors.black,
                  ),
                );
              }
            },
            blurValue: 1,
            builder: Builder(
              builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: ApiClient.instance.appname,
                  initialRoute: '/splash',
                  builder: (context, child) {
                    return Overlay(
                      initialEntries: [
                        OverlayEntry(
                          builder: (context) {
                            return ShowCaseWidget(
                              builder: Builder(
                                builder: (context) {
                                  return child!;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  theme: state is ChangeThemeAppSuccess
                      ? state.appThemeData
                      : null,
                  routes: <String, WidgetBuilder>{
                    SplashView.routeName: (context) => const SplashView(),
                    AboutUsView.routeName: (context) => AboutUsView(),
                    BorrowingHistoryView.routeName: (context) =>
                        BorrowingHistoryView(),
                    ChangePasswordView.routeName: (context) =>
                        ChangePasswordView(),
                    EditProfileView.routeName: (context) => EditProfileView(),
                    '/test': (BuildContext context) => const LogoApp(),
                    HomePage.routeName: (BuildContext context) =>
                        const HomePage(),
                    SignInUIForm.routeName: (BuildContext context) =>
                        const SignInUIForm(),
                    SignUpPage.routeName: (BuildContext context) =>
                        const SignUpPage(),
                    OnBoardingView.routeName: (BuildContext context) =>
                        const OnBoardingView(),
                    DigitalCardView.routeName: (BuildContext context) =>
                        const DigitalCardView(),
                    ForgotPasswordView.routeName: (BuildContext context) =>
                        const ForgotPasswordView(),
                    SearchBookView.routeName: (BuildContext context) =>
                        const SearchBookView(),
                  },
                  locale: state is ChangeThemeAppSuccess
                      ? state.locale
                      : const Locale("id"),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  onUnknownRoute: (RouteSettings settings) {
                    return MaterialPageRoute<void>(
                      settings: settings,
                      builder: (BuildContext context) => const Scaffold(
                        body: Center(child: Text('Not Found')),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        listener: (context, state) async {},
      ),
    );
  }
}
