import 'dart:convert';

class TargetModal {
  List<TargetData>? targetdata;
  String message;
  bool? status;
  String? exception;
  int? stcode;
  TargetModal(
      {required this.targetdata,
      required this.message,
      required this.status,
      this.exception,
      required this.stcode});
  factory TargetModal.fromJson(Map<String, dynamic> jsons, int stcode) {
    if (jsons["data"] != null) {
      var list = json.decode(jsons["data"]) as List;
      List<TargetData> dataList =
          list.map((data) => TargetData.fromJson(data)).toList();
      return TargetModal(
          targetdata: dataList,
          message: jsons["msg"],
          status: jsons["status"],
          stcode: stcode,
          exception: null);
    } else {
      return TargetModal(
          targetdata: null,
          message: jsons["msg"],
          status: jsons["status"],
          stcode: stcode,
          exception: null);
    }
  }

  factory TargetModal.error(String jsons, int stcode) {
    return TargetModal(
        targetdata: null,
        message: 'Exception',
        status: null,
        stcode: stcode,
        exception: jsons);
  }
}

class TargetData {
  String? tPeriod;
  String? kPI1Title;
  String? kPI1MainValue;
  String? kPI1SubValue;
  String? kPI2Title;
  String? kPI2MainValue;
  String? kPI2SubValue;
  String? kPI3Title;
  String? kPI3MainValue;
  String? kPI3SubValue;
  String? kPI4Title;
  String? kPI4MainValue;
  String? kPI4SubValue;
  TargetData({
    required this.tPeriod,
    required this.kPI1MainValue,
    required this.kPI1SubValue,
    required this.kPI1Title,
    required this.kPI2MainValue,
    required this.kPI2SubValue,
    required this.kPI2Title,
    required this.kPI3MainValue,
    required this.kPI3SubValue,
    required this.kPI3Title,
    required this.kPI4MainValue,
    required this.kPI4SubValue,
    required this.kPI4Title,
  });

  factory TargetData.fromJson(Map<String, dynamic> json) => TargetData(
        tPeriod: json['TPeriod'],
        kPI1MainValue: json['KPI_1_MainValue'],
        kPI1SubValue: json['KPI_1_SubValue'],
        kPI1Title: json['KPI_1_Title'],
        kPI2MainValue: json['KPI_2_MainValue'],
        kPI2SubValue: json['KPI_2_SubValue'],
        kPI2Title: json['KPI_2_Title'],
        kPI3MainValue: json['KPI_3_MainValue'],
        kPI3SubValue: json['KPI_3_SubValue'],
        kPI3Title: json['KPI_3_Title'],
        kPI4MainValue: json['KPI_4_MainValue'],
        kPI4SubValue: json['KPI_4_SubValue'],
        kPI4Title: json['KPI_4_Title'],
      );
}
