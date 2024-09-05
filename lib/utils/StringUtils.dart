// ignore_for_file: file_names

extension StringUtils on String {
  String capitalize() {
    assert(length >= 1, "cannot capitalize an empty string");
    return substring(0, 1).toUpperCase() + substring(1).toLowerCase();
  }
}
