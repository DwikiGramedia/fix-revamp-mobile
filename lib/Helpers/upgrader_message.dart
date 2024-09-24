import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  String code = 'id';
  MyUpgraderMessages({required this.code});

  @override
  String message(UpgraderMessage messageKey) {
    if (code == 'id') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'Untuk menikmati pengalaman terbaik, silakan perbarui aplikasi Anda ke versi terbaru sekarang. Ketuk "Perbarui" di bawah ini untuk memulai!';
        case UpgraderMessage.buttonTitleIgnore:
          return 'Hiraukan';
        case UpgraderMessage.buttonTitleLater:
          return 'Ingatkan Saya Nanti';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Perbarui Sekarang';
        case UpgraderMessage.prompt:
          return '';
        case UpgraderMessage.releaseNotes:
          return 'Release Notes';
        case UpgraderMessage.title:
          return 'Pembaruan Tersedia';
      }
    }
    if (code == 'en') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return "To enjoy the best experience, please update your app to the latest version now. Tap 'Update' below to get started!";
        case UpgraderMessage.buttonTitleIgnore:
          return 'Ignore';
        case UpgraderMessage.buttonTitleLater:
          return 'Remind Me Later';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Update Now';
        case UpgraderMessage.prompt:
          return '';
        case UpgraderMessage.releaseNotes:
          return 'Release Notes';
        case UpgraderMessage.title:
          return 'Update Available';
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey)!;
  }
}