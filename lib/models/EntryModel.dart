import 'package:decimal/decimal.dart';
import 'dart:convert';
import 'dart:io';

class Entry {
  int cycle;
  DateTime date;
  bool bleeding;
  int? flow;
  int? pain;
  Decimal? temperature;
  String? notes;
  int id;

  // this should be called when getting an entry out of storage -- that is to say, it already has an id
  // also, it is called by the other constructor `createEntry` which requires an id when it's called
  Entry(
      {required this.cycle,
      required this.date,
      required this.bleeding,
      this.flow,
      this.pain,
      this.temperature,
      this.notes,
      required this.id});

  // this should be called when making a new entry to store in local storage
  // when this is called, id will need to be generated
  Entry createEntry(int cycle, DateTime date, bool bleeding, int? flow,
      int? pain, Decimal? temperature, String? notes, int id) {
    return Entry(
        cycle: cycle,
        date: date,
        bleeding: bleeding,
        flow: flow,
        pain: pain,
        temperature: temperature,
        notes: notes,
        id: id);
  }

  Map<String, dynamic> toJson() => {
        "cycle": cycle,
        "date": date,
        "bleeding": bleeding,
        "flow": flow,
        "pain": pain,
        "temperature": temperature,
        "notes": notes,
        "id": id,
      };

  String compress() {
    Map<String, dynamic> json = toJson();
    String jsonString = json.toString();
    List<int> utfEncoded = utf8.encode(jsonString);
    List<int> gzipEncoded = gzip.encode(utfEncoded);
    String base64Encoded = base64.encode(gzipEncoded);
    return base64Encoded;
  }

  Entry.fromJson(Map<String, dynamic> json)
      : cycle = json['cycle'] as int,
        date = json['date'] as DateTime,
        bleeding = json['bleeding'] as bool,
        flow = json['flow'] as int?,
        pain = json['pain'] as int?,
        temperature = json['temperature'] as Decimal?,
        notes = json['notes'] as String?,
        id = json['id'] as int;

  static Entry decompress(String encodedString) {
    List<int> base64Decoded = base64.decode(encodedString);
    List<int> gzipDecoded = gzip.decode(base64Decoded);
    String utfDecoded = utf8.decode(gzipDecoded);
    Map<String, dynamic> jsonObject = json.decode(utfDecoded);
    return Entry.fromJson(jsonObject);
  }
}
