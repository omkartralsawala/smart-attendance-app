abstract class StringValidator {
  bool isValid(String value);
  bool isValidInt(int value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  bool isValidInt(int value) {
    return value.isNaN;
  }
}
class Validators {
  final StringValidator firstNameValidator = NonEmptyStringValidator();
  final StringValidator lastNameValidator = NonEmptyStringValidator();
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordVaidator = NonEmptyStringValidator();
  final StringValidator restaurantValidator = NonEmptyStringValidator();
  final StringValidator deviceNameValidator = NonEmptyStringValidator();
  final StringValidator hourValidator = NonEmptyStringValidator();
  final StringValidator minValidator = NonEmptyStringValidator();
  final StringValidator secValidator = NonEmptyStringValidator();
 
  final String invalidFirstNameError = "First name can't be empty";
  final String invalidLastNameError = "Last name cant't be empty";
  final String invalidEmailError = "Email can't be empty";
  final String invalidPasswordError = "Password can't be empty";
  final String invalidRestaurantError = "Restaurant Name can't be empty";
  final String invalidDeviceNameError = "Device Name can't be empty";
  final String invalidDeviceIDError = "Device Id can't be empty";
  final String invalidHourError = "Hours should be a number";
  final String invalidMinError = "Minutes should be a number";
  final String invalidSecError = "Seconds should be a number";
  final String invalidDeviceIdError = "Device id is not registeres";
}
