class Pair<E, F> {
  E first;
  F last;
  Pair({required this.first, required this.last});

  @override
  String toString() {
    return "Pair: {$first,$last}";
  }
}
