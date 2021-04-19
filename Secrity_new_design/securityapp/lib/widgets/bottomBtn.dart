import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:sizer/sizer.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    this.text,
    this.color,
    this.loadingState = false,
    this.onTapped,
  });

  final String text;
  final color;
  final bool loadingState;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(8.0),
        color: color,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: !loadingState ? onTapped : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loadingState
                    ? Container(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          backgroundColor: mainCTA,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: mainFont,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ],
            )),
      ),
    );
  }
}
