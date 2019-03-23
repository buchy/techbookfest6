import 'dart:convert';

import 'package:http/http.dart';

class Station {
  final String id;
  final String name;
  final String image;

  Station(this.id, this.name, this.image);

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      json['id'],
      json['name'],
      json['image'],
    );
  }
}

class StationRepository {
  Future<List<Station>> getStations() async {
    final url = "https://buchy.github.io/techbookfest6/stations.json";
    final Response response = await get(url).timeout(Duration(seconds: 3));
    final Iterable stationsJson = json.decode(response.body)['stations'];
    final List<Station> stations =
        stationsJson.map((station) => Station.fromJson(station)).toList();
    return stations;
  }
}
