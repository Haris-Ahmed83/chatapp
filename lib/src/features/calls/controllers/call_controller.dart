import 'package:get/get.dart';
import 'dart:async';
import 'package:livekit_client/livekit_client.dart';

class CallController extends GetxController {
  final isInCall = false.obs;
  final callDuration = '00:00'.obs;
  final isMuted = false.obs;
  final isSpeakerOn = false.obs;
  Room? _room;
  LocalAudioTrack? _audioTrack;
  Timer? _timer;
  int _seconds = 0;

  @override
  void onClose() {
    endCall();
    super.onClose();
  }

  Future<void> startCall(String userName) async {
    try {
      final room = Room();
      _room = room;
      _seconds = 0;
      callDuration.value = '00:00';
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _seconds++;
        final min = (_seconds ~/ 60).toString().padLeft(2, '0');
        final sec = (_seconds % 60).toString().padLeft(2, '0');
        callDuration.value = '$min:$sec';
      });

      await room.connect(
        'wss://chatapp-su653f44.livekit.cloud',
        _generateToken(userName),
      );

      _audioTrack = await LocalAudioTrack.create();
      await room.localParticipant?.publishTrack(_audioTrack!);
      isInCall.value = true;
    } catch (e) {
      isInCall.value = true;
    }
  }

  String _generateToken(String name) {
    return name;
  }

  void toggleMute() {
    if (_audioTrack != null) {
      _audioTrack!.enabled = isMuted.value;
    }
    isMuted.toggle();
  }

  void toggleSpeaker() {
    isSpeakerOn.toggle();
  }

  void endCall() {
    _timer?.cancel();
    _audioTrack?.dispose();
    _room?.disconnect();
    _room?.dispose();
    _room = null;
    _audioTrack = null;
    isInCall.value = false;
  }
}
