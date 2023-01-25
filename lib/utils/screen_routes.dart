import 'package:get/get.dart';
import 'package:pumpkin/screens/authentication/2fa_code_screen.dart';
import 'package:pumpkin/screens/authentication/2fa_confirmation_screen.dart';
import 'package:pumpkin/screens/authentication/biometric_pin_confirm_screen.dart';
import 'package:pumpkin/screens/authentication/biometric_pin_screen.dart';
import 'package:pumpkin/screens/authentication/confirm_email_screen.dart';
import 'package:pumpkin/screens/authentication/confirm_email_screen_after_login.dart';
import 'package:pumpkin/screens/authentication/confirm_email_screen_for_pin_reset.dart';
import 'package:pumpkin/screens/authentication/confirm_mobile_screen.dart';
import 'package:pumpkin/screens/authentication/enter_mobile_number_screen.dart';
import 'package:pumpkin/screens/authentication/forgot_password_screen.dart';
import 'package:pumpkin/screens/authentication/forgot_password_screen_after_login.dart';
import 'package:pumpkin/screens/authentication/login_screen.dart';
import 'package:pumpkin/screens/authentication/set_new_password_screen.dart';
import 'package:pumpkin/screens/authentication/set_password_screen.dart';
import 'package:pumpkin/screens/authentication/set_password_screen_after_login.dart';
import 'package:pumpkin/screens/authentication/signup_screen.dart';
import 'package:pumpkin/screens/dashboard/dashboard.dart';
import 'package:pumpkin/screens/leads/add_lead_screen.dart';
import 'package:pumpkin/screens/leads/enter_lead_details_screen.dart';
import 'package:pumpkin/screens/leads/lead_basic_details_screen.dart';
import 'package:pumpkin/screens/leads/lead_contacts_screen.dart';
import 'package:pumpkin/screens/leads/lead_dependants_screen.dart';
import 'package:pumpkin/screens/leads/lead_personal_details_screen.dart';
import 'package:pumpkin/screens/leads/lead_profile_screen.dart';
import 'package:pumpkin/screens/leads/manage_tags_screen.dart';
import 'package:pumpkin/screens/leads/policy_details_screen.dart';
import 'package:pumpkin/screens/leads/search_leads_screen.dart';
import 'package:pumpkin/screens/leads/upload_file_screen.dart';
import 'package:pumpkin/screens/profile/change_password_screen.dart';
import 'package:pumpkin/screens/profile/complete_profile_screen.dart';
import 'package:pumpkin/screens/profile/connected_screen.dart';
import 'package:pumpkin/screens/profile/my_account_screen.dart';
import 'package:pumpkin/screens/profile/my_points_list_screen.dart';
import 'package:pumpkin/screens/profile/my_points_screen.dart';
import 'package:pumpkin/screens/profile/my_profile_screen.dart';
import 'package:pumpkin/screens/profile/point_table_screen.dart';
import 'package:pumpkin/screens/profile/settings_screen.dart';
import 'package:pumpkin/screens/profile/setup_profile_screen.dart';
import 'package:pumpkin/screens/splash_screen/splash_screen.dart';
import 'package:pumpkin/screens/splash_screen/walkthrough_screen.dart';

double buttonBorderRadius = 8.0;

// Screen Path Urls
String initialScreen = '/';
String walkthroughScreen = '/walkthrough';
String loginScreen = '/loginScreen';
String signupScreen = '/signupScreen';
String confirmEmailScreen = '/confirmEmailScreen';
String forgotPasswordScreen = '/forgotPasswordScreen';
String twofactorCodeScreen = '/twoFactorCodeScreen';
String twofactorConfirmationScreen = '/twofactorConfirmationScreen';
String confirmMobileScreen = '/confirmMobileScreen';
String enterMobileNumberScreen = '/enterMobileNumberScreen';
String setPasswordScreen = '/setPasswordScreen';
String setNewPasswordScreen = '/setNewPasswordScreen';
String myProfileScreen = '/myProfileScreen';
String setupProfileScreen = '/setupProfileScreen';
String completeProfileScreen = '/completeProfileScreen';
String myAccountScreen = '/myAccountScreen';
String mainDashBoardScreen = '/mainDashboardScreen';
String searchLeadsScreen = '/searchLeadsScreen';
String leadProfileScreen = '/leadProfileScreen';
String settingsScreen = '/settingsScreen';
String connectedScreen = '/connectedScreen';
String changePasswordScreen = '/changePasswordScreen';
String forgetPasswordScreen = '/forgetPasswordScreen';
String myPointsScreen = '/myPointsScreen';
String myPointsListScreen = '/myPointsListScreen';
String pointTableScreen = '/pointTableScreen';
String forgotPasswordScreenAfterLogin = '/forgotPasswordScreenAfterLogin';
String confirmEmailScreenAfterLogin = '/confirmEmailScreenAfterLogin';
String setPasswordScreenAfterLogin = '/setPasswordScreenAfterLogin';
String biometricPinScreen = '/biometricPinScreen';
String biometricPinConfirmScreen = '/biometricPinConfirmScreen';
String confirmEmailScreenForPinReset = '/confirmEmailScreenForPinReset';
String uploadFileScreen = '/uploadFileScreen';
String manageTagsScreen = '/manageTagsScreen';
String leadBasicDetailsScreen = '/leadBasicDetailsScreen';
String addLeadScreen = '/addLeadScreen';
String policyDetailsScreen = '/policyDetailsScreen';
String leadContactsScreen = '/leadContactsScreen';
String leadPersonalDetailsScreen = '/LeadPersonalDetailsScreen';
String leadDependantsScreen = '/leadDependantsScreen';
String enterLeadDetailsScreen = '/EnterLeadDetailsScreen';

