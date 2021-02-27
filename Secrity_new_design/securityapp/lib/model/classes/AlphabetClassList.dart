class AlphabetList {
  String value;
  String item;

  AlphabetList({this.value, this.item});

  Map getAlp() {
    return {
      "Alef": "الف",
      "B": "ب",
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
      AlphabetList(item: "ج", value: "Jim"), //2
      AlphabetList(item: "د", value: "De"), //3
      AlphabetList(item: "ز", value: "Z"), //4
      AlphabetList(item: "س", value: "Sin"), //5
      AlphabetList(item: "ص", value: "Sad"), //6
      AlphabetList(item: "ط", value: "Ta"), //7
      AlphabetList(item: "ع", value: "Ain"), //8
      AlphabetList(item: "ف", value: "F"), //9
      AlphabetList(item: "ق", value: "Gh"), //10
      AlphabetList(item: "ک", value: "Ke"), //11
      AlphabetList(item: "ل", value: "L"), //12
      AlphabetList(item: "م", value: "M"), //13
      AlphabetList(item: "ن", value: "N"), //14
      AlphabetList(item: "و", value: "V"), //15
      AlphabetList(item: "ه", value: "H"), //16
      AlphabetList(item: "ی", value: "Y"), //17
      AlphabetList(item: "ژ", value: "Zh"), //18
      AlphabetList(item: "D", value: "D"), //19
      AlphabetList(item: "S", value: "S"), //20
    ];
  }
}
