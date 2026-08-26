// import 'dart:io';
// import 'package:ezygut/feature/common/controller/common_controller.dart';
// import 'package:ezygut/feature/common/models/profile_patient_model.dart';
// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
// import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
// import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
// import 'package:ezygut/utils/app_const/app_const.dart';
// import 'package:ezygut/utils/string/app_string.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../utils/color/app_colors.dart';
// import '../../../../utils/extension/base_extension.dart';
//
// class EditClinicianProfileScreen extends StatefulWidget {
//   final ProfileModel? profile;
//
//   const EditClinicianProfileScreen({super.key, this.profile});
//
//   @override
//   State<EditClinicianProfileScreen> createState() =>
//       _EditClinicianProfileScreenState();
// }
//
// class _EditClinicianProfileScreenState
//     extends State<EditClinicianProfileScreen> {
//   final CommonController commonController = Get.find<CommonController>();
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//
//   late TextEditingController nameController;
//   late TextEditingController specialtyController;
//   late TextEditingController emailController;
//   late String initialName;
//   late String initialSpecialty;
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   nameController = TextEditingController(text: widget.profile?.name ?? "");
//   //   specialtyController = TextEditingController(
//   //     text: widget.profile?.clinicianProfile?.department?.toString() ?? "",
//   //   );
//   //   emailController = TextEditingController(text: widget.profile?.email ?? "");
//   //
//   //   initialName = widget.profile?.name ?? "";
//   //   initialSpecialty =
//   //       widget.profile?.clinicianProfile?.department?.toString() ?? "";
//   // }
//
//
//
//   // ✅ widget.profile বাদ দিয়ে controller থেকে নাও
//   @override
//   void initState() {
//     super.initState();
//     final profile = commonController.profileData.value; // controller থেকে
//
//     nameController = TextEditingController(text: profile?.name ?? "");
//     specialtyController = TextEditingController(
//       text: profile?.clinicianProfile?.department ?? "",
//     );
//     emailController = TextEditingController(text: profile?.email ?? "");
//
//     initialName = profile?.name ?? "";
//     initialSpecialty = profile?.clinicianProfile?.department ?? "";
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     specialtyController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//     await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   void _onSave() {
//     final currentName = nameController.text.trim();
//     final currentSpecialty = specialtyController.text.trim();
//
//     final isNameChanged = currentName != initialName;
//     final isSpecialtyChanged = currentSpecialty != initialSpecialty;
//     final isImageChanged = _selectedImage != null;
//
//     if (!isNameChanged && !isSpecialtyChanged && !isImageChanged) {
//       CustomSnackbar.error(
//         context: context,
//         message: "Please update at least one field before saving",
//       );
//       return;
//     }
//
//     commonController.updateProfile(
//       role: AppStrings.clinicianRole,
//       name: currentName,
//       context: context,
//       department: currentSpecialty,
//       imageFile: _selectedImage,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ResponsiveHelper.init(context);
//
//     return Scaffold(
//       appBar: CustomAppBar(title: "Edit Profile"),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: ResponsiveHelper.all(16),
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: ResponsiveHelper.maxContentWidth,
//             ),
//             padding: ResponsiveHelper.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.4),
//               borderRadius:
//               BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
//               border: Border.all(color: Colors.white),
//             ),
//             child: Column(
//               children: [
//                 // Profile Avatar
//                 CustomProfileAvatar(
//                   height: ResponsiveHelper.height(68),
//                   width: ResponsiveHelper.width(68),
//                   localFile: _selectedImage,
//                   image: (widget.profile?.profilePicture
//                       ?.startsWith('/data') ==
//                       true ||
//                       widget.profile?.profilePicture
//                           ?.startsWith('/storage') ==
//                           true)
//                       ? null
//                       : widget.profile?.profilePicture,
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.spacing(12)),
//
//                 OutlinedButton.icon(
//                   onPressed: _pickImage,
//                   icon: Icon(
//                     Icons.camera_alt,
//                     color: AppColors.primaryColor,
//                     size: ResponsiveHelper.iconSize(20),
//                   ),
//                   label: Text(
//                     'Upload Photo',
//                     style:
//                     TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: AppColors.primaryColor),
//                     foregroundColor: AppColors.primaryColor,
//                     padding: ResponsiveHelper.symmetric(
//                         horizontal: 16, vertical: 8),
//                   ),
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.spacing(6)),
//                 Text(
//                   'JPG, PNG or GIF (max 5MB)',
//                   style: context.bodySmall
//                       .copyWith(fontSize: ResponsiveHelper.fontSize(12)),
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.spacing(24)),
//
//                 _InputField(
//                   label: 'Full Name',
//                   controller: nameController,
//                   keyBoardType: TextInputType.text,
//                 ),
//                 SizedBox(height: ResponsiveHelper.spacing(16)),
//                 _InputField(
//                   label: 'Specialty',
//                   controller: specialtyController,
//                   keyBoardType: TextInputType.text,
//                 ),
//                 SizedBox(height: ResponsiveHelper.spacing(16)),
//                 _InputField(
//                   label: 'Email',
//                   controller: emailController,
//                   keyBoardType: TextInputType.emailAddress,
//                   readOnly: true,
//                   mailColor: Colors.grey,
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.spacing(20)),
//
//                 // Note box
//                 Container(
//                   padding: ResponsiveHelper.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                         ResponsiveHelper.borderRadius(12)),
//                     border: Border.all(color: AppColors.primaryColor),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Note :',
//                         style: context.bodySmall.copyWith(
//                           color: AppColors.primaryColor,
//                           fontSize: ResponsiveHelper.fontSize(14),
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       SizedBox(height: ResponsiveHelper.spacing(6)),
//                       Text(
//                         'Changes to your profile will be saved locally. '
//                             'Your data remains private and secure.',
//                         style: context.bodySmall.copyWith(
//                           color: AppColors.primaryColor,
//                           fontSize: ResponsiveHelper.fontSize(12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.spacing(24)),
//
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: AppColors.primaryColor,
//                           side:
//                           const BorderSide(color: AppColors.primaryColor),
//                           padding:
//                           ResponsiveHelper.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 ResponsiveHelper.borderRadius(10)),
//                           ),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                               fontSize: ResponsiveHelper.fontSize(14)),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: ResponsiveHelper.spacing(12)),
//                     Expanded(
//                       child: Obx(
//                             () => ElevatedButton(
//                           onPressed: commonController.isLoading.value
//                               ? null
//                               : _onSave,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryColor,
//                             padding:
//                             ResponsiveHelper.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   ResponsiveHelper.borderRadius(10)),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: commonController.isLoading.value
//                               ? SizedBox(
//                             height: ResponsiveHelper.height(20),
//                             width: ResponsiveHelper.width(20),
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                               : Text(
//                             "Save Change",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: ResponsiveHelper.fontSize(14),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _InputField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final TextInputType keyBoardType;
//   final bool? readOnly;
//   final Color? mailColor;
//
//   const _InputField({
//     required this.label,
//     required this.controller,
//     required this.keyBoardType,
//     this.readOnly,
//     this.mailColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: context.labelMedium
//               .copyWith(fontSize: ResponsiveHelper.fontSize(12)),
//         ),
//         SizedBox(height: ResponsiveHelper.spacing(6)),
//         TextFormField(
//           style: context.bodyMedium.copyWith(
//             color: mailColor ?? AppColors.black,
//             fontSize: ResponsiveHelper.fontSize(14),
//           ),
//           controller: controller,
//           keyboardType: keyBoardType,
//           readOnly: readOnly ?? false,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.6),
//             contentPadding: ResponsiveHelper.symmetric(
//                 horizontal: 16, vertical: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(
//                   ResponsiveHelper.borderRadius(12)),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }














import 'dart:io';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class EditClinicianProfileScreen extends StatefulWidget {
  const EditClinicianProfileScreen({super.key});

  @override
  State<EditClinicianProfileScreen> createState() =>
      _EditClinicianProfileScreenState();
}

class _EditClinicianProfileScreenState
    extends State<EditClinicianProfileScreen> {
  final CommonController commonController = Get.find<CommonController>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  late TextEditingController nameController;
  late TextEditingController specialtyController;
  late TextEditingController emailController;
  late String initialName;
  late String initialSpecialty;

  @override
  void initState() {
    super.initState();
    final profile = commonController.profileData.value;

    nameController = TextEditingController(text: profile?.name ?? "");
    specialtyController = TextEditingController(
      text: profile?.clinicianProfile?.department ?? "",
    );
    emailController = TextEditingController(text: profile?.email ?? "");

    initialName = profile?.name ?? "";
    initialSpecialty = profile?.clinicianProfile?.department ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    specialtyController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _onSave() {
    final currentName = nameController.text.trim();
    final currentSpecialty = specialtyController.text.trim();

    final isNameChanged = currentName != initialName;
    final isSpecialtyChanged = currentSpecialty != initialSpecialty;
    final isImageChanged = _selectedImage != null;

    if (!isNameChanged && !isSpecialtyChanged && !isImageChanged) {
      CustomSnackbar.error(
       // context: context,
        message: "Please update at least one field before saving",
      );
      return;
    }

    commonController.updateClinicianProfile(
      name: currentName,
      context: context,
      department: currentSpecialty,
      imageFile: _selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // সব জায়গায় controller থেকে profile নাও
    final profile = commonController.profileData.value;

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.maxContentWidth,
            ),
            padding: ResponsiveHelper.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius:
              BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              children: [
                // Profile Avatar — controller থেকে image
                CustomProfileAvatar(
                  height: ResponsiveHelper.height(68),
                  width: ResponsiveHelper.width(68),
                  localFile: _selectedImage,
                  image: (profile?.profilePicture?.startsWith('/data') == true ||
                      profile?.profilePicture?.startsWith('/storage') == true)
                      ? null
                      : profile?.profilePicture,
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
                    side: const BorderSide(color: AppColors.primaryColor),
                    foregroundColor: AppColors.primaryColor,
                    padding:
                    ResponsiveHelper.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(6)),
                Text(
                  'JPG, PNG or GIF (max 5MB)',
                  style: context.bodySmall
                      .copyWith(fontSize: ResponsiveHelper.fontSize(12)),
                ),

                SizedBox(height: ResponsiveHelper.spacing(24)),

                _InputField(
                  label: 'Full Name',
                  controller: nameController,
                  keyBoardType: TextInputType.text,
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                _InputField(
                  label: 'Specialty',
                  controller: specialtyController,
                  keyBoardType: TextInputType.text,
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                _InputField(
                  label: 'Email',
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                  readOnly: true,
                  mailColor: Colors.grey,
                ),

                SizedBox(height: ResponsiveHelper.spacing(20)),

                // Note box
                Container(
                  padding: ResponsiveHelper.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(12)),
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
                        'Changes to your profile will be saved locally. '
                            'Your data remains private and secure.',
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
                          side: const BorderSide(color: AppColors.primaryColor),
                          padding: ResponsiveHelper.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14)),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(12)),
                    Expanded(
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: commonController.isLoading.value
                              ? null
                              : _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: ResponsiveHelper.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(10)),
                            ),
                            elevation: 0,
                          ),
                          child: commonController.isLoading.value
                              ? SizedBox(
                            height: ResponsiveHelper.height(20),
                            width: ResponsiveHelper.width(20),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "Save Change",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(14),
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
  final Color? mailColor;

  const _InputField({
    required this.label,
    required this.controller,
    required this.keyBoardType,
    this.readOnly,
    this.mailColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.labelMedium
              .copyWith(fontSize: ResponsiveHelper.fontSize(12)),
        ),
        SizedBox(height: ResponsiveHelper.spacing(6)),
        TextFormField(
          style: context.bodyMedium.copyWith(
            color: mailColor ?? AppColors.black,
            fontSize: ResponsiveHelper.fontSize(14),
          ),
          controller: controller,
          keyboardType: keyBoardType,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.6),
            contentPadding:
            ResponsiveHelper.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}