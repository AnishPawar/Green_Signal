import 'package:green_route/helpers/requesthelper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:green_route/widgets/globalvariable.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(Position position) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
