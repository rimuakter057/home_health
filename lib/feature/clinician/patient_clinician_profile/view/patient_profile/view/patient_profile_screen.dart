import 'package:ezygut/feature/clinician/home/models/alert_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/symptom_tab.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/profile_header.dart';
import 'package:ezygut/helper/image_handler/image_handler.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/router/routes_name.dart';
import '../../../../../../utils/color/app_colors.dart';
import '../tab/food_log_tab.dart';
import '../tab/overview_tab.dart';
import '../tab/trigger_tab.dart';


class PatientProfilePage extends StatefulWidget {
   PatientProfilePage({super.key, required this.patient});

  final Patient patient;

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Patient Profile'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [


              ProfileHeaderCard(
                image:ImageHandler.imagesHandle(widget.patient.profileImage??"",),
                name: widget.patient.name??"unknown",
                age: widget.patient.email??"..",
             status: '',
                onTapReport: () {
                  context.pushNamed(RouteName.report,
                  extra: widget.patient.id
                  );
                },
                onTapPlan: () {
                  context.pushNamed(RouteName.dietPlanScreen,
                    extra:  widget.patient.id
                  );
                },

              ),
              SizedBox(height: 17),

              TabBar(
                isScrollable: false, // ✅ false করুন
                // tabAlignment: TabAlignment.start, // ✅ এটা সরান
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelStyle: context.labelMedium,
                dividerColor: Colors.white,
                dividerHeight: 1.5,
                indicatorColor: AppColors.primaryColor,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Overview"),
                  Tab(text: "Food log"),
                  Tab(text: "Symptom"),
                //  Tab(text: "Triggers"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    //OverviewTab(),
                    OverviewTab(patientId: widget.patient.id.toString(),),
                    FoodLogTab(patientId: widget.patient.id.toString(),),
                    SymptomTab(patientId: widget.patient.id.toString(),),
                  //  TriggerTab(patientId: widget.patient.id.toString(),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        maxLines: 6,
        decoration: InputDecoration(
          hintText: "Add a clinical note...",
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
