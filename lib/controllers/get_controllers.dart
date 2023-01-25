import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/biometric_pin_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/confirm_email_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/confirm_mobile_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/enter_mobile_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/forgot_password_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/login_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/set_password_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/signup_screen_controller.dart';
import 'package:pumpkin/controllers/dashboard_controller.dart';
import 'package:pumpkin/controllers/device_id_controller.dart';
import 'package:pumpkin/controllers/enum_controller.dart';
import 'package:pumpkin/controllers/leads/add_lead_screen_controller.dart';
import 'package:pumpkin/controllers/leads/enter_lead_details_controller.dart';
import 'package:pumpkin/controllers/leads/lead_basic_details_controller.dart';
import 'package:pumpkin/controllers/leads/lead_contacts_controller.dart';
import 'package:pumpkin/controllers/leads/lead_dependants_controller.dart';
import 'package:pumpkin/controllers/leads/lead_personal_detail_controller.dart';
import 'package:pumpkin/controllers/leads/lead_profile_screen_controller.dart';
import 'package:pumpkin/controllers/leads/leads_screen_controller.dart';
import 'package:pumpkin/controllers/leads/manage_tags_screen_controller.dart';
import 'package:pumpkin/controllers/leads/policy_details_screen_controller.dart';
import 'package:pumpkin/controllers/leads/search_leads_screen_controller.dart';
import 'package:pumpkin/controllers/leads/upload_file_screen_controller.dart';
import 'package:pumpkin/controllers/profile/change_password_screen_controller.dart';
import 'package:pumpkin/controllers/profile/complete_profile_screen_controller.dart';
import 'package:pumpkin/controllers/profile/connected_accounts_screen_controller.dart';
import 'package:pumpkin/controllers/profile/my_account_screen_controller.dart';
import 'package:pumpkin/controllers/profile/my_profile_screen_controller.dart';
import 'package:pumpkin/controllers/profile/settings_screen_controller.dart';
import 'package:pumpkin/controllers/profile/setup_profile_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/two_factor_screen_controller.dart';
import 'package:pumpkin/controllers/splash_screen_controller.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/controllers/tags_controller.dart';

// We are to define all the controllers in this GetControllers class. We should
//only access all the controllers through this class as this class will ensure
//the initialization of controllers and if already initialized then it will
//find and share the existing controller

class GetControllers {
  static final GetControllers _singleton = GetControllers._internal();

  factory GetControllers() {
    return _singleton;
  }

  GetControllers._internal();

  static GetControllers get shared => _singleton;

