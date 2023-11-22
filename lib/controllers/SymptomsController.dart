// ignore_for_file: file_names

import 'dart:convert';

import 'package:tadpole/controllers/BaseController.dart';
import 'package:tadpole/models/EntryModel.dart';
import 'package:tadpole/services/StorageService.dart';

class SymptomsController extends BaseController {
  Future<List<Symptom>> getSymptoms() async {
    return storageService.getSymptoms();
  }

  Future<bool> addSymptom(String? newSymptomText) async {
    if (newSymptomText?.isNotEmpty ?? false) {
      List<Symptom> symptoms = await storageService.getSymptoms();
      Symptom addableSymptom =
          Symptom(text: newSymptomText!, id: symptoms.length);
      bool exists = false;
      for (Symptom a in symptoms) {
        if (a.text == newSymptomText) {
          a.deleted = false;
          exists = true;
        }
      }
      if (!exists) {
        symptoms.add(addableSymptom);
      }
      return await storageService.setTable(
          StorageService.SYMPTOMS,
          symptoms.map<String>((element) {
            return json.encode(element.toJson());
          }).toList());
    }

    return false;
  }

  Future<bool> deleteSymptom(Symptom symptom) async {
    List<Symptom> symptoms = await storageService.getSymptoms();
    if (symptoms.contains(symptom)) {
      symptoms.where((element) => element == symptom).first.deleted = true;
    }
    return await storageService.setTable(
        StorageService.SYMPTOMS,
        symptoms.map<String>((element) {
          return json.encode(element.toJson());
        }).toList());
  }
}
