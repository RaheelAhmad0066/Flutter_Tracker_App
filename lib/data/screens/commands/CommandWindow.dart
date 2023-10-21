import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktrogps/config/static.dart';

import '../../datasources.dart';
import '../../model/Command.dart';

class CommandWindowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CommandPageState();
}

class _CommandPageState extends State<CommandWindowPage> {

  List<Command> commands = [];
  Timer? _timer;

  @override
  initState() {
    super.initState();
    getCommands();
  }

  void getCommands() {
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        _timer!.cancel();
        Iterable list;
        gpsapis.getSavedCommands(StaticVarMethod.deviceId).then((value) => {
              if (value?.body != null)
                {
                  list = json.decode(value!.body),
                  print(list.length),
                  list.forEach((element) {
                    Command command = new Command();
                    command.id = element["id"];
                    command.value = element["type"];
                    command.title = element["title"];
                    commands.add(command);
                  }),
                  setState(() {})
                }
            });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: loadCommands()
    );

  }

  Widget loadCommands() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 150) / 5;
    final double itemWidth = size.width / 2;

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      // Generate 100 widgets that display their index in the List.
      children: List.generate(commands.length, (index) {
        return Container(
            height: 30,
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                sendCommand(commands[index].value);
              },
              child: Text(
                commands[index].title!,
                style: TextStyle(fontSize: 13),
              ),
            ));
      }),
    );

    // children: ListView.builder(
    //   itemCount:
    //   commands.length
    //   ,
    //   itemBuilder: (context, index) {
    //   final device = commands[index];
    //   return Container(
    //   height: 30,
    //   padding: EdgeInsets.all(15),
    //   child: ElevatedButton(
    //   onPressed: () {},
    //   child: Text("Item $index"),
    //   ));
    //   }
    // }));
  }

  void sendCommand(type) {
    Map<String, String> requestBody;

    requestBody = <String, String>{
      'id': "",
      'device_id': StaticVarMethod.deviceId,
      'type': type
    };

    print(requestBody.toString());

    gpsapis.sendCommands(requestBody).then((res) => {
          if (res.statusCode == 200)
            {
              Fluttertoast.showToast(
                  msg: "command_sent",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0),
              Navigator.of(context).pop()
            }
          else
            {
              Fluttertoast.showToast(
                  msg: "Error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0),
              Navigator.of(context).pop()
            }
        });
  }
}
