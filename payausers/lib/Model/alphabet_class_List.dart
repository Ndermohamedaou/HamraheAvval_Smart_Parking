class AlphabetList {
  String value;
  String item;

  AlphabetList({this.value, this.item});

  Map getAlp() {
    return {
      "Alef": "الف",
      "B": "ب",
      "T": "ت",
      "Jim": "ج",
      "De": "د",
      "Z": "ز",
      "Sin": "س",
      "Sad": "ص",
      "Ta": "ط",
      "Ain": "ع",
      "F": "ف",
      "Gh": "ق",
      "K": "ک",
      "L": "ل",
      "M": "م",
      "N": "ن",
      "V": "و",
      "H": "ه",
      "Y": "ی",
      "Zh": "ژ",
      "D": "D",
      "S": "S",
    };
  }

  List<AlphabetList> getAlphabet() {
    return [
      AlphabetList(item: "الف", value: "Alef"), //0
      AlphabetList(item: "ب", value: "B"), //1
      AlphabetList(item: "ت", value: "T"), //2
      AlphabetList(item: "ج", value: "Jim"), //3
      AlphabetList(item: "د", value: "De"), //4
      AlphabetList(item: "ز", value: "Z"), //5
      AlphabetList(item: "س", value: "Sin"), //6
      AlphabetList(item: "ص", value: "Sad"), //7
      AlphabetList(item: "ط", value: "Ta"), //8
      AlphabetList(item: "ع", value: "Ain"), //9
      AlphabetList(item: "ف", value: "F"), //10
      AlphabetList(item: "ق", value: "Gh"), //11
      AlphabetList(item: "ک", value: "Ke"), //12
      AlphabetList(item: "ل", value: "L"), //13
      AlphabetList(item: "م", value: "M"), //14
      AlphabetList(item: "ن", value: "N"), //15
      AlphabetList(item: "و", value: "V"), //16
      AlphabetList(item: "ه", value: "H"), //17
      AlphabetList(item: "ی", value: "Y"), //18
      AlphabetList(item: "ژ", value: "Zh"), //19
      AlphabetList(item: "D", value: "D"), //20
      AlphabetList(item: "S", value: "S"), //21
    ];
  }
}
