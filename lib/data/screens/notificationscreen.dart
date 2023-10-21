
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/events.dart';



class NotificationsPage extends StatefulWidget {

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {



  var _isLoading = true;
  List<EventsData> eventList = [];


  @override
  initState() {
    _isLoading = true;
    //notiList = Consts.notiList;
    getnotiList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //return noNotificationScreen();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          /* iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),*/
          //systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          centerTitle: false,
          title: Center( child:Text("Notification Screen",style: TextStyle(color: Colors.black),)/*Image.asset('assets/appsicon/btplloginlogo.png', height: 40) */) ,
          backgroundColor: Colors.white,
          //bottom: _reusableWidget.bottomAppBar(),
        ),
      body:eventList.length > 0
          ? listView()//listView()
          : (_isLoading)? Center(
     //   child: Text('No data found'),
        child: CircularProgressIndicator(),
             ): Center(
                child: Text('No data found'),
    ) ,
    );

  }

  PreferredSizeWidget  appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      //leading: IconButton(
      //  icon: Icon(Icons.arrow_back, color: Colors.black),
     //   onPressed: () =>   Navigator.pop(context),
     /*   onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
              // builder: (context) => BottomNavigation( loginModel: response)),
              builder: (context) => BottomNavigation()),
          );
        },*/
        //Navigator.of(context,rootNavigator: true).pop(),
     // ),
      title: Text("Notification",style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }
  Widget listView1(){
    return ListView(
        children: ListTile.divideTiles(
            color: Colors.deepPurple,
            tiles: eventList.map((item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: CachedNetworkImage(
                  imageUrl: 'http://116.58.56.123:8008/Content/EmpImg/'+item.id.toString()+'.jpg',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.image),
                ),
              ),
              title: Text(item.name.toString()),
              subtitle: Text(item.message.toString()),

              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
            ))).toList());
  }

  Widget listView(){

    return ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: listViewItems( index),
              onTap: () => onTapped());
        });
    /*return ListView.builder(itemBuilder:(context,index){
      return listViewItems(index);
    },separatorBuilder: (context,index){
      return Divider(height: 0);
    }, itemCount: eventList.length);*/
  }

  onTapped() async {
   /* Consts.DocId=approvalModel.DocId;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GetApproval(loginModel: loginModel)),
    );*/
  }


  Widget listViewItems(int index){
    return Container(
        margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            color: Colors.white,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  prefixIcon(index),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8,right: 30,top: 8,bottom: 15),

                      child: Column(
                        children: [
                          //DeleteIcon(index),
                          message(index),
                          timeAndDate(index),
                        ],
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }

/*  Widget listViewItems(int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(index),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  timeAndDate(index),
                ],
              ),
            ),
          ),
          DeleteIcon(index),
        ],
      ),
    );
  }*/

  Widget prefixIcon(int index){
    var empid=eventList[index].id;
    return /*Container(
      margin: EdgeInsets.only(right: 2, top: 2, bottom: 2),
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: CachedNetworkImage(
          imageUrl: 'http://116.58.56.123:8008/Content/EmpImg/$empid.jpg',
          imageBuilder: (context, imageProvider) => Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                  value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.notifications),
        ),
      ),
    );*/
       Container(
      height: 45,
      width: 45,
      margin: EdgeInsets.only(top:15,left: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
     child: Image.asset("assets/images/alarmnotification96by96.png", height: 55,width: 55),
     /* child: Icon(Icons.notifications,
          size: 25,
          color:Colors.grey.shade700),*/
    );
  }

  Widget DeleteIcon(int index){
    return Container(
     /* margin: EdgeInsets.only( top: 2, bottom: 2),
      width: 30,
      height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _DeleteNotification(eventList[index].alertId!.toInt());
        },
      ),*/
    );


    /*  return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(Icons.notifications,
          size: 25,
          color:Colors.grey.shade700),
    );*/
  }


  Widget message(int index){
    double textsize=12;
    var msg=eventList[index].message.toString();

    return Container(
      padding: EdgeInsets.only(right: 1,top: 10,bottom: 5),
      child: RichText(
        maxLines: 5,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            text:'Your Device ' +eventList[index].deviceName.toString() + ' generate events of ('+ eventList[index].name.toString()+')',
            style: TextStyle(
                fontSize: textsize,
                color: Colors.grey.shade700,
                //fontWeight: FontWeight.bold
            ),
            children: [
             /* TextSpan(
                text:eventList[index].message.toString() == "null" ? "" : eventList[index].message.toString(),
                style: TextStyle(

                    fontWeight: FontWeight.w400),
              )*/
            ]
        ),
      ),
    );
  }

  Widget timeAndDate(int index){
    return Container(
      //margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(right: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(eventList[index].time.toString(),style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
          ),
          // Text(Jiffy(eventList[index].time).fromNow()/*+eventList[index].time.toString()*/,style: TextStyle(
          //   fontSize: 11,
          //   color: Colors.grey.shade700,
          // ),
          // ),
        ],
      ),
    );
  }


  _DeleteNotification(int Id) async {
    print("Delete Notification ");

 /*   RestDataSource api = new RestDataSource();
    var response;
    response = await api.deleteUserNotifications(Id);
    if (response.toString().contains("true")) {
      notiList.clear();
      getnotiList();

    } else {
      print(response);
    }*/
  }

  Future<void> getnotiList() async {
    print("notificationlist");
    _isLoading = true;
    //setState(() {});
    gpsapis api = new gpsapis();
    try {
      eventList = await api.getEventsList(StaticVarMethod.user_api_hash);
      if (eventList.isNotEmpty) {
        StaticVarMethod.eventList=eventList;
        _isLoading = false;
        setState(() {});
      } else {
      }
    }
    catch (e) {
      Fluttertoast.showToast(msg: 'Not exist', toastLength: Toast.LENGTH_SHORT);
    }
/*    api.getEvents(StaticVarMethod.user_api_hash).then((response1) => {
      if (response1.items != null)
        {
          for (var i = 0; i < response1.items!.data!.length; i++) {
            eventList.add(response1.items!.data![i])
          } //store.dispatch(UpdateDeviceAction(value)),
          //connectSocket()
        },

    });
    try {
      if (eventList.isNotEmpty) {
        StaticVarMethod.eventList=eventList;
        _isLoading = false;
        setState(() {});
      } else {
      }
    }
    catch (e) {
      // _showSnackBar("Not exist",0);
    }*/
  }

  Widget noNotificationScreen() {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final pageTitle = Padding(
      padding: EdgeInsets.only(top: 1.0, bottom: 30.0),
      child: Text(
        "Notifications",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40.0,
        ),
      ),
    );

    final image = Image.asset("assets/images/empty.png");

    final notificationHeader = Container(
      padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
      child: Text(
        "No New Notification",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.0),
      ),
    );
    final notificationText = Text(
      "You currently do not have any unread notifications.",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        color: Colors.grey.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 70.0,
          left: 30.0,
          right: 30.0,
          bottom: 30.0,
        ),
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pageTitle,
            SizedBox(
              height: deviceHeight * 0.1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[image, notificationHeader, notificationText],
            ),
          ],
        ),
      ),
    );
  }

/*  Future<void> getnotiList() async {
    print("notificationlist");
    _isLoading = true;
    setState(() {});
    RestDataSource api = new RestDataSource();
    try {
      notiList = await api.getUserNotifications(loginModel.UserID);
      if (notiList.isNotEmpty) {
        _isLoading = false;
        setState(() {});
      } else {
      }
    } catch (e) {
      // _showSnackBar("Not exist",0);
    }
  }*/

}
