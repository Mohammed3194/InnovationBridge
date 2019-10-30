import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'package:innovation_bridge/utils/expandable.dart';

class TermsConditionsDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _TermsConditionsDashboardState createState() => _TermsConditionsDashboardState();
}

class _TermsConditionsDashboardState extends State<TermsConditionsDashboard> {

  int _selectedDrawerIndex = 2;

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
            onTap: (){
              Navigator.of(context).pop();
              if (widget.drawerItems[i].title == 'Dashboard') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Privacy Policy') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
             /* if (widget.drawerItems[i].title == 'Terms & Conditions') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TermsConditionsDashboard()),
                      (Route<dynamic> route) => false,
                );
              }*/
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
                  /*Container(
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
      body: TermsConditionsScreen(),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}

class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {

  String descText = "Description Line 1\nDescription Line 2\nDescription Line 3\nDescription Line 4\nDescription Line 5\nDescription Line 6\nDescription Line 7\nDescription Line 8";
  bool descTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        title: Text("DemoPage"),
      ),
      body: new Container(
        margin: EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(descText, maxLines: descTextShowFlag ? 8 : 2,textAlign: TextAlign.start),
            InkWell(
              onTap: (){ setState(() {
                descTextShowFlag = !descTextShowFlag;
              }); },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  descTextShowFlag ? Text("Show Less",style: TextStyle(color: Colors.blue)) :
                  Text("Show More",style: TextStyle(color: Colors.blue))
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
    return Container(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Html(
              data: """
                <p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>CONDITIONS OF USE OF THE IBP</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">Any person (user) accessing this website or related mobile application is subject to, and agrees to, the terms and conditions set out in this legal notice. If the user does not wish to be bound by these terms and conditions, the user may not access, display, use or download and/or otherwise copy or distribute content obtained from this website.</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>1 Use and Copyright</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">1.1 Use of this portal and any services, content or applications contained herein or offered hereon is at the sole risk of the user.
  <br>1.2 Users may view, copy, download to a local drive, print and distribute the content of this portal, or any part thereof for non-commercial, informational or reference purposes only.
  <br>&nbsp;1.2.1 Users may not cede, sub-license or otherwise transfer any rights they may have under these terms and conditions or which may otherwise have been obtained through the use of this portal.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>2 Disclaimers and Indemnities</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">2.1 The information on this portal is intended to provide general information on a particular subject or subjects and is not an exhaustive treatment of such subject(s).
  <br>2.2 It is the sole responsibility of the user to satisfy him or herself prior to accessing this portal that it will meet the user's individual requirements and be compatible with the user's hardware and/or software.
  <br>2.3 This entire portal, including text, images, links, downloads and coding, is provided "as is" and "as available". The Department of Science and Innovation, Republic of South Africa makes no representations or warranties, express or implied, including but not limited to warranties as to the correctness or suitability of either the website or the products, services or information contained in it.
  <br>2.4 The use of the content of this portal/website is at the user’s own risk.
  <br>2.4.1 The user assumes full responsibility and risk of loss resulting from the use of the content of this portal.
  <br>2.4.2 The Department of Science and Innovation, Republic of South Africa or any of the legal entities in respect of which information is contained on this portal, or employees of the Department of Science and Innovation, Republic of South Africa or such entity, will not be liable for any special, indirect, incidental, consequential, or punitive damages or any other damages whatsoever, whether in an action of contract, statute, delict (including, without limitation, negligence), or otherwise, relating to the use of this document or information.
  <br>&nbsp;2.4.3 Subject to sections 43(5) and 43(6) of the Electronic Communications and Transactions Act 25 of 2002 and to the fullest extent possible under law, the Department of Science and Innovation, Republic of South Africa shall not be liable for any damage, loss or liability of whatsoever nature arising from the use or inability to use, or reasonable reliance upon this portal or the services or content provided from and through this portal.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>3 Receipt and sending of data messages</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">3.1 Data messages, including e-mail messages, sent by users to the portal owner shall be deemed to be received only when acknowledged or responded to in writing.
  <br>3.2 Data messages sent by the portal owner to users shall be regarded as received when the complete data message enters an information system designated or used for that purpose by the recipient and is capable of being retrieved and processed by the recipient.
  <br>&nbsp;3.3 If a user does not receive a response within a reasonable period of time, the user should follow it up with the Innovation Bridge Portal Curator.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>4 Security</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">4.1 The Department of Science and Innovation, Republic of South Africa has in place reasonable commercial standards of technology and operational security to protect all information provided by users from loss, misuse, alteration or destruction.
  <br>4.2 All reasonable steps will be taken to secure a user's information. Authorised employees, who are responsible for the maintenance of any sensitive data submitted, are required to maintain the confidentiality of such data. The policy applies to all employees of the Department of Science and Innovation, Republic of South Africa or public bodies that may receive such information from the Department of Science and Innovation, Republic of South Africa.
  <br>4.3 It is expressly prohibited for any person, business, or entity to gain or attempt to gain unauthorised access to any page on this portal, or to deliver or attempt to deliver any unauthorised, damaging or malicious code to this portal.
  <br>&nbsp;4.3.1 If a person delivers or attempts to deliver any unauthorised, damaging or malicious code to this website or attempts to gain unauthorised access to any page on this website, a criminal charge will be laid against that person, and, if the Department of Science and Innovation, Republic of South Africa or any public body should suffer any damage or loss, civil damages will be claimed.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>5 Monitoring and interception of data messages</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">5.1 In order to provide a relevant and secure service, and when required to do so under law, the Department of Science and Innovation, Republic of South Africa may monitor and/or intercept electronic communications, such as e-mails, which are sent to and from this website.
  <br>&nbsp;5.2 To the full extent necessary under the law, the user hereby acknowledges that he or she is aware of such potential monitoring and/or interception and consents thereto.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>6 Confidentiality of data messages</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">6.1 The Department of Science and Innovation, Republic of South Africa prefers not to receive confidential or proprietary information from users through this portal.
  <br>6.2 Please note that any information or material sent to the Innovation Bridge Portal will be deemed not to be confidential.
  <br>6.3 The portal will not release users’ names or otherwise publicise the fact that materials or other information has been submitted to it unless:
  <br>6.3.1.1 prior permission is obtained to use the user’s name; or
  <br>6.3.1.2 the user has first been notified that the materials or other information submitted to a particular part of this site will be published or otherwise used in a manner that reflects the user’s name; or
  <br>&nbsp;6.3.1.3 where required to do so by law.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>7 Links to third party or external sites</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">7.1 The portal may provide links to other websites only as a convenience and the inclusion of any link does not imply the endorsement of such sites.
  <br>&nbsp;7.2 Linked websites or pages are not subject to the control of the portal.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>8 Intellectual property rights</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">8.1 All content, data and trademarks, including, but not limited to, software, technology, databases, know-how, text, graphics, icons, hyperlinks, private information, designs, programs, publications, products, processes, or ideas described in this website may be subject to other rights, including other intellectual property rights, which are the property of, or licensed to content sources on the portal.
  <br>8.2 Subject to the rights afforded to the user herein, all other rights to all intellectual property on this website is expressly reserved and by accessing data on this portal the user is not licensed or authorised.
  <br>&nbsp;8.3 Third party websites are welcome to link to the information that is hosted on these pages.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>9 Automated searching</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">9.1 Automated transactions and searches are subject to these terms and conditions.
  <br>9.2 The use of malicious search technology is prohibited.
  <br>9.3 The use of search technology in an unlawful manner or for the collecting or harvesting of data for commercial gain is prohibited.
  <br>&nbsp;9.4 Search technology which does not unduly retard the operation of this website is acceptable but the portal owner reserves the right to prohibit any specific entity from employing search technology on the portal.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>10 Applicable law</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">10.1 The user hereby agrees that the law applicable to these terms and conditions of use, their interpretation and any matter or litigation in connection therewith or arising from them will be the law of South Africa.
  <br>10.2 This portal is owned, hosted and maintained within the Republic of South Africa.
  <br>&nbsp;10.3 When using this site and agreeing to these Terms and Conditions such use and agreement is deemed to have taken place in Pretoria, South Africa.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>11 General provisions</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">11.1 In the event of any part of these Terms and Conditions being found to be partially or fully unenforceable, for whatever reason, this shall not affect the application or enforceability of the remainder of this Agreement.
  <br>11.2 These Terms and Conditions of Use contain the record of the entire agreement between the user and the portal owner.
  <br>&nbsp;11.3 Failure to enforce any provision of these Terms and Conditions shall not be deemed a waiver of such provision nor of the right to enforce such provision.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>12 Updating and maintenance of these Terms and Conditions of Use</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">12.1 The Department of Science and Innovation, Republic of South Africa reserves the right to modify, add to or remove portions or the whole of these Terms and Conditions of Use from time to time.
  <br>12.2 These Terms and Conditions of Use will take effect upon such being posted to this website.
  <br>12.3 It is the user’s obligation to periodically check these Terms and Conditions of Use on this website for updates.
  <br>&nbsp;12.4 The user’s continued use of this website following the posting of updates will be considered notice of the user’s acceptance to abide by and be bound by these Terms and Conditions of Use.
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;"><strong>13 Portal owner details</strong></p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">13.1 The full name and legal status of the portal owner is:
  <br>The Department of Science and Innovation, Republic of South Africa, a Department of the Government of the Republic of South Africa and as represented by its Director General and the Minister of Science and Technology.
  <br>13.2 The website address of this website is: 
  <a href="https://www.innovationbridge.info/" target="_blank">https://www.innovationbridge.info</a>
  <br>13.3 Postal address: Private Bag X894, PRETORIA, Gauteng, Republic of South Africa, 0001
  <br>&nbsp;13.4 Street address: DST Building (Building no. 53), (CSIR South Gate Entrance), Meiring Naudé Road, Brummeria, PRETORIA
</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">13.5 e-Mail contact: curator@innovationbridge.info</p>
<p style="margin-top:0in;margin-right:0in;margin-bottom:8.0pt;margin-left:0in;line-height:107%;font-size:13px;font-family:&quot;Arial&quot;,sans-serif;">&nbsp;</p>
                """,
            )
          )
      ),
    );
    /*return Scaffold(
      body: ListView(
        children: <Widget>[
          //Card1(),
          Card2(),
        ],
      ),
    );*/
  }
}

