import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReportStopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReportStopPageState();
}

class _ReportStopPageState extends State<ReportStopPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late StreamController<int> _postsController;
  late Timer _timer;
  bool isLoading = true;
  static var httpClient = new HttpClient();
  late File file;

  @override
  void initState() {
    _postsController = new StreamController();
    getReport();
    super.initState();
  }

  Future<File?> _downloadFile(String? url, String filename) async {
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    print(url);
    if (url != null) {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File pdffile = new File('$dir/$filename-$randomNumber.pdf');
      //Navigator.pop(context); // Load from assets
      file = pdffile;
      _postsController.add(1);
      await file.writeAsBytes(bytes);
      return file;
    } else {
      isLoading = false;
      _postsController.add(0);
      setState(() {});
    }
  }

  getReport() {
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        timer.cancel();

        gpsapis.getReport(
            StaticVarMethod.deviceId, StaticVarMethod.fromdate, StaticVarMethod.todate, StaticVarMethod.reportType)
            .then((value) => {_downloadFile(value?.url, "stop")});
/*        APIService.getReport(
                args.id.toString(), args.fromDate, args.toDate, args.type)
            .then((value) => {_downloadFile(value.url, "stop")});*/

    });
  }

  @override
  Widget build(BuildContext context) {
    //args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(StaticVarMethod.deviceName,
              style: TextStyle(color:  Colors.black)),
          iconTheme: IconThemeData(
            color:  Colors.black, //change your color here
          ),
        ),
        body: StreamBuilder<int>(
            stream: _postsController.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.data == 1) {
                return SfPdfViewer.file(
                  file,
                  key: _pdfViewerKey,
                );
              } else if (isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == 0) {
                return Center(
                  child: Text('No Data'),
                );
              } else {
                return Center(
                  child: Text('No Data'),
                );
              }
            }));
  }
}
