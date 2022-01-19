import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_clip_oval.dart';

class IsInstantReserve {
  Widget getInstantButton(status, onTapped) => status == 0
      ? SizedBox()
      : status == 1
          ? CustomClipOval(
              icon: Icons.lock_clock,
              firstColor: mainSectionCTA,
              secondColor: mainCTA,
              aggreementPressed: onTapped,
            )
          : SizedBox();
}