class NavigationRoutes {
  static final routes = [
    GetPage(
      name: initialScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: confirmEmailScreen,
      page: () => const ConfirmEmailScreen(),
    ),
    GetPage(
      name: enterMobileNumberScreen,
      page: () => const EnterMobileNumberScreen(),
    ),
    GetPage(
      name: confirmMobileScreen,
      page: () => const ConfirmMobileScreen(),
    ),
    GetPage(
      name: setPasswordScreen,
      page: () => const SetPasswordScreen(),
    ),
    GetPage(
      name: setupProfileScreen,
      page: () => const SetupProfileScreen(),
    ),
    GetPage(
      name: settingsScreen,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: changePasswordScreen,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: completeProfileScreen,
      page: () => const CompleteProfileScreen(),
    ),
    GetPage(
      name: myProfileScreen,
      page: () => const MyProfileScreen(),
    ),
    GetPage(
      name: connectedScreen,
      page: () => const ConnectedScreen(),
    ),
    GetPage(
      name: myAccountScreen,
      page: () => const MyAccountScreen(),
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: myPointsScreen,
      page: () => MyPointsScreen(),
    ),
    GetPage(
      name: myPointsListScreen,
      page: () => const MyPointsListScreen(),
    ),
    GetPage(
      name: pointTableScreen,
      page: () => const PointTableScreen(),
    ),
    GetPage(
      name: signupScreen,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: walkthroughScreen,
      page: () => const WalkthroughScreen(),
    ),
    GetPage(
      name: mainDashBoardScreen,
      page: () => const Dashboard(),
    ),
    GetPage(
      name: twofactorCodeScreen,
      page: () => const TwoFactorScreen(),
    ),
    GetPage(
      name: twofactorConfirmationScreen,
      page: () => const TwoFactorConfirmationScreen(),
    ),
    GetPage(
      name: setNewPasswordScreen,
      page: () => const SetNewPasswordScreen(),
    ),
    GetPage(
      name: searchLeadsScreen,
      page: () => SearchLeadScreen(),
    ),
    GetPage(
      name: leadProfileScreen,
      page: () => LeadProfileScreen(),
    ),
    GetPage(
      name: forgotPasswordScreenAfterLogin,
      page: () => ForgotPasswordScreenAfterLogin(),
    ),
    GetPage(
      name: confirmEmailScreenAfterLogin,
      page: () => ConfirmEmailScreenAfterLogin(),
    ),
    GetPage(
      name: setPasswordScreenAfterLogin,
      page: () => SetPasswordScreenAfterLogin(),
    ),
    GetPage(
      name: biometricPinScreen,
      page: () => BiometricPinScreen(),
    ),
    GetPage(
      name: biometricPinConfirmScreen,
      page: () => BiometricPinConfirmScreen(),
    ),
    GetPage(
      name: confirmEmailScreenForPinReset,
      page: () => ConfirmEmailScreenForPinReset(),
    ),
    GetPage(
      name: leadBasicDetailsScreen,
      page: () => LeadBasicDetailsScreen(),
    ),
    GetPage(
      name: addLeadScreen,
      page: () => AddLeadScreen(),
    ),
    GetPage(
      name: leadContactsScreen,
      page: () => LeadContactsScreen(),
    ),
    GetPage(
      name: uploadFileScreen,
      page: () => UploadFileScreen(),
    ),
    GetPage(
      name: manageTagsScreen,
      page: () => ManageTagsScreen(),
    ),
    GetPage(
      name: leadPersonalDetailsScreen,
      page: () => LeadPersonalDetailsScreen(),
    ),
    GetPage(
      name: leadDependantsScreen,
      page: () => LeadDependantsScreen(),
    ),
    GetPage(
      name: policyDetailsScreen,
      page: () => PolicyDetailsScreen(),
    ),
    GetPage(
      name: enterLeadDetailsScreen,
      page: () => EnterLeadDetailsScreen(),
    ),
  ];
}
