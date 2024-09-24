import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AppTrackingHelper{
  var isAllowedTracking = false;

  void requestTracking()async{
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    switch (status){
      case TrackingStatus.denied:
      isAllowedTracking = false;
      break;
      case TrackingStatus.authorized:
      isAllowedTracking = true;
      break;
      case TrackingStatus.restricted:
      isAllowedTracking = false;
      break;
      default:
      isAllowedTracking = false;
      break;
    }
  }
}