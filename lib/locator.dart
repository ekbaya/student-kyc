import 'package:students_kyc_app/services/camera.service.dart';
import 'package:students_kyc_app/services/ml_service.dart';
import 'package:students_kyc_app/services/face_detector_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator
      .registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
