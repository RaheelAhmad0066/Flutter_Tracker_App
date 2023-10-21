

import 'package:flutter/material.dart';
import 'package:maktrogps/config/apps/food_delivery/global_style.dart';
import 'package:maktrogps/config/static.dart';


class privacypolicy extends StatefulWidget {
  @override
  _privacypolicyState createState() => _privacypolicyState();
}

class _privacypolicyState extends State<privacypolicy> {
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
        title: Text('Privacy Policy', style: GlobalStyle.appBarTitle),
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
                Text('Privacy policy\n' +
                "This is a legal agreement between Customer and www.TrackCarOnline.com for the service use. \n" +
                    "By using our service, you agree to be bound by the terms and conditions of this \n" +
                    "agreement.\n" +
                    "If Customer does not agree to this agreement, Customer may not use our service.\n" +
                    "Overview\n" +
                    "We are committed to ensuring that your privacy is protected. We will only use the \n" +
                    "information that we collect about you lawfully in accordance with The EU's General Data \n" +
                    "Protection Regulation (GDPR).\n" +
                    "All data that we collect is used solely for providing a service to you. In particular:\n" +
                    "• We do not sell, share or otherwise disclose your data to anyone;\n" +
                    "• We do not mine your data for patterns;\n" +
                    "• We do not use your data to target ads;\n" +
                    "• We do not access your location data without your permission.\n" +
                    "Information that we collect\n" +
                    "We collect the bare minimum of information required for GPS tracking:\n" +
                    "• Full name and address - used for billing and invoicing;\n" +
                    "• Username and password - used to authenticate users;\n" +
                    "• E-mail - used for notifying our users of changes in service and for resetting forgotten \n" +
                    "passwords;\n" +
                    "• GPS location data - sent by your GPS device or mobile device when you run our \n" +
                    "tracking software. We transmit the following data: your GPS coordinates, speed, altitude, \n" +
                    "angle, current time and various sensor parameters. We do not transmit your phone \n" +
                    "number, contact lists or any other data stored on your mobile device;\n" +
                    "• HTTP requests - as most web services, we maintain logs of all incoming HTTP requests. \n" +
                    "Web logs contain IP addresses, requested URLs, referral URLs, and other similar attributes \n" +
                    "provided by your browser.\n" +
                    "Cookies\n" +
                    "Cookies are small files that are temporarily stored by your web browser. They are used \n" +
                    "solely for session management (remembering who you are once you login) and for \n" +
                    "storing preferences. We use traffic log cookies to identify which pages are being used.\n" +
                    "This helps us analyse data about web page traffic and improve our website in order to \n" +
                    "tailor it to Customer needs. We only use this information for statistical analysis purposes.\n" +
                    "Most of our cookies expire as soon as you log out or close the browser window.\n" +
                    "We recommend that you enable cookie support in your browser as many features of our \n" +
                    "website will not work otherwise.\n" +
                    "Security\n" +
                    "Your data is stored on secure servers. We have taken further steps to prevent \n" +
                    "unauthorized access to your data, including running firewall software and keeping our \n" +
                    "servers up-to-date with security patches. That said, we cannot guarantee nondisclosure \n" +
                    "of personal information due to factors beyond our control. If you suspect that your \n" +
                    "account has been compromised, please contact us as soon as possible.\n" +
                    "Connections are secured by Secure Sockets Layer (SSL). SSL is a standard security \n" +
                    "technology for establishing an encrypted link between a server and a client. SSL allows \n" +
                    "sensitive information such as credit card numbers, social security numbers, and login \n" +
                    "credentials to be transmitted securely. Normally, data sent between browsers and web \n" +
                    "servers is sent in plain text - leaving you vulnerable to eavesdropping. If an attacker is \n" +
                    "able to intercept all data being sent between a browser and a web server, they can see \n" +
                    "and use that information.\n" +
                    "Account creation, login and recovery system was developed using latest authentication \n" +
                    "standards to prevent any hacking possibility.\n" +
                    "During account creation, collected data is encrypted using one-way encryption algorithm \n" +
                    "and being saved to database. One-way encryption makes impossible to decrypt data. \n" +
                    "Data can be verified only using comparison method performed by genuine author.\n" +
                    "Rights of access, correction and objection\n" +
                    "You may request access to the personal data that is collected and to correct data that \n" +
                    "may be inaccurate. In some cases, on your request, account and other collected data can \n" +
                    "be completely removed. www.TrackCarOnline.com reserves the right to request proper \n" +
                    "identification of you prior to providing personal data or rectifying any inaccurate data.\n" +
                    "Data retention\n" +
                    "We will retain your information for as long as your account is active or as needed to \n" +
                    "provide you services. Once it is no longer needed it is deleted automatically.\n" +
                    "More information\n" +
                    "If you have any questions or concerns regarding the data we collect or how we use it, \n" +
                    "please feel free to contact by e-mail at info@TrackCarOnline.com.\n" +
                    "Changes\n" +
                    "www.TrackCarOnline.com may change this agreement at any time for any reason by posting \n" +
                    'the modified agreement on website.',
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










