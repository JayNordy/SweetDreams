import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/create_log.dart';
import 'package:units/database.dart';

class SleepLogPage extends StatefulWidget {

  SleepLogPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SleepLogPageState createState() => _SleepLogPageState();


}

class _SleepLogPageState extends State<SleepLogPage> {
  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  Widget sleepLogToWidget() {
    List<Widget> content = [];
    for (int i = 0; i < widget.database.getData().length; i++) {
      content.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flex(direction: Axis.horizontal,
              children: [widget.database.getData(index: i)[0].toWidget()]),
          IconButton(
              onPressed: () => editEvent(i), icon: const Icon(Icons.edit)),
        ],
      ),);
    }
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: content,
        ),
      ],
    );
  }

  void editEvent(int index)
  {
    print("MESSAGE" + index.toString());
  }

  @override
  Widget build(BuildContext context) {

    _selectDate(BuildContext context) async{
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Log'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text("Sleep Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent
              ),
              child: Text('Create New Log'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLogPage(database: widget.database)));
                },
            ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent
          ),
          child: Text('Find a Log'),
          onPressed: () => _selectDate(context)
      ),
            sleepLogToWidget()
          ],
        ),
      ),
    );
  }
}