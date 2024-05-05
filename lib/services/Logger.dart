// ignore_for_file: file_names, avoid_print

class Logger {
  static void info(String message) {
    print("[INFO]: $message");
  }

  static void warning(String warning) {
    print("[WARN]: $warning");
  }

  static void error(Exception exc) {
    print("[ERROR]: $exc");
  }
}
