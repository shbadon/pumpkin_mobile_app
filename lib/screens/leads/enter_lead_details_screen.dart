import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/enter_lead_details_controller.dart';
import 'package:pumpkin/controllers/tags_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_enum_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_form_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';
import 'package:pumpkin/widgets/loader.dart';

class EnterLeadDetailsScreen extends StatefulWidget {
  const EnterLeadDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EnterLeadDetailsScreen> createState() => _EnterLeadDetailsScreenState();
}

class _EnterLeadDetailsScreenState extends State<EnterLeadDetailsScreen> {
  EnterLeadDetailsScreenController basicDetailsController =
      GetControllers.shared.getEnterLeadDetailsScreenController();
  TagsController tagsController = GetControllers.shared.getTagsController();

  final addDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    tagsController.getAllTagsforAgent();
    super.initState();
  }

  final overlayWidgetController = ExpandableOverlayWidgetController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("ontap:: outside");
        overlayWidgetController.hide();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.back();
                              overlayWidgetController.hide();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.black,
                              size: 18,
                            ),
                          ),
                          Text('Enter Lead Details',
                              style: defaultTheme.textTheme.headline3),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (addDetailsFormKey.currentState!.validate()) {
                                // If the form is valid, then send value to server and move to next screen

                                showPopupAlertDialogForSeedDone(
                                    basicDetailsController
                                        .remarksTextEditingController,
                                    context: context, buttonTap: () {
                                  Get.back();
                                  basicDetailsController.save();
                                });
                              } else {
                                // Show error message if the terms and condition is not agreed
                                //showErrorToast(AppLabels.fillAllInformation);
                              }
                            },
                            child: Text("Skip Now",
                                style: defaultTheme.textTheme.headline5!
                                    .copyWith(color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      color: AppColors.borderColor,
                      child: Text("Basic Details",
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 18),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormFieldTitle(title: "Gender*"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: RadioListTile(
                                  title: Text("Male",
                                      style: defaultTheme.textTheme.bodyText1),
                                  activeColor: AppColors.orange,
                                  value: "male",
                                  contentPadding: EdgeInsets.zero,
                                  groupValue: basicDetailsController.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      basicDetailsController.gender =
                                          value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: RadioListTile(
                                  title: Text("Female",
                                      style: defaultTheme.textTheme.bodyText1),
                                  activeColor: AppColors.orange,
                                  value: "female",
                                  contentPadding: EdgeInsets.zero,
                                  groupValue: basicDetailsController.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      basicDetailsController.gender =
                                          value.toString();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Date of Birth*"),
                          const SizedBox(height: 9),
                          CustomTextField(
                            type: InputFieldTypes.dob,
                            dateFormat: "yyyy-MM-dd",
                            context: context,
                            controller: basicDetailsController
                                .dateOfBirthTextEditingController,
                            hintText: "",
                            //dd-mm-yyyy
                            key: const Key("dateOfBirth"),
                          ),
                          const SizedBox(height: 24),
                          Text("Address",
                              style: defaultTheme.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15),
                          const FormFieldTitle(title: "Zip Code*"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              autoValidate: false,
                              controller: basicDetailsController
                                  .zipCodeTextEditingController,
                              hintText: "Zip Code",
                              key: const Key('Zip Code')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Address line 1"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              controller: basicDetailsController
                                  .addressLine1TextEditingController,
                              hintText: "Address line 1",
                              key: const Key('Address line 1')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Address line 2"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              controller:
                                  basicDetailsController.addressLine2Controller,
                              hintText: "Address line 2",
                              key: const Key('Address line 2')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Country*"),
                          const SizedBox(height: 9),
                          DropdownFormField(
                              overlayWidgetController: overlayWidgetController,
                              list: GetControllers.shared.getEnumController().countryList,
                              selectedValueController: basicDetailsController
                                  .countryTextEditingController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      color: AppColors.borderColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Contacts",
                              style: defaultTheme.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 15),
                          Text("One Contact field is mandatory",
                              style: defaultTheme.textTheme.bodyText2!
                                  .copyWith(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormFieldTitle(title: "Mobile Number"),
                          const SizedBox(height: 9),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryPicker(
                                onCountryCodeSelected: (value) {
                                  basicDetailsController.countryCode = value;
                                },
                                onCountryLabelSelected: (value) {
                                  basicDetailsController.countryCodeLabel =
                                      value;
                                },
                                initCountryLabel:
                                    basicDetailsController.countryCodeLabel,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: CustomTextField(
                                      type: InputFieldTypes.numberWithClear,
                                      controller: basicDetailsController
                                          .mobileNumberTextEditingController,
                                      hintText: "eg: 6784883897",
                                      isValidationEnabled: false,
                                      key: const Key('phone'))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Email Address"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.emailWithClear,
                              controller: basicDetailsController
                                  .emailTextEditingController,
                              isValidationEnabled: false,
                              hintText: "eg: johndoe@mail.com",
                              key: const Key('email')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Whatsapp ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .whatsappTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('whatsapp')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Instagram ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .instagramTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('Instagram')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Facebook ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .facebookTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('Facebook')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Twitter ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .twitterTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('Twitter')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Linkedin ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .linkedinTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('Linkedin')),
                          const SizedBox(height: 24),
                          const FormFieldTitle(title: "Telegram ID"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .telegramTextEditingController,
                              hintText: "eg: Doe",
                              key: const Key('Telegram')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      color: AppColors.borderColor,
                      child: Text("Policy Details",
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormFieldTitle(title: "Policy Number"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .policyNumberTextEditingController,
                              hintText: "",
                              key: const Key('policyNumber')),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "Policy Name"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.text,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .policyNameTextEditingController,
                              hintText: "",
                              key: const Key('policyName')),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "Annual Premium"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.money,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .annualPremiumTextEditingController,
                              hintText: "",
                              key: const Key('annualPremium')),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "FYC"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.numberWithClear,
                              isValidationEnabled: false,
                              controller: basicDetailsController
                                  .fycTextEditingController,
                              hintText: "",
                              key: const Key('fyc')),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "Payment Mode"),
                          const SizedBox(height: 9),
                          DropdownEnumField(
                              overlayWidgetController: overlayWidgetController,
                              list: GetControllers.shared
                                  .getEnumController()
                                  .paymentModeList
                                  .value,
                              initialEnum: basicDetailsController
                                  .selectedPaymentMode.value),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "Application Date"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              context: context,
                              type: InputFieldTypes.date,
                              controller: basicDetailsController
                                  .applicationDateTextEditingController,
                              hintText: "",
                              dateFormat: "yyyy-MM-dd",
                              key: const Key('applicationDate')),
                          const SizedBox(height: 18),
                          const FormFieldTitle(title: "Remarks"),
                          const SizedBox(height: 9),
                          CustomTextField(
                              type: InputFieldTypes.textArea,
                              controller: basicDetailsController
                                  .remarksTextEditingController,
                              hintText: "",
                              key: const Key('remarks')),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              checkBoxWidget(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Indication of Inforce',
                                  style: defaultTheme.textTheme.bodyText2!
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          ButtonTypeOne(
                            key: const Key("Save"),
                            buttonText: 'Save',
                            onPressed: () {
                              HapticFeedback.lightImpact();
                            },
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => basicDetailsController.isLoading.value
                  ? const Loader()
                  : const Offstage(),
            )
          ],
        ),
      ),
    );
  }

  Widget checkBoxWidget() {
    return Obx(() => SizedBox(
          width: 24.0,
          height: 24.0,
          child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
              (states) =>
                  const BorderSide(width: 1.5, color: AppColors.primaryColor),
            ),
            checkColor: AppColors.white,
            activeColor: AppColors.orange,
            value: basicDetailsController.indicationOfInforceisChecked.value,
            onChanged: (value) {
              basicDetailsController.indicationOfInforceisChecked.value =
                  value!;
            },
          ),
        ));
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

