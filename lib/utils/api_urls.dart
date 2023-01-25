const String baseUrl = 'https://dev-api.pumpkinlab.io/';

const String registerUrl = 'auth/register/add';
const String verifyEmailCodeUrl = 'auth/register/verifyEmailCode';
const String resendEmailCodeUrl =
    'auth/register/resendEmailCode/'; //{sendFor}/{email}
const String sendOtpToMobileUrl = 'auth/register/sendSmsOtp/'; //{email}
const String verifySmsCodeUrl = 'auth/register/verifySmsCode';
const String setUpPasswordUrl = 'auth/register/setUpPassword';
const String setUpProfileUrl = 'auth/register/setupProfile';
const String completeProfileUrl = 'auth/register/completeYourProfile';
const String updateProfilePicture = 'auth/image/update/';
const String addAwardUrl = 'auth/register/addAward';
const String addCertificateUrl = 'auth/register/addCertificate';
const String loginUrl = 'auth/login';
const String appleVerifyUrl = 'auth/apple_verify';
const String facebookVerifyUrl = 'auth/facebook_verify';
const String connectFacebookUrl = 'user/connect_facebook';
const String connectAppleUrl = 'user/connect_apple';
const String googleVerifyUrl = 'auth/google_verify';
const String connectGoogleUrl = 'user/connect_google';
const String getAgentDetailsUrl =
    'auth/register/getAgentDetails/'; //{emailorPhone}
const String getAgentDetailsWithTokenUrl =
    'auth/register/getAgent/'; //{accesstoken}
const String forgotPasswordUrl = 'auth/forgotPassword/'; //{usertype}{email}
const String deleteAwardUrl = 'auth/register/deleteAward/'; //{email}/{awardId}
const String deleteCertificateUrl =
    'auth/register/deleteCertificate/'; //{email}/{certificateID}
const String getAccessTokenUrl = 'auth/applyRefreshToken';
const String enable2FaUrl = 'user/enable_mfa';
const String disable2FaUrl = 'user/disable2FA';
const String check2FaStatusUrl = 'user/chk2FAstatus/';
const String changePasswordUrl = 'user/changePassword';
const String sendForgotPasswordEmailAfterLoginUrl = 'user/sendForgotPswrdEmail';
const String verifyEmailAfterLoginUrl = 'user/verifyEmailAfterLogin';
const String setupPasswordAfterLoginUrl = 'user/setupPswrd';
const String updateUserInfoUrl = 'user/updateUserInfo/';
const String changeEmailAfterLoginUrl = 'user/chgEmailAfterLogin';
const String chgPhoneAfterLoginUrl = 'user/chgPhoneAfterLogin';
const String verifySmsAfterLoginUrl = 'user/verifySmsAfterLogin';
const String enableDeviceAuthUrl = 'user/enableDeviceAuth';
const String generateDigitalTokenUrl = 'user/generateDigitalToken';
const String disableInDeviceAuthUrl = 'user/disableDeviceAuth';
const String getAccessTokenFromDigitalTokenUrl =
    'auth/register/getAccessTokenFrmDigitalToken';
const String sendEmailToExistIdUrl = 'auth/register/sendEmailToExistId/';

// Lead APIs
const String getLeadsUrl = 'customer/lead/all?lead_stage=';
const String searchLead = 'customer/lead/all?name=';
const String getAllLeadCountUrl = 'customer/lead/lead_count';
const String addLeadBasicDetailsUrl = 'customer/lead/create/basic';
const String updateLeadBasicDetailsUrl = 'customer/lead/update/basic/';
const String addLeadImageUploadUrl = 'customer/lead/photo/upload/';
const String updateLeadDepenedentsdUrl = 'customer/lead/UpdateLeadDepenedents/';
const String getLeadDepenedentsdUrl = 'customer/lead/getAllDependents/';
const String addLeadPolicyUrl = 'customer/lead/addLeadPolicy/';
const String updateLeadPolicyUrl = 'customer/lead/updateLeadPolicy/';
const String addContactsUrl = 'customer/lead/update/contact/';
const String deleteLeadUrl = 'customer/lead/delete/'; //{leadId}

// Tags APIs
const String getAllTagsUrl = 'customer/tag';
const String addTagUrl = 'customer/tag';
const String updateTagUrl = 'customer/tag/'; //{id} Tag id
const String deleteTagUrl = 'customer/tag/'; //{id} Tag id

const String addPersonalDetailsUrl = 'customer/lead/update/personal/';
const String addNoteUrl = 'customer/note/';
const String getLeadUrl = 'customer/lead/';
const String enumUrl = 'auth/enum/';
const String getAllNoteUrl = 'customer/note/all/';
const String uploadNoteFileUrl = 'customer/note/file/upload/';
const String addAppointmentUrl = 'customer/appointment/';
const String getAllAppointmentUrl = 'customer/appointment/all/';
const String getActivitiesLedgerUrl =
    'customer/crud/ActivitiesLedger?sort=id,DESC';
const String addContactLeadActivityUrl = 'customer/lead/activity/'; //{leadId}

// Upload lead csv
const String importLeadUrl = 'customer/lead/import_leads';

// Get uploaded files list
const String getUploadedFilesUrl =
    'customer/crud/BulkUploadedFile?sort=id%2CDESC';
const String constUsUrl = 'user/contactus';
