import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:permission_handler/permission_handler.dart';

class StatusController extends GetxController {
  final myStatuses = <Map<String, dynamic>>[].obs;
  final uploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMyStatuses();
  }

  void _loadMyStatuses() {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null) return;
    AppConfig.firestore
        .collection('statuses')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snap) {
      myStatuses.value = snap.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }).toList();
    });
  }

  Future<void> pickAndUploadStatus({bool useCamera = false}) async {
    final photoPermission = await Permission.photos.request();
    if (!photoPermission.isGranted && !useCamera) {
      Get.snackbar('Permission denied', 'Gallery permission is required');
      return;
    }

    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted && useCamera) {
      Get.snackbar('Permission denied', 'Camera permission is required');
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (file == null) return;

    uploading.value = true;
    try {
      final uid = AppConfig.auth.currentUser?.uid;
      if (uid == null) return;

      final fileName = 'statuses/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = AppConfig.storage.ref(fileName);
      final uploadTask = await ref.putData(await file.readAsBytes());
      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      await AppConfig.firestore.collection('statuses').add({
        'uid': uid,
        'image_url': downloadUrl,
        'caption': 'Status update',
        'timestamp': FieldValue.serverTimestamp(),
        'expires_at': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
      });

      Get.snackbar('Status uploaded', 'Your status has been posted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload status: $e');
    } finally {
      uploading.value = false;
    }
  }
}
