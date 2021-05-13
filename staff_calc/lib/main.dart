import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_calc/Logic/Models/Ward.dart';
import 'package:staff_calc/Logic/data.dart' as api;
import 'package:staff_calc/components/IconNumberInput.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Staff Allocation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Ward> list;
  Ward selectedItem;

  //region Globals
  //var colorRed =
  //endregion

  //region [Input]
  int beds = 0;
  int blockedBeds = 0;
  int patients = 0;
  int ratio = 0;
  int nursesOnShift = 0;
  //endregion

  //region [Output]
  int totalNursesNeeded;
  int allowedNurses;
  int admitIOnCurrent;
  int admitInclAcuity;
  int availableBeds;
  int availableNurses;
  //endregion

  @override
  void initState() {
    super.initState();
    list = list == null ? api.Data.getWards() : list;
    selectedItem = selectedItem == null ? (list.length == 0 ? new Ward() : list[0]) : selectedItem;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: Icon(Icons.supervised_user_circle_outlined),
        backgroundColor: Colors.indigo[900],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.00, 15.00, 15.00, 0.00),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                width: 2,
                                color: Colors.red,
                              )
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: DropdownButton<Ward>(
                                value: selectedItem,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: Colors.red,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                underline: null,
                                onChanged: (Ward newValue) {
                                  setState(() {
                                    selectedItem = newValue;
                                  });
                                },
                                items: list
                                    .map<DropdownMenuItem<Ward>>((Ward value) {
                                  return DropdownMenuItem<Ward>(
                                    value: value,
                                    child: Center(
                                        child: Text(
                                          "${value.name}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 24,
                                          ),
                                        )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.00, 0.00, 7.50, 0.00),
                          child: IconNumberInput(
                            labelText: "Patients",
                            icon: Icon(Icons.supervised_user_circle_outlined),
                            onChange: (value) => {
                              patients = value.isNotEmpty ? int.parse(value) : 0
                            },
                          ),
                        )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(7.50, 0.00, 0.00, 0.00),
                          child: IconNumberInput(
                            labelText: "Blocked Beds",
                            icon: Icon(Icons.single_bed_rounded),
                            onChange: (value) => {
                              blockedBeds = value.isNotEmpty ? int.parse(value) : 0
                            },
                          ),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.00, 0.00, 7.50, 0.00),
                          child: IconNumberInput(
                            labelText: "One to One",
                            icon: Icon(Icons.account_tree_outlined),
                            onChange: (String value) => {
                              ratio = value.isNotEmpty ? int.parse(value) : 0
                            },
                          ),
                        )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(7.50, 0.00, 0.00, 0.00),
                          child: IconNumberInput(
                            labelText: "Staff on Shift",
                            icon: Icon(Icons.recent_actors_outlined),
                            onChange: (value) => {
                              nursesOnShift = value.isNotEmpty ? int.parse(value) : 0
                            },
                          ),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.00, 20, 0.00, 20),
                        child: getResultCard(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 7.5, 0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextButton(
                                  onPressed: calculateStaff,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Center(child: Text("Reset")))
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[300]),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextButton(
                                  onPressed: calculateStaff,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Center(child: Text("Submit"),))
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[900]),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateStaff() {
    setState(() {
      totalNursesNeeded = ratio + (patients > 10 ? 1 : 0) + ((patients - ratio)/2).ceil();
      allowedNurses = ((patients * selectedItem.labourHours)/24).ceil();
      admitIOnCurrent = (patients - ratio) % 2 > 0 ? 1 : 0;
      admitInclAcuity = ((allowedNurses - totalNursesNeeded) * 2) + admitIOnCurrent;
      availableBeds = beds - blockedBeds - patients;
      //weird shift
    });
  }

  void resetVariables(){
    // setState(() {
    //   beds = 0;
    //   blockedBeds = 0;
    //   patients = 0;
    //   ratio = 0;
    //   nursesOnShift = 0;
    //   totalNursesNeeded = 0;
    //   allowedNurses = 0;
    //   admitIOnCurrent = 0;
    //   admitInclAcuity = 0;
    //   availableBeds = 0;
    // });
  }

  Widget getResultCard(){
    Widget resultCard;

    if(totalNursesNeeded != null && allowedNurses != null && admitIOnCurrent != null && admitInclAcuity != null && availableBeds != null){
      resultCard = Card(
        elevation: 2,
        child: Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text("$totalNursesNeeded"),
                      Text("$allowedNurses"),
                      Text("$admitIOnCurrent"),
                      Text("$admitInclAcuity"),
                      Text("$availableBeds"),
                    ],
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Container(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      resultCard = null;
    }

    return resultCard;
  }
}
