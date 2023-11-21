// ignore_for_file: file_names

class ThemeModel {
  String bleedingQuestion;
  String painQuestion;
  String flowQuestion;
  String temperatureQuestion;
  String symptomQuestion;
  String activityQuestion;
  int id;

  ThemeModel({
    required this.id,
    required this.bleedingQuestion,
    required this.painQuestion,
    required this.flowQuestion,
    required this.temperatureQuestion,
    required this.symptomQuestion,
    required this.activityQuestion,
  });

  static ThemeModel fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] ?? 0,
      bleedingQuestion: json['bleeding_question'] ?? "Are you bleeding?",
      painQuestion:
          json['pain_question'] ?? "From 1 to 5, what's your pain level?",
      flowQuestion:
          json['flow_question'] ?? "From 1 to 5, how heavy is your flow?",
      temperatureQuestion:
          json['temperature_question'] ?? "What's your temperature?",
      symptomQuestion: json['symptom_question'] ?? "What are your symptoms?",
      activityQuestion:
          json['activity_question'] ?? "Which activities have you done?",
    );
  }

  static ThemeModel base({
    id = 0,
    bleedingQuestion = "Are you bleeding?",
    painQuestion = "From 1 to 5, what's your pain level?",
    flowQuestion = "From 1 to 5, how heavy is your flow?",
    temperatureQuestion = "What's your temperature?",
    symptomQuestion = "What are your symptoms?",
    activityQuestion = "Which activities have you done?",
  }) {
    return ThemeModel(
      id: id,
      bleedingQuestion: bleedingQuestion,
      painQuestion: painQuestion,
      flowQuestion: flowQuestion,
      temperatureQuestion: temperatureQuestion,
      symptomQuestion: symptomQuestion,
      activityQuestion: activityQuestion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bleeding_question": bleedingQuestion,
      "pain_question": painQuestion,
      "flow_question": flowQuestion,
      "temperature_question": temperatureQuestion,
      "symptom_question": symptomQuestion,
      "activity_question": activityQuestion,
    };
  }
}
