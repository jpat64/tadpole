// ignore_for_file: file_names

import 'dart:math';

import 'package:moonbase/services/Logger.dart';

class KeyGeneratorService {
  static final List<String> _wordList1 = [
    "apple",
    "bird",
    "cow",
    "dragonfly",
    "elephant",
    "flower",
    "glass",
    "helicopter",
    "ice cream",
    "juice",
    "kite",
    "ladybug",
    "mouse",
    "nutella",
    "owl",
    "pin",
    "question",
    "rocket",
    "sun",
    "tree",
    "umbrella",
    "vegetable",
    "whale",
    "xylophone",
    "yacht",
    "zebra"
  ];

  static final List<String> _wordList2 = [
    "Anchor",
    "Bear",
    "Cherry",
    "Dolphin",
    "Elephant",
    "Frog",
    "Giraffe",
    "Hazelnut",
    "Island",
    "Jar",
    "Kangaroo",
    "Lion",
    "Mushroom",
    "needle",
    "orange",
    "penguin",
    "queen",
    "rabbit",
    "sheep",
    "turtle",
    "unicorn",
    "vase",
    "watermelon",
    "x-ray",
    "yak",
    "zipper"
  ];

  // using the current timestamp milliseconds, create a key
  static String generateKey() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int place1 = timestamp % 13;
    int place2 = ((timestamp / 13).floor()) % 13;
    int place3 = (((timestamp / 13).floor()) / 13).floor() % 13;
    int place4 =
        (((((timestamp / 13).floor()) / 13).floor()) / 13).floor() % 13;

    assert(_wordList1.length >= 26 && _wordList2.length >= 26,
        "word lists have not been initialized");

    return "${_wordList2[place3]} ${_wordList2[place4 + 13]} ${_wordList1[place1]} ${_wordList1[place2 + 13]}";
  }

  // using the key, create (deterministically) a number between 1 and 200
  // this is deterministic in that each key produces an int
  // this is not unique for each key, obviously (13^4 >>>>> 200)
  static int decipherKey(String key) {
    if (key == "UN-SET") return -1;
    List<String> words = key.split(" ");
    assert(words.length == 4, "the key should have exactly 4 words in it.");

    // first two words are in _wordList2
    int place3 = _wordList2.indexOf(words[0]);
    int place4 = _wordList2.indexOf(words[1]) - 13;

    // last two words are in  _wordList1
    int place1 = _wordList1.indexOf(words[2]);
    int place2 = _wordList1.indexOf(words[3]) - 13;

    Logger.info(
        "KeyGeneratorService.decipherKey() key: $key\tnumbers:[$place3 $place4 $place1 $place2]");

    return min(
        ((25 / 36) * (place1 * place3)).ceil() +
            ((25 / 36) * (place2 * place4)).ceil(),
        199);
  }
}
