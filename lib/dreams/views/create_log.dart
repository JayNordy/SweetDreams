import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:units/database.dart';

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

  var _rating = 0.0;
  DateTime selectedDate = DateTime.now();



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
        title: Text("New Log"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("New Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent
                  ),
                  child: Text('Select a Date'),
                  onPressed: () => _selectDate(context)
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: RatingBar(
                  minRating: 0,
                  maxRating: 5,
                  initialRating: 3,
                  allowHalfRating: false,
                  onRatingUpdate: (rating)  {
                    setState(() {
                      _rating = rating;
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
                )
              ),
            ],
          )
      ),
    );
  }
}