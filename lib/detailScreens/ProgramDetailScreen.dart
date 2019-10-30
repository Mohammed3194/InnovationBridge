import 'package:flutter/material.dart';
import 'package:innovation_bridge/detailScreens/ProgramSessionScreen.dart';
import 'package:innovation_bridge/entities/ProgramID.dart';

class ProgramDetailScreen extends StatefulWidget {

  ProgramID detail;
  ProgramDetailScreen({@required this.detail});

  @override
  _ProgramDetailScreenState createState() => _ProgramDetailScreenState(detail);
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {

  ProgramID detail;
  _ProgramDetailScreenState(this.detail);

  @override
  Widget build(BuildContext context) {
    Data programData = detail.data;
    String location = '';
    if(programData.location.length >0){
      for (int i=0; i<programData.location.length; i++){
        location = location +" "+ programData.location[i];
      }
    }
    else{
      location = 'Location';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Program Activity'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(programData.title, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )),
                Padding(padding: EdgeInsets.only(top: 4)),
                Text(location, style: TextStyle(
                    fontSize: 12,
                  color: Colors.blue
                )),
                Text(programData.startTime + ' - ' + programData.endTime, style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue
                )),
                Padding(padding: EdgeInsets.only(top: 6)),
                Text(programData.details != null ? programData.details : "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),),

                Visibility(
                  visible: programData.details != null ? true : false,
                  child: Padding(padding: EdgeInsets.only(top: 20)),
                ),
                Column(
                  children: creatPresenters(programData.presenters)
                ),

                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  child: GridView.count(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 3.5),
                      children: createGridItems(programData.parallelActivities)),
                )

              ],
            ),
          )
        ),
      ),
    );
  }

  List<Widget> creatPresenters(List<Presenters> presenters){
    List<Widget> listPresenters = new List<Widget>();

    if (presenters != null && presenters.length > 0){
      for(var presenter in presenters){
        listPresenters.add(
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                  border: Border.all(width: 1,
                      color: Colors.grey[600]
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ), //             <--- BoxDecoration here
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Text(presenter.name != null ? presenter.name : "", style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold
                                ))
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(presenter.startTime + " - " + presenter.endTime, style: TextStyle(
                                    fontSize: 11.5,
                                  )),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(presenter.description != null ? presenter.description : "", style: TextStyle(
                              fontSize: 12,
                            )),
                          )
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      }
    }

    return listPresenters;
  }

  List<Widget> createGridItems(List<ParallelActivities> parallelActivities){
    List<Widget> listGridTiles = new List<Widget>();

    for(var pActivity in parallelActivities){
      listGridTiles.add(
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProgramSessionScreen(detail: pActivity)
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: pActivity.bookmarked ? Colors.green : Colors.grey,
                border: Border.all(
                    width: 0.9,
                    color: pActivity.bookmarked ? Colors.green : Colors.grey
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 5, 0, 0),
                    // Session Title
                    child: Text(pActivity.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                    // time
                    child:  Text(pActivity.startTime + ' - ' +pActivity.endTime,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                    child: Text(pActivity.location,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9
                        )),
                  ),
                ],
              ),
            ),
          )
      );
    }

    return listGridTiles;
  }
}
