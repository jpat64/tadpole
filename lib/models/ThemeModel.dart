// ignore_for_file: file_names

class ThemeModel {
  String bleedingQuestion;
  String symptomQuestion;
  int id;

  ThemeModel({
    required this.id,
    required this.bleedingQuestion,
    required this.symptomQuestion,
  });

  static ThemeModel fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] ?? 0,
      bleedingQuestion: json['bleeding_question'] ?? "Are you bleeding?",
      symptomQuestion: json['symptom_question'] ?? "What are your symptoms?",
    );
  }

  static ThemeModel base({
    id = 0,
    bleedingQuestion = "Are you bleeding?",
    symptomQuestion = "What are your symptoms?",
  }) {
    return ThemeModel(
      id: id,
      bleedingQuestion: bleedingQuestion,
      symptomQuestion: symptomQuestion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bleeding_question": bleedingQuestion,
      "symptom_question": symptomQuestion,
    };
  }
}
