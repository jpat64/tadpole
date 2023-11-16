// ignore_for_file: file_names

import 'package:decimal/decimal.dart';
import 'dart:convert';

class Entry {
  int cycle;
  bool bleeding;
  int? flow;
  int? pain;
  Decimal? temperature;
  String? notes;
  int id;
  List<Activity>? activities;
  List<Symptom>? symptoms;

  // this should be called when getting an entry out of storage -- that is to say, it already has an id
  // also, it is called by the other constructor `createEntry` which requires an id when it's called
  Entry(
      {required this.cycle,
      required this.bleeding,
      this.flow,
      this.pain,
      this.temperature,
      this.notes,
      required this.id,
      this.activities,
      this.symptoms});

  // this should be called when making a new entry to store in local storage
  // when this is called, id will need to be generated
  Entry createEntry(
    int cycle,
    bool bleeding,
    int? flow,
    int? pain,
    Decimal? temperature,
    String? notes,
    int id,
    List<Activity>? activities,
    List<Symptom>? symptoms,
  ) {
    return Entry(
      cycle: cycle,
      bleeding: bleeding,
      flow: flow,
      pain: pain,
      temperature: temperature,
      notes: notes,
      id: id,
      activities: activities,
      symptoms: symptoms,
    );
  }

  Map<String, dynamic> toJson() => {
        "cycle": cycle,
        "bleeding": bleeding,
        "flow": flow,
        "pain": pain,
        "temperature": temperature,
        "notes": notes,
        "id": id,
      };

  @override
  String toString() {
    return "Entry: {id:$id, cycle:$cycle, bleeding:$bleeding, flow:$flow, pain:$pain, temperature:$temperature, notes:$notes, activities:$activities, symptoms:$symptoms}";
  }

  String compress() {
    Map<String, dynamic> jsonMap = toJson();
    String jsonString = json.encode(jsonMap);
    //List<int> utfEncoded = utf8.encode(jsonString);
    //List<int> gzipEncoded = gzip.encode(utfEncoded);
    //String base64Encoded = base64.encode(gzipEncoded);
    return jsonString;
  }

  Entry.fromJson(Map<String, dynamic> json)
      : cycle = json['cycle'] as int,
        bleeding = json['bleeding'] as bool,
        flow = json['flow'] as int?,
        pain = json['pain'] as int?,
        temperature = json['temperature'] as Decimal?,
        notes = json['notes'] as String?,
        id = json['id'] as int;

  static Entry decompress(String encodedString) {
    //List<int> base64Decoded = base64.decode(encodedString);
    //List<int> gzipDecoded = gzip.decode(base64Decoded);
    //String utfDecoded = utf8.decode(gzipDecoded);
    Map<String, dynamic> jsonObject = json.decode(encodedString);
    return Entry.fromJson(jsonObject);
  }

  @override
  int get hashCode =>
      Object.hash(id, cycle, bleeding, flow, pain, temperature, notes);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return (other as Entry).id.compareTo(id) == 0;
  }
}

abstract class ListCandidate {
  int id;
  String text;
  bool deleted;

  ListCandidate({required this.id, required this.text, required this.deleted});

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "deleted": deleted,
      };

  String compress() {
    Map<String, dynamic> json = toJson();
    String jsonString = json.toString();
    return jsonString;
  }

  ListCandidate.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        text = json['text'] as String,
        deleted = json['deleted'] as bool;

  int compareTo(ListCandidate other) => other.text.compareTo(text);

  @override
  int get hashCode => Object.hash(id, text);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return (other as ListCandidate).text.compareTo(text) == 0;
  }

  @override
  String toString() {
    return "${runtimeType.toString()}: id:$id, text:$text, deleted:$deleted";
  }
}

class Activity extends ListCandidate {
  Activity({required super.id, required super.text, super.deleted = false});

  Activity.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  static Activity decompress(String encodedString) =>
      Activity.fromJson(json.decode(encodedString));

  @override
  int compareTo(ListCandidate other) {
    if (other is Activity) {
      return other.text.compareTo(text);
    } else {
      throw Exception('comparing $this to $other- not an Activity.');
    }
  }

  Activity.base(
      {super.id = -1, super.text = "base Activity", super.deleted = false});
}

class Symptom extends ListCandidate {
  Symptom({required super.id, required super.text, super.deleted = false});

  Symptom.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  static Symptom decompress(String encodedString) =>
      Symptom.fromJson(json.decode(encodedString));

  @override
  int compareTo(ListCandidate other) {
    if (other is Symptom) {
      return other.text.compareTo(text);
    } else {
      throw Exception('comparing $this to $other- not a Symptom.');
    }
  }

  Symptom.base(
      {super.id = -1, super.text = "base Symptom", super.deleted = false});
}
