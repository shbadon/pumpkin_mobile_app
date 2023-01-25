import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/signup_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/sign_up_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/circle_image_button.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';
import 'package:pumpkin/widgets/toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignupScreenController signupScreenController =
      GetControllers.shared.getSignupScreenController();

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.1, 0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60),
                    Text('Create Account',
                        style: defaultTheme.textTheme.headline1),
                    const SizedBox(height: 4),
                    Text(
                      'Sign up to get started!',
                      style: defaultTheme.textTheme.subtitle2,
                    ),
                    const SizedBox(height: 30),
                    const FormFieldTitle(title: "Name"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.fullnameWithClear,
                        controller: GetControllers.shared
                            .getSignupScreenController()
                            .nameTextEditingController,
                        hintText: "eg: John Doe",
                        key: const Key('name')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Email"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.emailWithClear,
                        controller: GetControllers.shared
                            .getSignupScreenController()
                            .emailTextEditingController,
                        hintText: "eg: johndoe@mail.com",
                        key: const Key('email')),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        checkBoxWidget(),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'I agree with the Terms of Service & Privacy Policy.',
                            style: defaultTheme.textTheme.bodyText2!
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ButtonTypeOne(
                      key: const Key("signup"),
                      buttonText: 'Sign Up',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Check is the Terms and conditions are agreed
                        if (GetControllers.shared
                            .getSignupScreenController()
                            .agreewithTandC
                            .value) {
                          // If Terms and conditions are agreed then check if vorm is validated
                          if (_signUpFormKey.currentState!.validate()) {
                            // If the form is valid, then send value to server and move to next screen
                            Map<String, dynamic> body = SignupSendModel(
                                    fullName: GetControllers.shared
                                        .getSignupScreenController()
                                        .nameTextEditingController
                                        .text,
                                    email: GetControllers.shared
                                        .getSignupScreenController()
                                        .emailTextEditingController
                                        .text
                                        .toLowerCase(),
                                    agreedTerm: 1)
                                .toJson();
                            GetControllers.shared
                                .getSignupScreenController()
                                .signUp(body);
                          }
                        } else {
                          // Show error message if the terms and condition is not agreed
                          showErrorToast(AppLabels.agreeTandCError);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    orWidget(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleImageButton(
                            image: googleIcon,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              GetControllers.shared
                                  .getLoginScreenController()
                                  .handleGoogle(false);
                            }),
                        CircleImageButton(
                            image: facebookIcon,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              GetControllers.shared
                                  .getLoginScreenController()
                                  .facebookLogin();
                            }),
                        CircleImageButton(
                            image: appleIcon,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              GetControllers.shared
                                  .getLoginScreenController()
                                  .handleAppleLogin();
                            }),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                            text: 'Have an account? ',
                            style: defaultTheme.textTheme.subtitle2,
                            children: [
                              TextSpan(
                                text: 'Login',
                                style:
                                    defaultTheme.textTheme.subtitle2!.copyWith(
                                  color: AppColors.orange,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.lightImpact();
                                    Get.toNamed(loginScreen);
                                  },
                              ),
                            ]),
                      ),
                    ),
                    //const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          Obx(() =>
              GetControllers.shared.getSignupScreenController().isLoading.value
                  ? const Loader()
                  : const Offstage())
        ],
      ),
    );
  }

  Widget orWidget() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.black.withOpacity(0.1),
            thickness: 1.5,
            height: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Text('Or Sign Up with', style: defaultTheme.textTheme.bodyText1),
        ),
        Expanded(
          child: Divider(
            color: AppColors.black.withOpacity(0.1),
            thickness: 1.5,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  //terms checkbox
  Widget checkBoxWidget() {
    return Obx(() => SizedBox(
          width: 24.0,
          height: 24.0,
          child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(width: 1.5, color: AppColors.orange),
            ),
            checkColor: AppColors.white,
            activeColor: Colors.orange,
            value: signupScreenController.agreewithTandC.value,
            onChanged: (value) {
              signupScreenController.agreewithTandC.value = value!;
            },
          ),
        ));
  }
}