const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
          scrollOnExpand: false,
          scrollOnCollapse: true,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  /*SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),*/
                  ScrollOnExpand(
                    scrollOnExpand: false,
                    scrollOnCollapse: false,
                    child: ExpandableNotifier(
                      initialExpanded: true,
                      child: ExpandablePanel(
                        iconColor: Colors.blue,
                        tapHeaderToExpand: true,
                        tapBodyToCollapse: true,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        header: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("ExpandablePanel",
                              style: Theme.of(context).textTheme.body2,
                            )
                        ),
                        collapsed: Text(loremIpsum, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for(var i in Iterable.generate(5))
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(loremIpsum, softWrap: true, overflow: TextOverflow.fade,)
                              ),
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              crossFadePoint: 0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

class Card2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    buildImg(Color color, double height) {
      return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          )
      );
    }

    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ]
      );
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 150);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text("3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]
      );
    }

    buildExpanded2() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: buildImg(Colors.lightGreenAccent, 100)
              ),
              Expanded(
                  child: buildImg(Colors.orange, 100)
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: buildImg(Colors.lightBlue, 100)
              ),
              Expanded(
                  child: buildImg(Colors.cyan, 100)
              ),
            ],
          ),
        ],
      );
    }

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(loremIpsum, softWrap: true,),
          ],
        ),
      );
    }


    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ScrollOnExpand(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*Expandable(
                    collapsed: buildCollapsed1(),
                    expanded: buildExpanded1(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed2(),
                    expanded: buildExpanded2(),
                  ),*/
                  Expandable(
                    collapsed: buildCollapsed3(),
                    expanded: buildExpanded3(),
                  ),
                  Divider(height: 1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var controller = ExpandableController.of(context);
                          return FlatButton(
                            child: Text(controller.expanded ? "COLLAPSE": "EXPAND",
                              style: Theme.of(context).textTheme.button.copyWith(
                                  color: Colors.deepPurple
                              ),
                            ),
                            onPressed: () {
                              controller.toggle();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
