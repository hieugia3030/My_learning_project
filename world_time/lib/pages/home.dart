import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';

void main() => runApp(ChoosingHome());
class ChoosingHome extends StatefulWidget {
  const ChoosingHome({Key key}) : super(key: key);

  @override
  _ChoosingHomeState createState() => _ChoosingHomeState();
}

bool isNavigatedFromTimer = false; // kiểm tra xem có phải user đã navigate từ Timer sang ko?

class _ChoosingHomeState extends State<ChoosingHome> {
  int _currentIndex = 0;

  final tabs = [
    Home(),
    MyTimer(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      if(_currentIndex == 1 ) isNavigatedFromTimer = true;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'TIMER',
            backgroundColor: Colors.greenAccent,
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


int SecondPassed = 0;   // đếm thời gian đã trôi qua khi từ Home Navigate sang Timer
Timer timer;  // kiểm soát bộ đếm của mik ;) ví dụ: timer.cancel() ở bất  cứ đâu ;)

Map data = {};
String getSystemTime() {
  data['time'] = data['time'].add(Duration(seconds: 1));
  var timeConverter = new DateFormat.jms().format(data['time']);
  return timeConverter;
}



class _HomeState extends State<Home> {

  @override
  void initState(){
    super.initState();
    if (isNavigatedFromTimer == true )  timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    data['time'] = data['time'].add(Duration(seconds: SecondPassed + 2  )); // số 2 ở đây là để chình lại thời gian cho đúng thui vì đồng hồ bị sai mất 2 giây
    SecondPassed = 0;
    Color bgColor = data['isDaytime'] ? Colors.blue : Colors.blue[900];
    String bgImage = data['isDaytime'] ? 'day.png' : 'night.png';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          width: 360.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['location'],
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 30.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20.0),
                MyDigitalClock(),
                SizedBox(height: 20.0),
                TextButton.icon(
                  onPressed: () async {
                    dynamic result =
                        await Navigator.pushNamed(context, '/choose_location');
                    setState(() {
                      data = {
                        'time': result['time'],
                        'location': result['location'],
                        'isDaytime': result['isDaytime'],
                        'flag': result['flag'],
                      };
                    });
                  },
                  label: Text(
                    ' thêm địa chỉ mới',
                    style: TextStyle(
                      color: Colors.lightGreen[500],
                    ),
                  ),
                  icon: Icon(
                    Icons.add_location_sharp,
                    size: 20.0,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDigitalClock extends StatefulWidget {
  // đồng hồ đếm số

  @override
  _MyDigitalClockState createState() => _MyDigitalClockState();
}

class _MyDigitalClockState extends State<MyDigitalClock> {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Text(
            "${getSystemTime()}",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontSize: 50.0,
            ),
          ),
        ),
      );
    });
  }
}


class MyTimer extends StatefulWidget {
  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  CountDownController _controller = CountDownController();
  int _duration = 25;

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
        title: Text(
            'TIMER',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: _duration,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: 250,

        // Height of the Countdown Widget.
        height: 250,

        // Ring Color for Countdown Widget.
        ringColor: Colors.red[800],

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Colors.blue,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.purple[500],

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 20.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.round,

        // Text Style for Countdown Text.
        textStyle: TextStyle(
            fontSize: 70.0, color: Colors.white, fontWeight: FontWeight.bold),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.S,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: false,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: false,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: false,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          print('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          print('Countdown Ended');

        },
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          _button(title: "Start", onPressed: () => _controller.start()),
          SizedBox(
            width: 10,
          ),
          _button(title: "Pause", onPressed: () => _controller.pause()),
          SizedBox(
            width: 10,
          ),
          _button(title: "Resume", onPressed: () => _controller.resume()),
          SizedBox(
            width: 10,
          ),
          _button(
              title: "Restart",
              onPressed: () => _controller.restart(duration: _duration))
        ],
      ),
    );
  }

  _button({@required String title, VoidCallback onPressed}) {
    return Expanded(
        child: ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white,
          fontSize: 11.0,
        ),
      ),
      onPressed: onPressed,
    ));
  }
}
