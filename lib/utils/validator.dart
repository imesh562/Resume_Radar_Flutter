class Validator {
  static String regexEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String regexMobile = r"^\d{10}$";

  static bool validateNIC(String nic) {
    String nic_part1, nic_part2;
    int length = nic.length;
    bool retVal = false;
    try {
      if (length == 10) {
        try {
          nic_part1 = nic.substring(length - 1, length);
          nic_part2 = nic.substring(0, length - 1);

          double.parse(nic_part2);
          if (nic_part1 == "v" ||
              nic_part1 == "V" ||
              nic_part1 == "x" ||
              nic_part1 == "X") {
            retVal = validateDayOfTheYear(nic);
          }
        } on FormatException catch (e) {
          retVal = false;
        }
      } else if (length == 12) {
        try {
          double.parse(nic);
          retVal = validateDayOfTheYear(nic);
        } on FormatException catch (e) {
          retVal = false;
        }
      }
    } on Exception catch (e) {
      retVal = false;
    }

    return retVal;
  }

  static bool validateDayOfTheYear(String nic) {
    bool ret = false;
    int sex = 0;
    if (nic.length == 10) {
      sex = int.parse(nic.substring(2, 5));
    } else if (nic.length == 12) {
      sex = int.parse(nic.substring(4, 7));
    }

    if ((sex > 0 && sex <= 366) || sex > 500 && sex <= 866) {
      ret = true;
    } else {
      ret = false;
    }
    return ret;
  }

  static bool validateEmail(String email) {
    return RegExp(regexEmail).hasMatch(email);
  }
}
