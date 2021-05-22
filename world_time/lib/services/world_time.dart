import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  String location; // location name for the UI
  DateTime time; // time in that location
  String flag;
  String url; // location url for ui endpoints
  bool isDaytime = true;
  String offset;
  WorldTime({this.location, this.flag, this.url});
  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };
  Future <void> getTime() async {
    try{
      Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'), headers: headers); // nếu ko có cái header thì sẽ bị lỗi như lày
      Map data = jsonDecode(response.body);


      //get properties from data
      String datetime = data['utc_datetime']; // thời gian theo múi giờ chuẩn (+ 0:00)
       offset = data['utc_offset'].substring(0,3); // tách 3 chữ cái đầu tiên ra để có thể convert sang int vì ban đầu nó ntn: +4.0:00

      time = DateTime.parse(datetime);
      time = time.add(Duration(hours: int.parse(offset) )); // cộng thêm múi giờ vào

      if(time.hour >= 6 && time.hour < 18) {
        isDaytime = true;
      }
      else isDaytime = false;

    } catch(e)
    {
      time = DateTime.now().add(Duration(hours: int.parse(offset)-7));
    }

  }
}