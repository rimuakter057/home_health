import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/filter_chips/app_filter_chips.dart';
import '../../../../utils/enum/app_enum.dart';
import '../../../../utils/extension/base_extension.dart';
import '../model/patient_model.dart' show PatientModel;

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  PatientStatus selectedStatus = PatientStatus.all;

  final List<PatientModel> patients = [

  ];

  List<PatientModel> get filteredPatients {
    if (selectedStatus == PatientStatus.all) {
      return patients;
    }
    return patients.where((p) => p.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: ResponsiveHelper.spacing(12)),

        /// 🔥 REUSABLE FILTER CHIPS
        Padding(
          padding: ResponsiveHelper.symmetric(horizontal: 16),
          child: AppFilterChips<PatientStatus>(
            items: PatientStatus.values,
            selectedItem: selectedStatus,
            labelBuilder: (status) =>
            status.name[0].toUpperCase() + status.name.substring(1),
            backgroundColor: AppColors.white.withOpacity(.3),
            selectedBackgroundColor: AppColors.primaryColor,
            borderColor: AppColors.white,
            textStyle: context.labelMedium.copyWith(
              fontSize: ResponsiveHelper.fontSize(12),
            ),
            selectedTextStyle: context.labelMedium.copyWith(
              color: AppColors.white,
              fontSize: ResponsiveHelper.fontSize(12),
            ),
            onChanged: (status) {
              setState(() {
                selectedStatus = status;
              });
            },
          ),
        ),

        SizedBox(height: ResponsiveHelper.spacing(16)),

        /// 🔥 PATIENT LIST
        Expanded(
          child: ListView.builder(
            padding: ResponsiveHelper.symmetric(horizontal: 16),
            itemCount: filteredPatients.length,
            itemBuilder: (context, index) {
              final patient = filteredPatients[index];
              return PatientCard(patient: patient);
            },
          ),
        ),
      ],
    );
  }
}



class PatientCard extends StatelessWidget {
  final PatientModel patient;

  const PatientCard({super.key, required this.patient});

  Color getStatusColor() {
    switch (patient.status) {
      case PatientStatus.stable:
        return Colors.green;
      case PatientStatus.atRisk:
        return Colors.orange;
      case PatientStatus.FlareUp:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    switch (patient.status) {
      case PatientStatus.stable:
        return "Stable";
      case PatientStatus.atRisk:
        return "At Risk";
      case PatientStatus.FlareUp:
        return "Flare-up";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.borderRadius(26),
                backgroundColor: AppColors.primaryColor,
                child: CircleAvatar(
                  radius: ResponsiveHelper.borderRadius(24),
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150',
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),
              Expanded(
                child: Text(
                  patient.name,
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              ),
              Icon(
                  Icons.access_time,
                  color: AppColors.icon,
                  size: ResponsiveHelper.iconSize(14)
              ),
              SizedBox(width: ResponsiveHelper.spacing(4)),
              Text(
                  patient.time,
                  style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(12)
                  )
              ),
              SizedBox(width: ResponsiveHelper.spacing(8)),
              Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryColor,
                  size: ResponsiveHelper.iconSize(24)
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(10)),

          Row(
            children: [
              Container(
                padding: ResponsiveHelper.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(8)
                  ),
                ),
                child: Text(
                  getStatusText(),
                  style: TextStyle(
                      color: getStatusColor(),
                      fontSize: ResponsiveHelper.fontSize(11)
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(10)),
              Text(
                "${patient.age} yrs",
                style: context.bodySmall.copyWith(
                    color: AppColors.primaryColor.withOpacity(.8),
                    fontSize: ResponsiveHelper.fontSize(12)
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(14)),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(.30),
                    elevation: 0,
                    padding: ResponsiveHelper.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(8)
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(RouteName.report);
                  },
                  child: Icon(
                    Icons.report_outlined,
                    color: AppColors.primaryColor,
                    size: ResponsiveHelper.iconSize(24),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),

              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(.30),
                    elevation: 0,
                    padding: ResponsiveHelper.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(8)
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(RouteName.dietPlanAddScreen);
                  },
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryColor,
                    size: ResponsiveHelper.iconSize(24),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}