  DashboardController getDashboardController() {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }
    return Get.find<DashboardController>();
  }

  LoginScreenController getLoginScreenController() {
    if (!Get.isRegistered<LoginScreenController>()) {
      Get.put(LoginScreenController());
    }
    return Get.find<LoginScreenController>();
  }

  SignupScreenController getSignupScreenController() {
    if (!Get.isRegistered<SignupScreenController>()) {
      Get.put(SignupScreenController());
    }
    return Get.find<SignupScreenController>();
  }

  ConfirmEmailScreenController getConfirmEmailScreenController() {
    if (!Get.isRegistered<ConfirmEmailScreenController>()) {
      Get.put(ConfirmEmailScreenController());
    }
    return Get.find<ConfirmEmailScreenController>();
  }

  EnterMobileScreenController getEmterMobileScreenController() {
    if (!Get.isRegistered<EnterMobileScreenController>()) {
      Get.put(EnterMobileScreenController());
    }
    return Get.find<EnterMobileScreenController>();
  }

  ConfirmMobileScreenController getConfirmMobileScreenController() {
    if (!Get.isRegistered<ConfirmMobileScreenController>()) {
      Get.put(ConfirmMobileScreenController());
    }
    return Get.find<ConfirmMobileScreenController>();
  }

  SetPasswordScreenController getSetPasswordScreenController() {
    if (!Get.isRegistered<SetPasswordScreenController>()) {
      Get.put(SetPasswordScreenController());
    }
    return Get.find<SetPasswordScreenController>();
  }

  ChangePasswordScreenController getChangePasswordScreenController() {
    if (!Get.isRegistered<ChangePasswordScreenController>()) {
      Get.put(ChangePasswordScreenController());
    }
    return Get.find<ChangePasswordScreenController>();
  }

  SetupProfileScreenController getSetupProfileScreenController() {
    if (!Get.isRegistered<SetupProfileScreenController>()) {
      Get.put(SetupProfileScreenController());
    }
    return Get.find<SetupProfileScreenController>();
  }

  CompleteProfileScreenController getCompleteProfileScreenController() {
    if (!Get.isRegistered<CompleteProfileScreenController>()) {
      Get.put(CompleteProfileScreenController());
    }
    return Get.find<CompleteProfileScreenController>();
  }

  SplashScreenController getSplashScreenController() {
    if (!Get.isRegistered<SplashScreenController>()) {
      Get.put(SplashScreenController());
    }
    return Get.find<SplashScreenController>();
  }

  ForgotPasswordScreenController getForgotpasswordScreenController() {
    if (!Get.isRegistered<ForgotPasswordScreenController>()) {
      Get.put(ForgotPasswordScreenController());
    }
    return Get.find<ForgotPasswordScreenController>();
  }

  LeadsScreenController getLeadListScreenController() {
    if (!Get.isRegistered<LeadsScreenController>()) {
      Get.put(LeadsScreenController());
    }
    return Get.find<LeadsScreenController>();
  }

  SearchLeadsScreenController getLeadsScreenController() {
    if (!Get.isRegistered<SearchLeadsScreenController>()) {
      Get.put(SearchLeadsScreenController());
    }
    return Get.find<SearchLeadsScreenController>();
  }

  SettingsScreenController getSettingsScreenController() {
    if (!Get.isRegistered<SettingsScreenController>()) {
      Get.put(SettingsScreenController());
    }
    return Get.find<SettingsScreenController>();
  }

  MyProfileScreenController getMyProfileScreenController() {
    if (!Get.isRegistered<MyProfileScreenController>()) {
      Get.put(MyProfileScreenController());
    }
    return Get.find<MyProfileScreenController>();
  }

  TwoFactorScreenController getTwoFactorController() {
    if (!Get.isRegistered<TwoFactorScreenController>()) {
      Get.put(TwoFactorScreenController());
    }
    return Get.find<TwoFactorScreenController>();
  }

  StorageController getStorageController() {
    if (!Get.isRegistered<StorageController>()) {
      Get.put(StorageController());
    }
    return Get.find<StorageController>();
  }

  MyAccountScreenController getMyAccountScreenController() {
    if (!Get.isRegistered<MyAccountScreenController>()) {
      Get.put(MyAccountScreenController());
    }
    return Get.find<MyAccountScreenController>();
  }

  AddLeadScreenController getAddLeadScreenController() {
    if (!Get.isRegistered<AddLeadScreenController>()) {
      Get.put(AddLeadScreenController());
    }
    return Get.find<AddLeadScreenController>();
  }

  LeadProfileScreenController getLeadProfileScreenController() {
    if (!Get.isRegistered<LeadProfileScreenController>()) {
      Get.put(LeadProfileScreenController());
    }
    return Get.find<LeadProfileScreenController>();
  }

  LeadBasicDetailsScreenController getLeadBasicDetailsScreenController() {
    if (!Get.isRegistered<LeadBasicDetailsScreenController>()) {
      Get.put(LeadBasicDetailsScreenController());
    }
    return Get.find<LeadBasicDetailsScreenController>();
  }

  EnterLeadDetailsScreenController getEnterLeadDetailsScreenController() {
    if (!Get.isRegistered<EnterLeadDetailsScreenController>()) {
      Get.put(EnterLeadDetailsScreenController());
    }
    return Get.find<EnterLeadDetailsScreenController>();
  }

  LeadContactsScreenController getLeadContactsScreenController() {
    if (!Get.isRegistered<LeadContactsScreenController>()) {
      Get.put(LeadContactsScreenController(), permanent: true);
    }
    return Get.find<LeadContactsScreenController>();
  }

  LeadPersonalDetailsScreenController getLeadPersonalDetailsScreenController() {
    if (!Get.isRegistered<LeadPersonalDetailsScreenController>()) {
      Get.put(LeadPersonalDetailsScreenController(), permanent: true);
    }
    return Get.find<LeadPersonalDetailsScreenController>();
  }

  LeaddependantsScreenController getLeaddependantsScreenController() {
    if (!Get.isRegistered<LeaddependantsScreenController>()) {
      Get.put(LeaddependantsScreenController());
    }
    return Get.find<LeaddependantsScreenController>();
  }

  ConnectedAccountsScreenController getConnectedAccountScreenController() {
    if (!Get.isRegistered<ConnectedAccountsScreenController>()) {
      Get.put(ConnectedAccountsScreenController());
    }
    return Get.find<ConnectedAccountsScreenController>();
  }

  BiometricPinScreenController getBiometricPinScreenController() {
    if (!Get.isRegistered<BiometricPinScreenController>()) {
      Get.put(BiometricPinScreenController());
    }
    return Get.find<BiometricPinScreenController>();
  }

  DeviceIDController getDeviceIdController() {
    if (!Get.isRegistered<DeviceIDController>()) {
      Get.put(DeviceIDController());
    }
    return Get.find<DeviceIDController>();
  }

  ManageTagsScreenController getManageTagsScreenController() {
    if (!Get.isRegistered<ManageTagsScreenController>()) {
      Get.put(ManageTagsScreenController());
    }
    return Get.find<ManageTagsScreenController>();
  }

  PolicyDetailsScreenController getPolicyDetailsController() {
    if (!Get.isRegistered<PolicyDetailsScreenController>()) {
      Get.put(PolicyDetailsScreenController(), permanent: true);
    }
    return Get.find<PolicyDetailsScreenController>();
  }

  TagsController getTagsController() {
    if (!Get.isRegistered<TagsController>()) {
      Get.put(TagsController(), permanent: true);
    }
    return Get.find<TagsController>();
  }

  UploadFileScreenController getUploadFileScreenController() {
    if (!Get.isRegistered<UploadFileScreenController>()) {
      Get.put(UploadFileScreenController(), permanent: true);
    }
    return Get.find<UploadFileScreenController>();
  }

  EnumController getEnumController() {
    if (!Get.isRegistered<EnumController>()) {
      Get.put(EnumController(), permanent: true);
    }
    return Get.find<EnumController>();
  }

}
