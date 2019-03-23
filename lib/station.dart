import 'dart:convert';

import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

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
  static const DB_NAME = "stations.db";

  Future<List<Station>> getStations() async {
    final url = "https://buchy.github.io/techbookfest6/stations.json";
    final Response response = await get(url).timeout(Duration(seconds: 3));
    final Iterable stationsJson = json.decode(response.body)['stations'];
    final List<Station> stations =
        stationsJson.map((station) => Station.fromJson(station)).toList();
    return stations;
  }

  void saveCheckInStation(final String stationId) async {
    final String dbPath = await getDatabasesPath();
    final checkInStatus = await getCheckInStatus(stationId);
    if (!checkInStatus) {
      final Database database =
          await openDatabase(dbPath + DB_NAME, version: 1);

      database.rawInsert(
          'INSERT INTO checkin_stations(id) VALUES (?)', [stationId]);
    }
  }

  Future<bool> getCheckInStatus(final String stationId) async {
    final dbPath = await getDatabasesPath();
    final Database database = await openDatabase(dbPath + DB_NAME, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE checkin_stations(id VARCHAR(255) PRIMARY KEY)');
    });
    final count = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(id) FROM checkin_stations WHERE id = ?', [stationId]));
    if (count < 1) {
      return false;
    }
    return true;
  }
}
