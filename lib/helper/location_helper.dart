import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyCXo0xj4XqJ0wBgj0P_PvvC_ZZQsYs_xNc';

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var state = addresses.first.adminArea;
    //print(state);
    return state;

    // return json.decode(response.body)['results']['types']
    //     ['administrative_area_level_2']['short_name'];

    // String body =
    //     '{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","types":["street_address"]}],"status":"OK"}';
    // List<dynamic> addressComponents =
    //     json.decode(body)['results'][0]['address_components'];
    // String state = addressComponents.firstWhere((entry) =>
    //     entry['types'].contains('administrative_area_level_2'))['short_name'];
    // return state;
    // String address = addressComponents
    //     .firstWhere((entry) => entry['types'].contains('country'))['long_name'];
    // return json.decode(body)['$country'];
  }
}
