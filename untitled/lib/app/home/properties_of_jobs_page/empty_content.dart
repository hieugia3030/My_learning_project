import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = ' 😞 Không có gì ở đây cả 😞',
    this.message = 'Thêm công việc mới ở dấu "+" bên dưới nhá 😉',
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black54,
            ),
          ),

          SizedBox(height: 10.0),
          
          Text(
              message,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
