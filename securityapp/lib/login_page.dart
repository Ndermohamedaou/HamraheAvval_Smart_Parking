import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constFile/texts.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'classes/ApiAccess.dart';
import 'classes/SavingLocalStorage.dart';

bool protectedPassword = true;
// ignore: non_constant_identifier_names
String user_email = "";
// ignore: non_constant_identifier_names
String user_password = "";
// for changing password icon
IconData showMePass = Icons.remove_red_eye;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPassword = null;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Getting users token with this Future life cycle
  // ignore: missing_return
  Dio dio = Dio();

  // Instance of local data
  LocalizationDataStorage lds = LocalizationDataStorage();

  // if first visit be false
  void fetchingUserDetails(String uToken, uPass) async {
    // Token as req goes to server and get me user details
    try {
      ApiAccess api = ApiAccess();
      Map response = await api.gettingUsersInfo(uToken);
      // print(response);
      bool lStorageStatus = await lds.savingUInfo(
          uToken: uToken,
          fullName: response['name'],
          email: response['email'],
          personalCode: response['personal_code'],
          naturalCode: response['melli_code'],
          password: uPass,
          avatar: response['avatar']);

      if (lStorageStatus) {
        Navigator.pushNamed(context, '/');
      } else {
        Toast.show(applicationError, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } catch (e) {
      Toast.show(notAMemberText, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  }

  // If user is new in application
  void confirmUser(uToken) async {
    try {
      ApiAccess api = ApiAccess();
      Map response = await api.gettingUsersInfo(uToken);
      var userInfo = response;
      // print(response);
      Navigator.pushNamed(context, '/confirmation',
          arguments: {"userInfo": userInfo, "uToken": uToken});
    } catch (e) {
      Toast.show(serverProblem, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
      print(e);
    }
  }

  void gettingToken(email, pass) async {
    // Check if TextBox be not null
    // emptyTextFieldErr will be null else is have error message!
    if (email != "" || pass != "") {
      try {
        // Dio with post method to get response from local server
        // but if you want work with localhost we must use 10.0.2.2 IP address
        // because AVD use this ip address as local IP!
        // BaseUrl is abstraction of our url api
        // dio.options.baseUrl = "http://10.0.2.2:8000/api";
        // Check const file for API url if you want to change that
        Response response =
            await dio.post("${apiUrl}/login?email=${email}&password=${pass}");
        // if there is a user on server we will get 200
        if (response.data['status'] == "200") {
          // print(response.data);
          // first visit ? navigated to new page
          // to put your email and confirm password
          if (response.data['first_visit']) {
            String userToken = response.data['token'];
            confirmUser(userToken);
          } else {
            // if user is not **New** in app
            String userToken = response.data['token'];
            fetchingUserDetails(userToken, pass);
          }
        } else {
          Toast.show(notAMemberText, context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } catch (e) {
        Toast.show(notAMemberText, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } else {
      setState(() {
        emptyTextFieldErrEmail = emptyTextFieldMsg;
        emptyTextFieldErrPassword = emptyTextFieldMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              gettingToken(user_email, user_password);
            },
            child: Text(
              loginText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: loginTextFontFamily,
                  fontSize: loginTextSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(
                  viewScreenLightOrDark,
                  style: TextStyle(fontSize: 20, fontFamily: mainFontFamily),
                ),
                leading: Container(
                  width: 60,
                  child: Switch(
                    activeColor: Colors.blue[700],
                    value: themeChange.darkTheme,
                    onChanged: (bool value) {
                      themeChange.darkTheme = value;
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: themeChange.darkTheme
                  ? Image.asset(
                      "assets/images/haDark.png",
                      width: widthOfLoginLogo,
                    )
                  : Image.asset(
                      "assets/images/haLight.png",
                      width: widthOfLoginLogo,
                    ),
            ),
            Text(
              greetingText,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: mainFontFamily),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFields(
              lblText: phoneOrEmail,
              textFieldIcon: Icons.contacts_outlined,
              textInputType: false,
              readOnly: false,
              errText:
                  emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
              onChangeText: (username) {
                setState(() {
                  emptyTextFieldErrEmail = null;
                  user_email = username;
                });
              },
            ),
            SizedBox(height: 20),
            TextFields(
              lblText: passwordLblText,
              maxLen: 20,
              readOnly: false,
              errText:
                  emptyTextFieldErrPassword == null ? null : emptyTextFieldMsg,
              textInputType: protectedPassword,
              textFieldIcon:
                  user_password == "" ? Icons.vpn_key_outlined : showMePass,
              iconPressed: () {
                setState(() {
                  protectedPassword
                      ? protectedPassword = false
                      : protectedPassword = true;
                  // Changing eye icon pressing
                  showMePass == Icons.remove_red_eye
                      ? showMePass = Icons.remove_red_eye_outlined
                      : showMePass = Icons.remove_red_eye;
                });
              },
              onChangeText: (password) {
                setState(() {
                  emptyTextFieldErrPassword = null;
                  user_password = password;
                });
              },
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgetPassword');
                  },
                  child: Text(
                    forgetTextButtonHint,
                    style: TextStyle(
                        fontFamily: mainFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
