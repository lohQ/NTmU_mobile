class InputValidator {

  static String validateUsername(String val){
    if(val.isEmpty){
      return _shouldNotBeEmpty("username");
    }
    return null;
  }

  static String validatePassword(String val){
    if(val.isEmpty){
      return _shouldNotBeEmpty("password");
    }else if (val.length < 8){
      return "password should be at least 8 characters long";
    }else if(!val.contains(RegExp(r'[a-zA-Z]'))){
      return "password should be alphanumeric";
    }
    return null;
  }

  static String validateEmail(String val){
    if(!(val.endsWith('@e.ntu.edu.sg') || val.endsWith('@ntu.edu.sg'))){
      return "Only NTU email addresses are accepted!";
    }
    return null;
  }

  static String validateNonNull(dynamic val){
    if(val == null){
      return _shouldNotBeEmpty("This field");
    }
    if(val is String && val.isEmpty){
      return _shouldNotBeEmpty("This field");
    }
    return null;
  }

  static String _shouldNotBeEmpty(String fieldname){
    return "$fieldname should not be empty";
  }


}