import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}




class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    WorldTime instance = WorldTime(location: 'Hà Nam', flag: 'germany.png', url: 'Asia/Bangkok');
    await instance.getTime();
  Navigator.pushReplacementNamed(context, '/home', arguments: {
    'location': instance.location,
    'flag':  instance.flag,
    'time': instance.time,
    'isDaytime' : instance.isDaytime,
  });

  }
  @override
void initState(){
    super.initState();
    setupWorldTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitCubeGrid	(
              color: Colors.lightBlueAccent,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              "Đang tải ... ",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 28.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
