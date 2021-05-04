import 'package:payausers/Classes/AlphabetClassList.dart';

class PreparedPlate {
  AlphabetList alp = AlphabetList();
  List preparePlateInReserve({rawPlate}) {
    List perment = rawPlate.split("-");
    var plate0 = "${perment[0]}";
    var plate1 = "${alp.getAlp()[perment[1]]}";
    var plate2 = "${perment[2].substring(0, 3)}";
    var plate3 = "${perment[2].substring(3, 5)}";
    return [plate0, plate1, plate2, plate3];
  }
}
