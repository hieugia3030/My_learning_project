import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'dart:async';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

int SecondPassed = 0;   // đếm thời gian đã trôi qua khi từ Home Navigate sang Timer
Timer timer;  // kiểm soát bộ đếm của mik ;) ví dụ: timer.cancel() ở bất  cứ đâu ;)
bool isChangedLocation = false;

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
      'timePassed': 0,
    }
    );
}
  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer)  {
      SecondPassed++;
      print(SecondPassed);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Choose location'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: (){
            Navigator.pop(context,
                {
              'timePassed': SecondPassed,

            }
            );
            timer.cancel();
            SecondPassed = 0;
          },
        ),
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
