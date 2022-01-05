part of flubletter;

class Uteste {
  final Uint8List uuid;

  Uteste(List<int> data) : uuid = Uint8List.fromList(data);

  // ignore: empty_constructor_bodies
  /*factory Uteste.parse(String data) {
    String dataa = data;
    for (var dataByte = 0; dataByte < data.length;) {
    }
  }*/
  static String removeNonHexCharacters(String sourceString) {
    return String.fromCharCodes(sourceString.runes.where((r) =>
            (r >= 48 && r <= 57) // characters 0 to 9
            ||
            (r >= 65 && r <= 70) // characters A to F
            ||
            (r >= 97 && r <= 102) // characters a to f
        ));
  }
}
