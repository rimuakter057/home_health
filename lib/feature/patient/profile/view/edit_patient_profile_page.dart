import 'dart:io';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Your existing imports
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/common/models/profile_patient_model.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/string/app_string.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class EditPatientProfilePage extends StatefulWidget {
  final ProfileModel? profile;

  const EditPatientProfilePage({super.key, this.profile});

  @override
  State<EditPatientProfilePage> createState() => _EditPatientProfilePageState();
}

class _EditPatientProfilePageState extends State<EditPatientProfilePage> {
  CommonController commonController = Get.find<CommonController>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late String initialName;
  late String initialAge;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile?.name ?? "");
    ageController = TextEditingController(
        text: widget.profile?.patientProfile?.age?.toString() ?? "");
    emailController = TextEditingController(text: widget.profile?.email ?? "");

    initialName = widget.profile?.name ?? "";
    initialAge = widget.profile?.patientProfile?.age?.toString() ?? "";
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Initialize the ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Center( // Added center for tablet optimization
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.maxContentWidth, // Limits width on iPad
            ),
            padding: ResponsiveHelper.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              children: [
                // Responsive Profile Avatar
                CustomProfileAvatar(
                  height: ResponsiveHelper.height(68),
                  width: ResponsiveHelper.width(68),
                  localFile: _selectedImage,
                  image: (widget.profile?.profilePicture?.startsWith('/data') == true ||
                      widget.profile?.profilePicture?.startsWith('/storage') == true)
                      ? null
                      : widget.profile?.profilePicture,
                ),

                SizedBox(height: ResponsiveHelper.spacing(12)),

                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.camera_alt,
                    color: AppColors.primaryColor,
                    size: ResponsiveHelper.iconSize(20),
                  ),
                  label: Text(
                    'Upload Photo',
                    style: TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    foregroundColor: AppColors.primaryColor,
                    padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(6)),
                Text(
                  'JPG, PNG or GIF (max 5MB)',
                  style: context.bodySmall.copyWith(fontSize: ResponsiveHelper.fontSize(12)),
                ),
                SizedBox(height: ResponsiveHelper.spacing(24)),

                _InputField(
                  label: 'Full Name',
                  controller: nameController,
                  keyBoardType: TextInputType.text,
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                _InputField(
                  label: 'Age',
                  controller: ageController,
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                _InputField(
                  label: 'Email',
                    mailColor: Colors.grey,
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                SizedBox(height: ResponsiveHelper.spacing(20)),

                // Note box
                Container(
                  padding: ResponsiveHelper.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note :',
                        style: context.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: ResponsiveHelper.fontSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(6)),
                      Text(
                        'Changes to your profile will be saved locally. Your data remains private and secure.',
                        style: context.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: ResponsiveHelper.fontSize(12),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(24)),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: BorderSide(color: AppColors.primaryColor),
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.buttonHeight(14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: ResponsiveHelper.fontSize(16)),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(12)),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       final currentName = nameController.text.trim();
                    //       final currentAge = ageController.text.trim();
                    //
                    //       if (currentName == initialName &&
                    //           currentAge == initialAge &&
                    //           _selectedImage == null) {
                    //         CustomSnackbar.error(
                    //             context: context,
                    //             message: "Please update at least one field before saving"
                    //         );
                    //         return;
                    //       }
                    //
                    //       commonController.updateProfile(
                    //         role: AppStrings.patientRole,
                    //         name: currentName,
                    //         context: context,
                    //         age: int.tryParse(currentAge),
                    //         imageFile: _selectedImage,
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: AppColors.primaryColor,
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: ResponsiveHelper.buttonHeight(14),
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                    //       ),
                    //       elevation: 0,
                    //     ),
                    //     child: Text(
                    //       "Save change",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: ResponsiveHelper.fontSize(16),
                    //       ),
                    //     ),
                    //   ),
                    // ),







                    Expanded(
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: commonController.isLoading.value
                              ? null
                              : () {
                            final currentName = nameController.text.trim();
                            final currentAge = ageController.text.trim();

                            if (currentName == initialName &&
                                currentAge == initialAge &&
                                _selectedImage == null) {
                              CustomSnackbar.error(
                                  //context: context,
                                  message:
                                  "Please update at least one field before saving");
                              return;
                            }

                            commonController.updatePatientProfile(
                              name: currentName,
                              context: context,
                              age: int.tryParse(currentAge),
                              imageFile: _selectedImage,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.buttonHeight(14),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                            ),
                            elevation: 0,
                          ),
                          child: commonController.isLoading.value
                              ? SizedBox(
                            height: ResponsiveHelper.iconSize(18),
                            width: ResponsiveHelper.iconSize(18),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "Save change",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(16),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool? readOnly;
  final Color?mailColor;

  const _InputField({
    required this.label,
    required this.controller,
    required this.keyBoardType,
    this.readOnly, this.mailColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = mailColor ?? AppColors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.labelMedium.copyWith(fontSize: ResponsiveHelper.fontSize(14)),
        ),
        SizedBox(height: ResponsiveHelper.spacing(6)),
        TextFormField(
          style: TextStyle(
            color: textColor, // greyShade এখানে কাজ করবে
            fontSize: ResponsiveHelper.fontSize(14),
          ),
          controller: controller,
          keyboardType: keyBoardType,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.6),
            contentPadding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}