import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CreateLogPage extends StatefulWidget {

  CreateLogPage({Key? key, required this.database}) : super (key: key);
  SleepData database;
  @override
  _CreateLogPageState createState() => _CreateLogPageState();
}

class _CreateLogPageState extends State<CreateLogPage>  {
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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                onSurface: Colors.deepPurple.shade300,
              ),
              dialogBackgroundColor: Colors.grey.shade900,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.deepPurple, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
      labelSelectDate = selectedDate.month.toString() + "/" + selectedDate.day.toString() + "/" + selectedDate.year.toString();
    }

    _selectTimeRange(BuildContext context) async{
      final TimeRange? picked = await showTimeRangePicker(
          context: context,
          strokeColor: Colors.deepPurple,
          handlerColor: Colors.deepPurple,
          selectedColor: Colors.deepPurple.shade200,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepPurple,
              ),
              dialogBackgroundColor: Colors.grey.shade900,
              primaryColor: Colors.deepPurple,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.deepPurple, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null)
      {
        setState(() {
          selectedTime = picked;
        });
      }
      String temp1 = "";
      String temp2 = "";
      String temp3 = "";
      String temp4 = "";
      if(selectedTime.startTime.period == DayPeriod.am) temp1 = " am";
      if(selectedTime.startTime.period == DayPeriod.pm) temp1 = " pm";
      temp2 = selectedTime.startTime.hourOfPeriod.toString();
      if(selectedTime.endTime.period == DayPeriod.am) temp3 = " am";
      if(selectedTime.endTime.period == DayPeriod.pm) temp3 = " pm";
      temp4 = selectedTime.endTime.hourOfPeriod.toString();
      labelSelectTimeRange = temp2 + ":" + selectedTime.startTime.minute.toString() + temp1 + " - " + temp4 + ":" + selectedTime.endTime.minute.toString() + temp3;
    }

    _createLog(DateTime selectedDate, TimeRange selectedTime, double rating, var myController) async  {
      if ((check1 != false) && (check2 != false) && (check3 != false) && (check4 != false))  {
        DateTime sleep = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.startTime.hour, selectedTime.startTime.minute);
        DateTime wake = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.endTime.hour, selectedTime.endTime.minute);
        widget.database.addEvent(sleep, wake: wake, quality: rating.toInt(), dream: myController.text);
        widget.database.save();
        Navigator.pop(context);
      }
      else  {
        setState(() {
          labelError = "Error: Not all Entries are Filled";
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Log"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("New Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple), textScaleFactor: 3,)
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
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
                        primary: Colors.deepPurple
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
                        color: Colors.deepPurple,
                      ),
                      half: Image.asset("star_half.png", color: Colors.deepPurple),
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
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                        border: OutlineInputBorder(),
                        labelText: 'Write about your dreams/nightmares',
                        labelStyle: new TextStyle(color: Colors.deepPurple)
                    ),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: myController,
                    onTap: () {check4 = true;},
                  )
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text('Done'),
                    onPressed: () => _createLog(selectedDate, selectedTime, rating, myController)
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