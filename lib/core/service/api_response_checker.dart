import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/storage_service.dart' show SharePrefsHelper;
import 'package:ezygut/share/widgets/toast_message/toast_message.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:get/get.dart';



class ApiResponseChecker {
  static void checkApi(Response? response, {bool getXSnackBar = false}) async {
    if (response == null || response.body == null) {
      showCustomSnackBar("Something went wrong", isError: true);
      return;
    }

    if (response.statusCode == 401) {
      await SharePrefsHelper.remove(AppConst.token);
      Get.offAllNamed(RouteName.authPatient);
    } else {
      final message = response.body['message'] ?? "Something went wrong";
      showCustomSnackBar(message, isError: true);
    }
  }
}