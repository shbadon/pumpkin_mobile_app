import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/login_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/login_screen_send_models.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/circle_image_button.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  int _tabIndex = 0;
  late TabController tabController;

  LoginScreenController loginScreenController =
      GetControllers.shared.getLoginScreenController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        _tabIndex = tabController.index;
      });
      _loginFormKey.currentState!
          .reset(); //When clicked we reset the currentState of the formKey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fourthColor,
      body: Obx(
        () => Stack(
          children: [
            IntrinsicHeight(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height * 0.1, 0, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 60),
                        Text('Login', style: defaultTheme.textTheme.headline1),
                        const SizedBox(height: 4),
                        Text(
                          'Login to get started!',
                          style: defaultTheme.textTheme.subtitle2,
                        ),
                        const SizedBox(height: 30),
                        TabBar(
                          indicatorColor: AppColors.primaryColor,
                          tabs: const [
                            Text(
                              'Email',
                            ),
                            Text('Phone')
                          ],
                          controller: tabController,
                        ),
                        const SizedBox(height: 30),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          child:
                              _tabIndex == 0 ? _emailWidget() : _phoneWidget(),
                        ),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Password"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.passWord,
                            controller: loginScreenController
                                .passwordTextEditingController,
                            hintText: 'Enter password',
                            key: const Key('password')),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.toNamed(forgotPasswordScreen);
                              },
                              child: Text(
                                'Forgot Password',
                                style: defaultTheme.textTheme.bodyText1!
                                    .copyWith(
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline),
                              )),
                        ),
                        const SizedBox(height: 24),
                        ButtonTypeOne(
                          key: const Key("login"),
                          buttonText: 'Login',
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            // context.vRouter.to(confirmEmailScreen);
                            if (_loginFormKey.currentState!.validate()) {
                              // If the form is valid, then send value to server and move to next screen
                              //* Note: If TabIndex is 0 then we pass the emailTextEditingController value and if it is not then we pass the phonenumbertextediting controller value
                              Map<String, dynamic> body = _tabIndex ==
                                      0
                                  ? LoginScreenSendModel(
                                          email:
                                              loginScreenController
                                                  .emailTextEditingController
                                                  .text
                                                  .toLowerCase(),
                                          passowrd:
                                              loginScreenController
                                                  .passwordTextEditingController
                                                  .text,
                                          twoFactorAuthCode: '')
                                      .toJson()
                                  : LoginScreenSendModel(
                                          email:
                                              loginScreenController
                                                      .countryCode +
                                                  loginScreenController
                                                      .phoneTextEditingController
                                                      .text,
                                          passowrd: loginScreenController
                                              .passwordTextEditingController
                                              .text,
                                          twoFactorAuthCode: '')
                                      .toJson();
                              loginScreenController.getAgemtAccountStatus(body);
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                            child: CircleImageButton(
                                image: deviceAuth,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  GetControllers.shared
                                      .getLoginScreenController()
                                      .inDeviceAuthentication();
                                })),
                        const SizedBox(height: 32),
                        orWidget(),
                        const SizedBox(height: 32),
                        // All the socila media authentication buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleImageButton(
                                image: googleIcon,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  loginScreenController.handleGoogle(true);
                                }),
                            CircleImageButton(
                                image: facebookIcon,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  loginScreenController.facebookLogin();
                                }),
                            CircleImageButton(
                                image: appleIcon,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  loginScreenController.handleAppleLogin();
                                }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: defaultTheme.textTheme.subtitle2,
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: defaultTheme.textTheme.subtitle2!
                                        .copyWith(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        HapticFeedback.lightImpact();
                                        Get.toNamed(signupScreen);
                                      },
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const Loader()
            loginScreenController.isLoading.value
                ? const Loader()
                : const Offstage() // Will show loader when loading is true in the controllers
          ],
        ),
      ),
    );
  }

  _emailWidget() {
    return Column(
      key: const ValueKey<int>(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormFieldTitle(title: "Email"),
        const SizedBox(height: 9),
        CustomTextField(
            type: InputFieldTypes.emailWithClear,
            controller: loginScreenController.emailTextEditingController,
            hintText: "Enter email",
            key: const Key('email_phone')),
      ],
    );
  }

  _phoneWidget() {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormFieldTitle(title: "Mobile Number"),
        const SizedBox(height: 9),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryPicker(onCountryCodeSelected: (value) {
              loginScreenController.countryCode = value;
            }),
            const SizedBox(width: 10),
            Expanded(
                child: CustomTextField(
                    type: InputFieldTypes.numberWithClear,
                    controller:
                        loginScreenController.phoneTextEditingController,
                    hintText: "eg: 6784883897",
                    key: const Key('phone'))),
          ],
        ),
      ],
    );
  }
}

Widget orWidget() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color: Colors.black.withOpacity(0.1),
          thickness: 1.5,
          height: 1.5,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text('Or Login with',
            style: defaultTheme.textTheme.bodyText1!
                .copyWith(color: Colors.black.withOpacity(0.25))),
      ),
      Expanded(
        child: Divider(
          color: Colors.black.withOpacity(0.1),
          thickness: 1.5,
          height: 1.5,
        ),
      ),
    ],
  );
}
