// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on LoginStoreBase, Store {
  late final _$isPhoneLoadingAtom =
      Atom(name: 'LoginStoreBase.isPhoneLoading', context: context);

  @override
  bool get isPhoneLoading {
    _$isPhoneLoadingAtom.reportRead();
    return super.isPhoneLoading;
  }

  @override
  set isPhoneLoading(bool value) {
    _$isPhoneLoadingAtom.reportWrite(value, super.isPhoneLoading, () {
      super.isPhoneLoading = value;
    });
  }

  late final _$isEmailLoadingAtom =
      Atom(name: 'LoginStoreBase.isEmailLoading', context: context);

  @override
  bool get isEmailLoading {
    _$isEmailLoadingAtom.reportRead();
    return super.isEmailLoading;
  }

  @override
  set isEmailLoading(bool value) {
    _$isEmailLoadingAtom.reportWrite(value, super.isEmailLoading, () {
      super.isEmailLoading = value;
    });
  }

  late final _$isOtpLoadingAtom =
      Atom(name: 'LoginStoreBase.isOtpLoading', context: context);

  @override
  bool get isOtpLoading {
    _$isOtpLoadingAtom.reportRead();
    return super.isOtpLoading;
  }

  @override
  set isOtpLoading(bool value) {
    _$isOtpLoadingAtom.reportWrite(value, super.isOtpLoading, () {
      super.isOtpLoading = value;
    });
  }

  late final _$isUserInfoLoadingAtom =
      Atom(name: 'LoginStoreBase.isUserInfoLoading', context: context);

  @override
  bool get isUserInfoLoading {
    _$isUserInfoLoadingAtom.reportRead();
    return super.isUserInfoLoading;
  }

  @override
  set isUserInfoLoading(bool value) {
    _$isUserInfoLoadingAtom.reportWrite(value, super.isUserInfoLoading, () {
      super.isUserInfoLoading = value;
    });
  }

  late final _$isPhoneDoneAtom =
      Atom(name: 'LoginStoreBase.isPhoneDone', context: context);

  @override
  bool get isPhoneDone {
    _$isPhoneDoneAtom.reportRead();
    return super.isPhoneDone;
  }

  @override
  set isPhoneDone(bool value) {
    _$isPhoneDoneAtom.reportWrite(value, super.isPhoneDone, () {
      super.isPhoneDone = value;
    });
  }

  late final _$isEmailDoneAtom =
      Atom(name: 'LoginStoreBase.isEmailDone', context: context);

  @override
  bool get isEmailDone {
    _$isEmailDoneAtom.reportRead();
    return super.isEmailDone;
  }

  @override
  set isEmailDone(bool value) {
    _$isEmailDoneAtom.reportWrite(value, super.isEmailDone, () {
      super.isEmailDone = value;
    });
  }

  late final _$isOtpDoneAtom =
      Atom(name: 'LoginStoreBase.isOtpDone', context: context);

  @override
  bool get isOtpDone {
    _$isOtpDoneAtom.reportRead();
    return super.isOtpDone;
  }

  @override
  set isOtpDone(bool value) {
    _$isOtpDoneAtom.reportWrite(value, super.isOtpDone, () {
      super.isOtpDone = value;
    });
  }

  late final _$isDriverAtom =
      Atom(name: 'LoginStoreBase.isDriver', context: context);

  @override
  bool get isDriver {
    _$isDriverAtom.reportRead();
    return super.isDriver;
  }

  @override
  set isDriver(bool value) {
    _$isDriverAtom.reportWrite(value, super.isDriver, () {
      super.isDriver = value;
    });
  }

  late final _$isRegisteringAtom =
      Atom(name: 'LoginStoreBase.isRegistering', context: context);

  @override
  bool get isRegistering {
    _$isRegisteringAtom.reportRead();
    return super.isRegistering;
  }

  @override
  set isRegistering(bool value) {
    _$isRegisteringAtom.reportWrite(value, super.isRegistering, () {
      super.isRegistering = value;
    });
  }

  late final _$userIdAtom =
      Atom(name: 'LoginStoreBase.userId', context: context);

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$authTokenAtom =
      Atom(name: 'LoginStoreBase.authToken', context: context);

  @override
  String get authToken {
    _$authTokenAtom.reportRead();
    return super.authToken;
  }

  @override
  set authToken(String value) {
    _$authTokenAtom.reportWrite(value, super.authToken, () {
      super.authToken = value;
    });
  }

  late final _$phoneLoginAsyncAction =
      AsyncAction('LoginStoreBase.phoneLogin', context: context);

  @override
  Future<void> phoneLogin(BuildContext context, String phone, String pass) {
    return _$phoneLoginAsyncAction
        .run(() => super.phoneLogin(context, phone, pass));
  }

  late final _$validateOtpAndLoginAsyncAction =
      AsyncAction('LoginStoreBase.validateOtpAndLogin', context: context);

  @override
  Future<void> validateOtpAndLogin(
      BuildContext context, String smsCode, String phone, String otpmode) {
    return _$validateOtpAndLoginAsyncAction
        .run(() => super.validateOtpAndLogin(context, smsCode, phone, otpmode));
  }

  late final _$resendOtpAsyncAction =
      AsyncAction('LoginStoreBase.resendOtp', context: context);

  @override
  Future<void> resendOtp(BuildContext context, String phone) {
    return _$resendOtpAsyncAction.run(() => super.resendOtp(context, phone));
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('LoginStoreBase.resetPassword', context: context);

  @override
  Future<void> resetPassword(BuildContext context, String phone,
      String oldPassword, String newPassword) {
    return _$resetPasswordAsyncAction.run(
        () => super.resetPassword(context, phone, oldPassword, newPassword));
  }

  late final _$registerUserAsyncAction =
      AsyncAction('LoginStoreBase.registerUser', context: context);

  @override
  Future<void> registerUser(
      BuildContext context,
      String password,
      String phone,
      String email,
      String firstName,
      String lastName,
      String? currentMode,
      String? account) {
    return _$registerUserAsyncAction.run(() => super.registerUser(context,
        password, phone, email, firstName, lastName, currentMode, account));
  }

  @override
  String toString() {
    return '''
isPhoneLoading: ${isPhoneLoading},
isEmailLoading: ${isEmailLoading},
isOtpLoading: ${isOtpLoading},
isUserInfoLoading: ${isUserInfoLoading},
isPhoneDone: ${isPhoneDone},
isEmailDone: ${isEmailDone},
isOtpDone: ${isOtpDone},
isDriver: ${isDriver},
isRegistering: ${isRegistering},
userId: ${userId},
authToken: ${authToken}
    ''';
  }
}
