// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:gpspro/arguments/ReportArguments.dart';
// import 'package:gpspro/localization/app_localizations.dart';
// import 'package:gpspro/services/APIService.dart';
// import 'package:gpspro/theme/CustomColor.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// class ReportTripPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => new _ReportTripPageState();
// }
//
// class _ReportTripPageState extends State<ReportTripPage> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   static ReportArguments args;
//   StreamController<int> _postsController;
//   Timer _timer;
//   bool isLoading = true;
//   static var httpClient = new HttpClient();
//   File file;
//
//   @override
//   void initState() {
//     _postsController = new StreamController();
//     getReport();
//     super.initState();
//   }
//
//   Future<File> _downloadFile(String url, String filename) async {
//     Random random = new Random();
//     int randomNumber = random.nextInt(100);
//     var request = await httpClient.getUrl(Uri.parse(url));
//     var response = await request.close();
//     var bytes = await consolidateHttpClientResponseBytes(response);
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     print(dir);
//     File pdffile = new File('$dir/$filename-$randomNumber.pdf');
//     //Navigator.pop(context); // Load from assets
//     file = pdffile;
//     _postsController.add(1);
//     await file.writeAsBytes(bytes);
//     return file;
//   }
//
//   getReport() {
//     _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
//       if (args != null) {
//         timer.cancel();
//         APIService.getReport(
//                 args.id.toString(), args.fromDate, args.toDate, args.type)
//             .then((value) => {_downloadFile(value.url, "work")});
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     args = ModalRoute.of(context).settings.arguments;
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(args.name,
//               style: TextStyle(color: CustomColor.secondaryColor)),
//           iconTheme: IconThemeData(
//             color: CustomColor.secondaryColor, //change your color here
//           ),
//         ),
//         body: StreamBuilder<int>(
//             stream: _postsController.stream,
//             builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//               if (snapshot.hasData) {
//                 return SfPdfViewer.file(
//                   file,
//                   key: _pdfViewerKey,
//                 );
//               } else if (isLoading) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 return Center(
//                   child: Text(AppLocalizations.of(context).translate('noData')),
//                 );
//               }
//             }));
//   }
// }
