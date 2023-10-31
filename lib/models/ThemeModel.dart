// ignore_for_file: file_names

class ThemeModel {
  String bleedingQuestion;
  int id;

  ThemeModel({required this.id, required this.bleedingQuestion});

  static ThemeModel fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] ?? 0,
      bleedingQuestion: json['bleeding_question'] ?? "Are you bleeding?",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bleeding_question": bleedingQuestion,
    };
  }
}
