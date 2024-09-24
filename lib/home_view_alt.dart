// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
// import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
// import 'package:revamp_eperpus_mobile/Cubit/home_page_cubit.dart';
// import 'package:revamp_eperpus_mobile/Cubit/home_page_state.dart';
// import 'package:revamp_eperpus_mobile/Utils/config.dart';
// import 'package:revamp_eperpus_mobile/View/CustomWidget/back_to_exit_popup.dart';
//
// class HomePageAlt extends StatefulWidget {
//   static const routeName = '/homepage_alt';
//   const HomePageAlt({Key? key}) : super(key: key);
//
//   @override
//   State<HomePageAlt> createState() => _HomePageAltState();
// }
//
// class _HomePageAltState extends State<HomePageAlt> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late HomePageCubit homePageCubit;
//
//   int selectedNavIndex = 0;
//   bool isAllowExit = false;
//   DateTime onBackPressedTime = DateTime.now();
//
//   void setAllowExit(bool value) {
//     setState(() {
//       isAllowExit = value;
//     });
//     Future.delayed(const Duration(seconds: 5), () {
//       print('Function executed after 5 seconds');
//       setState(() {
//         isAllowExit = false;
//       });
//     });
//   }
//
//   Future<bool> onBackButtonPressed() async {
//     final difference = DateTime.now().difference(onBackPressedTime);
//     if (difference >= const Duration(seconds: 5) || !isAllowExit) {
//       setAllowExit(true);
//       onBackPressedTime = DateTime.now();
//       backToExitSnack(context, AppLocalizations.of(context)!.pressedToBack);
//       return false;
//     } else {
//       onBackPressedTime = onBackPressedTime.add(const Duration(seconds: 5));
//       setAllowExit(false);
//       if (Platform.isIOS) {
//         exit(0);
//       } else {
//         SystemNavigator.pop(animated: true);
//       }
//       return false;
//     }
//   }
//
//   List<BottomNavigationBarItem> bottomNavigationItems() {
//     List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[];
//
//     navBarItems = <BottomNavigationBarItem>[
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.home_outlined),
//         label: AppLocalizations.of(context)!.home,
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.smartphone_outlined),
//         label: AppLocalizations.of(context)!.device,
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.account_circle_outlined),
//         label: AppLocalizations.of(context)!.account,
//       ),
//     ];
//
//     if (FlavorConfig.instance.flavor == Flavor.blims) {
//       navBarItems.insert(
//         1,
//         BottomNavigationBarItem(
//           icon: const Icon(Icons.auto_stories_outlined),
//           label: AppLocalizations.of(context)!.catalog,
//         ),
//       );
//     }
//
//     return navBarItems;
//   }
//
//   void onChangeSelectedIndex(int index) {
//     setState(() {
//       selectedNavIndex = index;
//       fetchDataForSelectedIndex();
//     });
//   }
//
//   void fetchDataForSelectedIndex() {
//     // Fetch data based on the current tab index
//     switch (selectedNavIndex) {
//       case 0:
//         // dataCubit.fetchDataForTab1();
//         break;
//       case 1:
//         // dataCubit.fetchDataForTab2();
//         break;
//       // Add more cases for additional tabs
//     }
//   }
//
//   @override
//   void initstate() {
//     homePageCubit = HomePageCubit();
//
//     fetchDataForSelectedIndex();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     onBackPressedTime = DateTime.now();
//     return WillPopScope(
//       onWillPop: () => onBackButtonPressed(),
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           foregroundColor: Theme.of(context).textSelectionTheme.selectionColor,
//           backgroundColor: Platform.isIOS
//               ? Theme.of(context).scaffoldBackgroundColor
//               : Colors.transparent,
//           toolbarHeight: 0,
//           elevation: 0,
//         ),
//         resizeToAvoidBottomInset: true,
//         body: BlocConsumer<HomePageCubit, HomePageState>(
//           builder: (context, state) {
//             return Container();
//           },
//           listener: (context, state) {},
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: selectedNavIndex,
//           items: bottomNavigationItems(),
//           onTap: (int index) => onChangeSelectedIndex(index),
//         ),
//       ),
//     );
//   }
// }
