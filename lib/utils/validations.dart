class AppValidations {
  const AppValidations._();

  static final RegExp _emailRegex =
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static bool isEmail(String? value) => value != null && value.isNotEmpty && _emailRegex.hasMatch(value);

  static bool isPassword(String? value) => value != null && value.trim().length > 8;

  static bool isName(String? value) => value != null && value.trim().length > 2;

  static bool isPhone(String? value) => value != null && value.trim().length > 8;
}
