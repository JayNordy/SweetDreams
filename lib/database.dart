import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

class SleepEvent {
  int eventNumber = 0;
  DateTime sleep = DateTime.now();
  DateTime wake = DateTime.now();
  int quality = 0; // 1-5 scale
  String dream = ""; // "" if none given

  SleepEvent(int num, DateTime start, {DateTime? end, int? quality = 0, String? dream = ""})
  {
    eventNumber = num;
    sleep = start;
    if(end == null)
    {
      wake = DateTime.now();
    }
    else
    {
      wake = end;
    }
    quality = quality;
    dream = dream;
  }

  void set({int? num, DateTime? start, DateTime? end, int? quality, String? dream}) // dynamic setter.
  {
    if(num != null)
      {
        eventNumber = num;
      }
    if(start != null)
      {
        sleep = start;
      }
    if(end != null)
      {
        wake = end;
      }
    if((quality != null)&&(quality >= 1)&&(quality <= 5))
      {
        quality = quality;
      }
    if(dream != null)
      {
        dream = dream;
      }
  }

  @override
  String toString() { //Produces string representation of object
    String composite = "";
    composite += "--------------------------\n";
    composite += "Sleep: " + eventNumber.toString() + "\n";
    composite += "Went to sleep at: " + sleep.toString() + "\n";
    composite += "Woke up at: " + wake.toString() + "\n";

    composite += "Your rating of the quality of your Sleep: ";
    if(quality == 0)
      {
        composite += "Not Given\n";
      }
    else
      {
        composite += quality.toString() + "\n";
      }

    composite += "---------------------------\n";
    composite += "Dreams you had that night:\n";
    if(dream == "")
      {
      composite += "\tNone.\n";
      }
    else
      {
        composite += "\t" + dream + "\n";
      }

    composite += "=======================\n";

    return composite;
  }

  Widget toWidget()
  {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Day " + eventNumber.toString(), overflow: TextOverflow.visible),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(DateFormat.Hms().format(sleep) + "\t",overflow: TextOverflow.visible),
              Text("\t" + DateFormat.Hms().format(wake),overflow: TextOverflow.visible),
            ],
          ),
          Text("Quality: " + quality.toString(),overflow: TextOverflow.visible),
          Text("Dream Log:\n\t" + dream.toString(),overflow: TextOverflow.visible),
        ]
    ));
  }
} //END OF CLASS SleepEvent

class SleepData {

  List<SleepEvent> database = []; // List containing all data via SleepEvents

  SleepData()
  {
    database = [];
  }

  void addEvent(DateTime sleep, {DateTime? wake = null, int? quality = 0, String? dream = ""}) //adds a sleep event at the last index of the database. A DateTime for the start of the sleep is required but other parameters are optional and will default.
  {
    database.add(SleepEvent(database.length, sleep, end: wake, quality: quality, dream: dream));
  }

  SleepEvent? delEvent(int index) //Deletes the event at the specified index, returning it. Returns null if no such event exists
  {
    if ((database.length - 1 < index) && (index >= 0))
    {
      return null;
    }

    SleepEvent holder = database[index];
    database.removeAt(index);
    return holder;
  }

  int editEvent(int index, {DateTime? start, DateTime? end, int? quality, String? dream}) // 0 - Failure, 1 - No change, 2 - Change(s) made
  {
    if ((database.length - 1 < index) && (index >= 0)) {
      return 0; //Index is not valid
    }

    int changes = 0;

    if (start != null) {
      database[index].set(start: start);
      changes++;
    }
    if (end != null) {
      database[index].set(end: end);
      changes++;
    }
    if (quality != null) {
      database[index].set(quality: quality);
      changes++;
    }
    if (dream != null) {
      database[index].set(dream: dream);
      changes++;
    }

    if (changes == 0) {
      return 1;
    }

    return 2;
  }

  List<SleepEvent> getData({int? index}) // Returns the full database list UNLESS an index is provided as an integer, in which case a list containing just that entry is returned
  {
    if(index == null)
      {
        return database;
      }
    else
      {
        List<SleepEvent> tmp = [];
        tmp.add(database[index]);
        return tmp;
      }
  }
} // END OF CLASS SleepData

void main() // test func
{
  SleepData gen = SleepData();
  gen.addEvent(DateTime.now());
  print(gen.getData()[0].toString());
}