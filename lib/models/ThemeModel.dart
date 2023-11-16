// ignore_for_file: file_names

class ThemeModel {
  String bleedingQuestion;
  String symptomQuestion;
  String activityQuestion;
  int id;

  ThemeModel({
    required this.id,
    required this.bleedingQuestion,
    required this.symptomQuestion,
    required this.activityQuestion,
  });

  static ThemeModel fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] ?? 0,
      bleedingQuestion: json['bleeding_question'] ?? "Are you bleeding?",
      symptomQuestion: json['symptom_question'] ?? "What are your symptoms?",
      activityQuestion:
          json['activity_question'] ?? "Which activities have you done?",
    );
  }

  static ThemeModel base({
    id = 0,
    bleedingQuestion = "Are you bleeding?",
    symptomQuestion = "What are your symptoms?",
    activityQuestion = "Which activities have you done?",
  }) {
    return ThemeModel(
      id: id,
      bleedingQuestion: bleedingQuestion,
      symptomQuestion: symptomQuestion,
      activityQuestion: activityQuestion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bleeding_question": bleedingQuestion,
      "symptom_question": symptomQuestion,
      "activity_question": activityQuestion,
    };
  }
}
