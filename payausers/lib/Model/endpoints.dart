// Create structure of endpoints.
// This file is important file about our API. To use that only we need routes and method of route.
// If we want add new endpoint to this application only you need add your API Endpoint name, route and method.
// Sometimes I use route param in endpoints, like login endpoint. You only need to add route param in that.
// "loginEndpoint<Instance of Endpoint>.route?personal_code=$personal_code&password=$password"
class Endpoint {
  final String endpointName; // Endpoint name like login.
  final String route; // Can append with route params.
  final String method; // POST, GET, PUT, DELETE, etc.
  Endpoint(this.endpointName, this.route, this.method);
}

// Map of API Endpoint in each section as key.
// For example you can achieve to login with ["auth"]["login"].
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
      "PasswordReset": Endpoint("passwordReset", "/PasswordReset", "POST"),
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
        "checkPlateExistence", "/checkPlateExistence", "POST"), // plate0...3
  },
  "reserveEndpoint": {
    "changeDailyReserveStatus": Endpoint(
        "changeDailyReserveStatus", "/changeDailyReserveStatus", "POST"),
    "Reserve": Endpoint("Reserve", "/Reserve", "POST"),
    "getReserveWeeks": Endpoint("Reserve", "/getReserveWeeks", "GET"),
    "getUserReservesByWeek":
        Endpoint("getUserReservesByWeek", "/getUserReservesByWeek", "POST"),
    "getUserReserves": Endpoint("getUserReserves", "/getUserReserves", "GET"),
    // id: ObjectID
    "cancelReserve": Endpoint("cancelReserve", "/cancelReserve", "POST"),
    "cancelListReserve":
        Endpoint("cancelListReserve", "/cancelListReserve", "POST"),
    // plate_en
    "InstantReserve": Endpoint("InstantReserve", "/InstantReserve", "POST"),
    "canInstantReserve":
        Endpoint("InstantReserve", "/canInstantReserve", "GET"),
  }
};
