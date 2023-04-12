import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetaudioplayer.dart';
import 'dart:async';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  List<WidgetAudioPlayer> players = [];
  List<Widget> displayables = [];


  void update()
  {
    setState(() {
      List<Widget> holder = [];
      for (int i = 0; i < players.length; i++) {
        if(players[i].needsUpdating)
        {
          holder.add(players[i].toWidget());
          players[i].needsUpdating = false;
        }
        else
        {
          holder.add(displayables[i]);
        }
      }
      displayables = holder;
    });
  }

  @override
  void initState() {
    players.add(WidgetAudioPlayer("Summer Night", "Summer_Night.mp3", Icon(Icons.wb_twighlight, color: Colors.white)));
    players.add(WidgetAudioPlayer("Rain", "Rain.mp3", Icon(Icons.wb_cloudy, color: Colors.white)));
    players.add(WidgetAudioPlayer("Wind", "Wind.mp3", Icon(Icons.wind_power, color: Colors.white)));
    players.add(WidgetAudioPlayer("Womb", "Womb.mp3", Icon(Icons.favorite, color: Colors.white)));
    players.add(WidgetAudioPlayer("Brook", "Brook.mp3", Icon(Icons.water, color: Colors.white)));
    players.add(WidgetAudioPlayer("Ocean", "Ocean.mp3", Icon(Icons.tsunami, color: Colors.white)));
    players.add(WidgetAudioPlayer("Bird", "Bird.mp3", Icon(Icons.notification_important, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Seagull", "Seagull.mp3", Icon(Icons.beach_access, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Bouy", "Bouy.mp3", Icon(Icons.directions_boat, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Thunder", "Thunder.mp3", Icon(Icons.bolt, color: Colors.grey)));

    update();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final periodicTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (timer) {
        update();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Sounds"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: GridView.count(
            crossAxisCount: 3,
            children: displayables,
          )
      ),
    );
  }
}