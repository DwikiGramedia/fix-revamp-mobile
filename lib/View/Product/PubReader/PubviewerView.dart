// import 'package:starlight_epub_viewer/starlight_epub_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:revamp_eperpus_mobile/Utils/style.dart';
// import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
//
// class PubviewerView extends StatefulWidget {
//   const PubviewerView({Key? key}) : super(key: key);
//
//   @override
//   State<PubviewerView> createState() => _PubviewerViewState();
// }
//
// class _PubviewerViewState extends State<PubviewerView> {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         child: SizedBox(
//           width: size.width * 0.5,
//           height: 48,
//           child: Button(
//               title: "Mencoba",
//               onTap: ()async{
//
//                 StarlightEpubViewer.setConfig(
//                   ///for viewer color
//                   themeColor: Colors.blue,
//                   ///night mode for viewer
//                   nightMode: true,
//                   ///scroll direction for viewer
//                   scrollDirection: StarlightEpubViewerScrollDirection.VERTICAL,
//                   ///if you want to share your epub file
//                   allowSharing: true,
//                   ///enable the inbuilt Text-to-Speech
//                   enableTts: true,
//                   ///if you want to show remaining
//                   setShowRemainingIndicator: true,
//                 );
//                 StarlightEpubViewer.openAsset(
//                   "assets/dummy/files/ID_HEALME2020MTH04.epub",
//                 );
//               },
//               radius: 12,
//               style: h4Title,
//               color: primaryColor),
//         ),
//       ),
//     );
//   }
// }
