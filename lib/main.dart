import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationList = List.generate(20, (i) => "station$i");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Station List"),
        ),
        body: ListView.builder(
            itemCount: stationList.length * 2,
            itemBuilder: (context, final index) {
              if (index.isOdd) {
                return Divider(color: Colors.blue);
              }
              return ListTile(
                title: Text(stationList[index ~/ 2],
                    style: TextStyle(fontSize: 22.0)),
              );
            }),
      ),
    );
  }
}
