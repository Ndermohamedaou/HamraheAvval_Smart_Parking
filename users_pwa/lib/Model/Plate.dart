class PlateStructure {
  /// Plate structure.
  PlateStructure(this.plate0, this.plate1, this.plate2, this.plate3);
  final String plate0;
  final String plate1;
  final String plate2;
  final String plate3;
}

class SelfDocumentStructure {
  // As a user, would like to send car document to system.
  SelfDocumentStructure(this.melli_card_image);
  final String melli_card_image;
}

class FamilyDocumentStructure {
  // Family document structure.
  FamilyDocumentStructure(this.melliCardImage, this.carCardImage);
  final String melliCardImage;
  final String carCardImage;
}
