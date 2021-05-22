import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'dart:async';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}



class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [
    WorldTime(location: 'New York', flag: 'usa.png', url: 'America/New_York'),
    WorldTime(location: 'London', flag: 'uk.png', url: 'Europe/London'),
    WorldTime(location: 'Seoul', flag: 'south_korea.png', url: 'Asia/Seoul'),
    WorldTime(location: 'Nairobi', flag: 'kenya.png', url: 'Africa/Nairobi'),
    WorldTime(location: 'Athens', flag: 'greece.png', url: 'Europe/Athens'),
    WorldTime(location: 'Berlin', flag: 'germany.png', url: 'Europe/Berlin'),
    WorldTime(location: 'Hà Nam', flag: 'vietnam.png', url: 'Asia/Bangkok'),
  ];

  void updateTime (index) async {
    WorldTime instance = locations[index];
    await instance.getTime();
    Navigator.pop(context, {
      'location': instance.location,
      'flag':  instance.flag,
      'time': instance.time,
      'isDaytime' : instance.isDaytime,
    }
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Choose location'),
        centerTitle: true,

      ),
      body: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    updateTime(index);
                  },
                  title: Text(locations[index].location),
                  leading:
                      CircleAvatar(
                        backgroundImage: AssetImage("images/${locations[index].flag}"),
                      ),
                ),
              ),
            );
          }),
    );
  }
}
