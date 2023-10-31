// ignore_for_file: file_names

class Pair<E, F> {
  E first;
  F last;
  Pair({required this.first, required this.last});

  @override
  String toString() {
    return "Pair: {$first,$last}";
  }
}
