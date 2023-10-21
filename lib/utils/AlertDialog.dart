import 'Consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class AlertDialog_ {

  String title ="", desc ="";
  AlertDialog_();

  Widget showError(String title, String desc, BuildContext context) {

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Colors.red.shade800
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text("OK"),
              ),
            ),
          ],
        ),
      ),
    );
//    return Card(
//      elevation: 3,
//        child: new Center(
//            child: new Text(title+"\n"+desc, style:
//            TextStyle(color: Colors.black, fontSize: 18),)),
//    );

  }
}