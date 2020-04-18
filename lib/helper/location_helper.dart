import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyCXo0xj4XqJ0wBgj0P_PvvC_ZZQsYs_xNc';

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&path=fillcolor:0xAA000033%7Ccolor:0xFFFFFF00%7Cenc:}zswFtikbMjJzZ%7CRdPfZ}DxWvBjWpF~IvJnEvBrMvIvUpGtQpFhOQdKpz@bIx{A%7CPfYlvApz@bl@tcAdTpGpVwQtX}i@%7CGen@lCeAda@bjA%60q@v}@rfAbjA%7CEwBpbAd_@he@hDbu@uIzWcWtZoTdImTdIwu@tDaOXw_@fc@st@~VgQ%7C[uPzNtA%60LlEvHiYyLs^nPhCpG}SzCNwHpz@cEvXg@bWdG%60]lL~MdTmEnCwJ[iJhOae@nCm[%60Aq]qE_pAaNiyBuDurAuB}}Ay%60@%7CEKv_@?%7C[qGji@lAhYyH%60@Xiw@tBerAs@q]jHohAYkSmW?aNoaAbR}LnPqNtMtIbRyRuDef@eT_z@mW_Nm%7CB~j@zC~hAyUyJ_U{Z??cPvg@}s@sHsc@_z@cj@kp@YePoNyYyb@_iAyb@gBw^bOokArcA}GwJuzBre@i\tf@sZnd@oElb@hStW{]vv@??kz@~vAcj@zKa%60Atf@uQj_Aee@pU_UrcA&key=$GOOGLE_API_KEY';
  }

  // static Future<String> getPlaceAddress(double lat, double lng) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
  //   final response = await http.get(url);
  //   final coordinates = new Coordinates(lat, lng);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var state = addresses.first.adminArea;
  //   //print(state);
  //   return state;

  //   // return json.decode(response.body)['results']['types']
  //   //     ['administrative_area_level_2']['short_name'];

  //   // String body =
  //   //     '{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","types":["street_address"]}],"status":"OK"}';
  //   // List<dynamic> addressComponents =
  //   //     json.decode(body)['results'][0]['address_components'];
  // String state = addressComponents.firstWhere((entry) =>
  //     entry['types'].contains('administrative_area_level_2'))['short_name'];
  // return state;
  // String address = addressComponents
  //     .firstWhere((entry) => entry['types'].contains('country'))['long_name'];
  // return json.decode(body)['$country'];
  // }
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    var addressBody = response.body;
    List<dynamic> addressComponents =
        json.decode(addressBody)['results'][0]['address_components'];

    String address = addressComponents.firstWhere((entry) =>
        entry['types'].contains('administrative_area_level_1'))['long_name'];
    print(address);
    return address;
    // List<Placemark> placemark =
    //     await Geolocator().placemarkFromCoordinates(lat, lng);

    // var addresses = placemark.first.administrativeArea;
    // //var state = addresses.first.adminArea;
    // print(addresses);
    // return addresses;
  }

  static Future<String> getCounty(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    var addressBody = response.body;
    List<dynamic> addressComponents =
        json.decode(addressBody)['results'][0]['address_components'];

    String address = addressComponents.firstWhere((entry) =>
        entry['types'].contains('administrative_area_level_2'))['long_name'];
    print(address);
    return address;
    // List<Placemark> placemark =
    //     await Geolocator().placemarkFromCoordinates(lat, lng);

    // var addresses = placemark.first.administrativeArea;
    // //var state = addresses.first.adminArea;
    // print(addresses);
    // return addresses;
  }
}
