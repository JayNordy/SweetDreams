import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditLogPage extends StatefulWidget {

  EditLogPage({Key? key, required this.database, required this.log}) : super (key: key);
  SleepData database;
  SleepEvent log;

  @override
  _EditLogPageState createState() => _EditLogPageState();
}

class _EditLogPageState extends State<EditLogPage>  {
  @override
  void initState() {
    super.initState();
  }

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;

  double rating = 0;
  var myController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeRange selectedTime = TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());

  String labelSelectDate = "Select a Date";
  String labelSelectTimeRange = "Enter Your Sleep Time";
  String labelError = "";

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
      labelSelectDate = selectedDate.month.toString() + "/" + selectedDate.day.toString() + "/" + selectedDate.year.toString();
    }

    _selectTimeRange(BuildContext context) async{
      final TimeRange? picked = await showTimeRangePicker(
          context: context
      );
      if (picked != null)
      {
        setState(() {
          selectedTime = picked;
        });
      }
      labelSelectTimeRange = selectedTime.startTime.hour.toString() + ":" + selectedTime.startTime.minute.toString() + " - "
          + selectedTime.endTime.hour.toString() + ":" + selectedTime.endTime.minute.toString();
    }

    _editLog(DateTime selectedDate, TimeRange selectedTime, double rating, var myController) async  {
      if ((check1 != false) && (check2 != false) && (check3 != false) && (check4 != false)) {
        DateTime sleep = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.startTime.hour, selectedTime.startTime.minute);
        DateTime wake = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.endTime.hour, selectedTime.endTime.minute);
        widget.database.editEvent(widget.log.eventNumber, Start: sleep,
            End: wake,
            Quality: rating.toInt(),
            Dream: myController.text);
        Navigator.pop(context);
      }
      else {
        setState(() {
          labelError = "Error: Not all Entries are Filled";
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Log"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("Edit Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text(labelSelectDate),
                    onPressed: () {
                      _selectDate(context);
                      check1 = true;
                    }
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text(labelSelectTimeRange),
                    onPressed: () {
                      _selectTimeRange(context);
                      check2 = true;
                    }
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: RatingBar(
                  minRating: 0,
                  maxRating: 5,
                  initialRating: 3,
                  allowHalfRating: false,
                  onRatingUpdate: (rate)  {
                    setState(() {
                      rating = rate;
                      check3 = true;
                    });
                  },
                  ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      half: Image.asset("star_half.png", color: Colors.yellow),
                      empty: Icon(
                        Icons.star,
                        color: Colors.grey,
                      )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Write about your dreams/nightmares'
                    ),
                    controller: myController,
                    onTap: () {check4 = true;},
                  )
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text('Done'),
                    onPressed: () => _editLog(selectedDate, selectedTime, rating, myController)
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text('Delete Log'),
                    onPressed: () {
                      widget.database.delEvent(widget.log.eventNumber);
                      Navigator.pop(context);
                    }
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text(labelError, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                    textScaleFactor: 2,
                    textAlign: TextAlign.center,)
              ),
            ],
          )
      ),
    );
  }
}