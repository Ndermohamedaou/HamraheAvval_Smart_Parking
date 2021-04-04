const regexForEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const regexForPassword =
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$";

// Checking the User Email address with Regex
bool emailValidator(emailAdd) {
  bool emailValid = RegExp(regexForEmail).hasMatch(emailAdd);
  return emailValid;
}

bool passwordRegex(pass) {
  bool passwordValid = RegExp(regexForPassword).hasMatch(pass);
  return passwordValid;
}
