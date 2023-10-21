

import 'package:flutter/material.dart';
import 'package:maktrogps/config/apps/food_delivery/global_style.dart';
import 'package:maktrogps/config/static.dart';


class termsandconditions extends StatefulWidget {
  @override
  _termsandconditionsState createState() => _termsandconditionsState();
}

class _termsandconditionsState extends State<termsandconditions> {
  // initialize reusable widget
  // final _reusableWidget = ReusableWidget();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        centerTitle: true,
        title: Text('Terms and Conditions', style: GlobalStyle.appBarTitle),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        //bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        children: [
          _buildTotalSummary()
        ],
      ),

    );
  }

  Widget _buildTotalSummary(){
    return Container(
      margin: EdgeInsets.all(10),

      child:
                Text('Terms of service\n' +
                "This is a legal agreement between Customer and www.TrackCarOnline.com for the service use. \n" +
                    "By using our service, you agree to be bound by the terms and conditions of this \n" +
                    "agreement.\n" +
                    "It means you agreed the ToS if you login to the system.\n" +
                    "General terms\n" +
                    "• You are not allowed to copy or distribute any material contained in the web site;\n" +
                    "• We do not allow covert tracking. You may not use our service to track a person without \n" +
                    "his or her consent, or track an object without the permission of its owner;\n" +
                    "• You may not use the service where such use is illegal. It is your responsibility to ensure \n" +
                    "that your intended use of GPS tracking does not violate local, state or federal laws;\n" +
                    "• You may not send automated requests to www.TrackCarOnline.com, attempt to circumvent \n" +
                    "www.TrackCarOnline.com's authentication measures, reverse engineer our software or \n" +
                    "protocols, and otherwise engage in activities that we deem damaging to our service;\n" +
                    "• www.TrackCarOnline.com accounts, object licenses, server licenses are non-transferable and \n" +
                    "funds are not refundable.\n" +
                    "Privacy policy\n" +
                    "We take your privacy very seriously. Our Privacy policy is available here. By accepting the \n" +
                    "Terms of service, you agree to be bound by our Privacy policy.\n" +
                    "Indemnification\n" +
                    "You agree to indemnify and hold www.TrackCarOnline.com, its affiliates, officers and \n" +
                    "employees, harmless, including costs and attorney’s fees, from any claim or demand \n" +
                    "made by any third party due to your use of the service, your violation of the Terms of \n" +
                    "service, and/or your violation of any other right of any person or entity.\n" +
                    "Changes\n" +
                    "www.TrackCarOnline.com may change this agreement at any time for any reason by posting \n" +
                    'the modified agreement on website',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black
                  ),
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                ),

    );
  }
}










