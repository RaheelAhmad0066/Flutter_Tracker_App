

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktrogps/mvvm/utils/route/routes_name.dart';

import '../../../data/screens/signin.dart';

class Routes{
  
  static Route<dynamic>  generateRoute(RouteSettings settings){
    switch(settings.name){
      case RouteName.login:
        return MaterialPageRoute(builder: (BuildContext context)=> signin());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(child: Text("No route Defined"),),
        );
        });
    }
  }
}