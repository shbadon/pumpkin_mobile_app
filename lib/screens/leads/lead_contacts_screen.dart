import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/lead_contacts_controller.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

class LeadContactsScreen extends StatefulWidget {
  const LeadContactsScreen({Key? key}) : super(key: key);

  @override
  State<LeadContactsScreen> createState() => _LeadContactsScreenState();
}

class _LeadContactsScreenState extends State<LeadContactsScreen> {
  LeadContactsScreenController contactsController =
      GetControllers.shared.getLeadContactsScreenController();

  final contactsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    setContactUpdateData();
    super.initState();
  }

  void setContactUpdateData() {
    if (Get.arguments != null && Get.arguments.length == 3) {
      LeadModel leadModel = Get.arguments[2];

      GetControllers.shared.getAddLeadScreenController().leadID.value =
          leadModel.id.toString();

      contactsController.isFromLeadProfile.value = true;

      contactsController.countryCode = leadModel.countryCode ?? "65";
      contactsController.countryCodeLabel = leadModel.countryCodeLabel ?? "SG";
      contactsController.mobileNumberTextEditingController.text =
          leadModel.mobile ?? "";
      contactsController.emailTextEditingController.text =
          leadModel.email ?? "";
      //contactsController.emailTextEditingController.text = leadModel.email ?? "";

      if (leadModel.socialIds != null) {
        contactsController.getSocialId(leadModel.socialIds!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.black,
                            size: 18,
                          ),
                        ),
                        Text('Contacts',
                            style: defaultTheme.textTheme.headline3),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if (contactsFormKey.currentState!.validate()) {
                              // If the form is valid, then send value to server and move to next screen
                              contactsController.save();
                            } else {
                              // Show error message if the terms and condition is not agreed
                              //showErrorToast(AppLabels.fillAllInformation);
                            }
                          },
                          child: Text('Save',
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const FormFieldTitle(title: "Mobile Number"),
                    const SizedBox(height: 9),
                    Form(
                        key: contactsFormKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryPicker(
                              onCountryCodeSelected: (value) {
                                contactsController.countryCode = value;
                              },
                              onCountryLabelSelected: (value) {
                                contactsController.countryCodeLabel = value;
                              },
                              initCountryLabel:
                                  contactsController.countryCodeLabel,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: CustomTextField(
                                    type: InputFieldTypes.numberWithClear,
                                    controller: contactsController
                                        .mobileNumberTextEditingController,
                                    hintText: "eg: 6784883897",
                                    isValidationEnabled: false,
                                    key: const Key('phone'))),
                          ],
                        )),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Email Address"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.emailWithClear,
                        controller:
                            contactsController.emailTextEditingController,
                        isValidationEnabled: false,
                        hintText: "eg: johndoe@mail.com",
                        key: const Key('email')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Whatsapp ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.whatsappTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('whatsapp')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Instagram ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.instagramTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('Instagram')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Facebook ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.facebookTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('Facebook')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Twitter ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.twitterTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('Twitter')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Linkedin ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.linkedinTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('Linkedin')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Telegram ID"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.text,
                        isValidationEnabled: false,
                        controller:
                            contactsController.telegramTextEditingController,
                        hintText: "eg: Doe",
                        key: const Key('Telegram')),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => contactsController.isLoading.value
                ? const Loader()
                : const Offstage(),
          )
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 320,
        height: 52,
        color: AppColors.orange,
      ),
    );
  }

  Widget textFieldWidget() {
    return Container(
      width: 320,
      height: 52,
      color: AppColors.black.withOpacity(0.1),
    );
  }
}
