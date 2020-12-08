import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import '../constFile/optStyle.dart';

// Setting Section in HomeScreen (main)
class Setting extends StatelessWidget {
  const Setting({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [


            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: cardStyleColor,

              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/StylePage');
              },
              child: OptionsViewer(
                text: 'حالت شب و روز',
                desc:
                    "شما میتوانید با استفاده از این گزینه از اپلیکیشن در هر محیطی متناسب با چشمان خود استفاده کنید",
                avatarBgColor: Colors.purple,
                avatarIcon: LineAwesomeIcons.lightbulb,
                iconColor: Colors.white,
              ),
            ),
            OptionsViewer(
              text: 'آدرس های آی پی',
              desc: "برای دسترسی به تمامی آدرس های آی پی کلیک کنید",
              avatarBgColor: Colors.yellow,
              avatarIcon: Icons.privacy_tip_outlined,
              iconColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
