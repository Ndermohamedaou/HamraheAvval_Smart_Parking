const regexForEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

// Checking the User Email address with Regex
bool emailValidator(emailAdd) {
  bool emailValid = RegExp(regexForEmail).hasMatch(emailAdd);
  return emailValid;
}
