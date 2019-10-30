import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/AnnouncementsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/BookmarksDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/SpeedSessionDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

class PrivacyPolicyDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _PrivacyPolicyDashboardState createState() => _PrivacyPolicyDashboardState();
}

class _PrivacyPolicyDashboardState extends State<PrivacyPolicyDashboard> {

  int _selectedDrawerIndex = 1;

  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    //we close the drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width / 12,
              height: MediaQuery.of(context).size.height / 12,
              child: d.image,
            ),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            // onTap: () => _onSelectItem(i),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.drawerItems[i].title == 'Dashboard') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              /*if (widget.drawerItems[i].title == 'Privacy Policy') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyDashboard()),
                      (Route<dynamic> route) => false,
                );
              }*/
              if (widget.drawerItems[i].title == 'Terms & Conditions') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TermsConditionsDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Logout') {

                Utils.setPreference(Constants.LOGIN_CHECK, Constants.LOGGED_OUT);
                Utils.clearPreference();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          )
      );
    }
    //Let's scaffold our homepage
    return new Scaffold(
      appBar: new AppBar(
        // We will dynamically display title of selected page
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      // Let's register our Drawer to the Scaffold
      drawer: SafeArea(
        child: new Drawer(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                 /* Container(
                    color: Utils.hexToColor("#F24A1C"),
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Menu', style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ))
                      ),
                    ),
                  ),*/
                  new Column(children: drawerOptions)
                ],
              ),
            ),
          )
        ),
      ),
      body: PrivacyPolicyScreen(),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}


class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Html(
              data: """
                <p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>PRIVACY NOTICE</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>1. Status, application, and amendment</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">1.1 This Privacy notice forms part of the legal notice and disclaimer of this portal/website and is incorporated into the legal notice and disclaimer.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">1.2 This privacy notice applies to the Department of Science and Innovation and any legal entity that controls, verifies or makes use of information that may be collected via this portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>2. Collection of personal data</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">2.1 Where personal information (such as, but not limited to, the user’s name, telephone number and email address) is submitted to this portal/website by the user, for example through sending an email, subscribing to a service or filling in the required fields, the following principles are observed in the handling of that information:</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(a) This portal/website collects, processes and stores only such personal information regarding users as is necessary to provide the services offered. The specific purpose for which information is collected is apparent from the context in which it is requested.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(b) This portal/website will not use the personal information submitted for any other purpose other than the efficient provision of services, including this portal/website and services offered through it by third parties, without obtaining the prior written approval of the user or unless required to do so by law.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(c) This portal/website will keep records of all personal information collected and the specific purpose for which it was collected for a period of at least one year from the date on which it was last used.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(d) This portal/website will not disclose any personal information regarding a user to any third party unless the prior written agreement of the user is obtained or the portal/website is required or permitted to do so by law.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(e) If any information is released with the user’s consent, this portal/website will retain a record of the information released, the third party to which it was released, the reason for the release and the date of release, for a period of one year.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">(f) This portal/website will destroy or delete any personal information under its control that has become obsolete.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">2.2 Note that, as permitted by the Electronic Communications and Transactions Act, 2002 (Act No. 25 of 2002) this website may use personal information collected to compile profiles for statistical purposes. It will not be possible to link any information contained in the profiles or statistics to any specific user.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>3. Collection of anonymous data</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.1 Data messages, including email messages, sent by users to the portal/website owner: In order to provide the best possible and most relevant service, this portal/website may use standard technology such as cookies or web beacons to collect information about the use of this site. This technology is not able to identify individual users but simply allows this portal/website to collect statistics.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.2 This portal/website uses session- or temporary cookies. A cookie is a small file that is placed on the user’s hard drive in order to keep a record of a user’s interaction with this website. Session cookies are deleted once the user closes his or her browser.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.3 Cookies from this portal/website allow the website owner to tailor services to the user’s displayed preferences.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.4 Cookies by themselves cannot be used to personally identify users but will be used to compile anonymised statistics relating to the use of services offered or to provide feedback on the performance of this portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.5 If a user does not wish cookies to be employed to customise his or her interaction with this portal/website, it is possible to alter the manner in which their browser handles cookies. Please note that, if this is done, certain services on this portal/website may not be available.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>4. Access to personal data</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">4.1 If personal information has been submitted to this portal/website, users who wish to review their personal information may do so by logging into their account and choosing the “edit my profile” option. Users will then be able to access their user profile, correct and update their details, or e-mail the Curator to unsubscribe at any time.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">4.2 Users who experience any issues accessing their profiles, or who would like to request a copy of their personal information, should contact the Webmaster using the feedback link. In all cases, the Department of Science and Innovation will treat requests to access information in accordance with applicable legal requirements.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>5. Links to other websites</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">The Department of Science and Innovation has no control over and accepts no responsibility for the privacy practices of any third party sites to which hyperlinks may have been provided and we strongly recommend that you review the privacy policy of any site you visit before using it further.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>6. No agreement</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">Nothing contained herein creates or is intended to create a contract or agreement between the Department of Science and Innovation and any user visiting the portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>7. Queries</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">7.1 User queries regarding this Privacy notice can be directed to the Innovation Bridge Portal management through the contact facility.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>8. Additional Information: How do we collect personal information?</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">With regard to the personal information we collect, we make use of a number of technologies that collect personal information automatically:</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>Cookies</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">Cookies are small files that are saved onto the user’s computer which track, save and store information about how the user uses this portal/website. In some instances, these cookies are needed for the portal/website to function – the user can disable them in their browser but this may interfere with the proper functioning of this portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>Google Analytics</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">This is tracking software from Google which is used to monitor how users interact with the website in order to improve its functionality and content.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>Web server Software</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">Web server software delivers web-pages to the user’s browser. The web-server software will automatically collect the user’s IP address whenever the user connects to the portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>YouTube</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">This is software used to display videos. We do not collect personal information from the user by placing these videos on our site or through the user viewing them, but Google Inc. (which owns YouTube) collects personal information when videos are placed on webpages.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>AddToAny</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">This is software that is used to place social media buttons on the website which allows users to share content on the website through social media. We do not collect personal information by placing these buttons on our site, but the AddToAny Company does.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>Social Media Platforms And External Links</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">This portal/website may make use of social media platforms such as Facebook or LinkedIn. Whenever users make use of any such platforms on this portal/website, please note that any personal information users share on these platforms is subject to social media platforms' privacy policies and not the Innovation Bridge Portal's. This portal/website may also contain links to external websites. Whenever users click on a link and are taken to an external website, note that use of those websites is governed by their privacy policies and not that of the Innovation Bridge Portal.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>9. Securing Users’ Information</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">We take care to protect users’ personal information using information security safeguards, however, users should be aware that no safeguards are 100% effective all of the time and it is, therefore, possible that their personal information may be accessed by unauthorised or unknown persons should these safeguards be defeated or fail.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>10. Changes to this notice</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">This privacy notice may be amended from time to time. All amendments shall be posted on this portal/website. Unless stated otherwise, the current version will replace all previous versions of this notice. It is the user’s responsibility to check for changes each time they visit the portal/website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">&nbsp;</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">&nbsp;</p>
                """,
            )
            /*Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: TextStyle(
                    fontSize: 14
                )),*/
          )
      ),
    );
  }
}
