import 'package:hexcolor/hexcolor.dart';

// main Font Family
const mainFont = "IranSans";

const Map<String, double> imgConfig = {
  "maxWidth": 500,
  "maxHeight": 500,
  "imgQuality": 60,
};

const Map<String, int> textFieldsMaxLength = {
  "abuseTextField": 4,
};

// Colors
HexColor lightBgColor = HexColor("#F9F9F9");
HexColor darkBgColor = HexColor("#303841");
HexColor sideColorLight = HexColor("#EEEEEE");
HexColor sideColorDark = HexColor("#3A4750");
HexColor mainCTA = HexColor("#4AC4CB");
HexColor mainSectionCTA = HexColor("#F38137");
HexColor floatingAction = HexColor("#919BA0");
HexColor appBarColor = HexColor("#2AAFB7");
HexColor floatingActionPoint = HexColor("#919BA0");
HexColor logoutColor = HexColor("#A72222");

// Color for flusher
HexColor successfulChange = HexColor("#50e21b");
HexColor wrongChange = HexColor("#e82c32");

// Color for reserve
// -1 reserve
HexColor reserve = HexColor("#E1B231");
// 0 empty
HexColor empty = HexColor("#00CC6A");
// 1 full
HexColor fullSlot = HexColor("#B21122");

// searching results
HexColor lightOptionBg = HexColor("#F2F2F2");
HexColor darkOptionBg = HexColor("#3A4750");

// Colors -- Slots
HexColor reservedSlotColors = HexColor("#E1B231");
HexColor fullSlotColors = HexColor("#00CC6A");

// Colors -- results of searching colors
HexColor slotNumberBg = HexColor("#FED342");
HexColor slotStatusBg = HexColor("#A7AFB2");
HexColor entrySlotBg = HexColor("#AEDE0D");
HexColor exitSlotBg = HexColor("#DF1868");
HexColor staffPhoneBg = HexColor("#1df2eb");

// Colors -- mini plate colors
HexColor littleRecPlateColor = HexColor("#00478E");

// API
// BASE URL
const localIp = "http://192.168.1.5:8000/api";
const publicIp = "https://smartparking.mci.ir/api";
// const publicIp = "http://172.16.24.14:8010/api";
// const publicIp = "http://172.16.24.14:8010/api";
const baseURL = publicIp;
