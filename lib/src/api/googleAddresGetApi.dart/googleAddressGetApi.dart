import 'dart:convert';

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:sellerkitcalllog/src/models/serviceApiModel.dart/serviceModel.dart';

class GetgoogleAddressApi {
  PlusCode plusCode;
  List<Result> results;
  String status;
  int? stcode;

  GetgoogleAddressApi({
    this.stcode,
    required this.plusCode,
    required this.results,
    required this.status,
  });
  static Future<GetgoogleAddressApi> getData(String lan, String long) async {
    Responce res = Responce();
    try {
       final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lan,$long&key=AIzaSyAdvVumVzr7teF3UDRchglwonf_vjvXtZo'),
        headers: {
          "content-type": "application/json",
        },
      );
      res.resCode = response.statusCode;
      res.responceBody = response.body;
     
      if (response.statusCode == 200) {
        // Map data = json.decode(response.body);
        return GetgoogleAddressApi.fromJson(
            json.decode(response.body), response.statusCode);
      } else {
        log("Error: ${json.decode(response.body)}");
        throw Exception("Error");
        // return GetgoogleAddressApi.error('Error', resCode);
      }
    } catch (e) {
      log("Exception: $e");
      throw Exception(e.toString());
    }
  }
 
  factory GetgoogleAddressApi.fromJson(Map<String, dynamic> json, int stcode) =>
      GetgoogleAddressApi(
          plusCode: PlusCode.fromJson(json["plus_code"]),
          results:
              List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
          status: json["status"],
          stcode: stcode);

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode.toJson(),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class PlusCode {
  String compoundCode;
  String globalCode;

  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromRawJson(String str) =>
      PlusCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Result {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;
  PlusCode? plusCode;

  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
    this.plusCode,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        types: List<String>.from(json["types"].map((x) => x)),
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "place_id": placeId,
        "types": List<dynamic>.from(types.map((x) => x)),
        "plus_code": plusCode?.toJson(),
      };
}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromRawJson(String str) =>
      AddressComponent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Viewport? bounds;
  Location location;
  String locationType;
  Viewport viewport;

  Geometry({
    this.bounds,
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        bounds:
            json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "bounds": bounds?.toJson(),
        "location": location.toJson(),
        "location_type": locationType,
        "viewport": viewport.toJson(),
      };
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromRawJson(String str) =>
      Viewport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}

class Location {
  double lat;
  double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
