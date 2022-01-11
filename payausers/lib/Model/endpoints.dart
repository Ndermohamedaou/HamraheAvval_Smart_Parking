Map apiEndpointsMap = {
  "auth": {
    "login": Endpoint("login", "/login", "POST"), // personal_code, password
    "logout": Endpoint("logout", "/logout", "POST"),
    "changePassword": Endpoint("changePassword", "/changePassword", "POST"),
    // This Map made for OTP section and will verify the OTP.
    "otp": {
      // code, personal_code, DeviceToken.
      "submitCode": Endpoint("submitCode", "/submitCode", "POST"),
      // personal_code.
      "resendOTP": Endpoint("resendOTP", "/resendOTP", "POST"),
      // personal_code
      "PasswordReset": Endpoint("passwordReset", "/passwordReset", "POST"),
      // otp_code, password.
      "recoverPassword":
          Endpoint("recover_password", "/recover_password", "POST"),
    },
    "staffInfo": Endpoint("staffInfo", "/staffInfo", "GET"),
    "updateStaffInfo": Endpoint("updateStaffInfo", "/updateStaffInfo", "POST"),
  },
  "getUserTraffic": Endpoint("getUserTraffic", "/getUserTraffic", "GET"),
  "plateEndpoint": {
    "getUserPlates": Endpoint("getUserPlates", "/getUserPlates", "GET"),
    // Add and upload new user plate.
    // If user want send self, family, other.
    // in this enpoint we put, plate0...3 in route.
    //but we will have diffrent data structure for FormData.
    "uploadDocuments": Endpoint("uploadDocuments", "/uploadDocuments", "POST"),
    // plate_en
    "delUserPlate": Endpoint("delUserPlate", "/delUserPlate", "POST"),
    "checkPlateExistence": Endpoint(
        "checkPlateExistence", "/checkPlateExistenca", "POST"), // plate0...3
  },
  "reserveEndpoint": {
    "Reserve": Endpoint("Reserve", "/Reserve", "POST"),
    "getReserveWeeks": Endpoint("Reserve", "/getReserveWeeks", "GET"),
    "getUserReservesByWeek":
        Endpoint("Reserve", "/getUserReservesByWeek", "POST"),
    "getUserReserves": Endpoint("getUserReserves", "/getUserReserves", "GET"),
    // id: ObjectID
    "cancelReserve": Endpoint("cancelReserve", "/cancelReserve", "POST"),
    // plate_en
    "InstantReserve": Endpoint("InstantReserve", "/InstantReserve", "POST"),
  }
};

// Create structure of endpoints.
class Endpoint {
  Endpoint(this.endpointName, this.route, this.method);
  final String endpointName;
  final String route;
  final String method;
}
