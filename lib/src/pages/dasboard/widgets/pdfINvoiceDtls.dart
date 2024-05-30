import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:sellerkitcalllog/helpers/Configuration.dart';
import 'package:sellerkitcalllog/helpers/Utils.dart';
import 'package:sellerkitcalllog/src/api/customerDetailsApiByStore/getCustomerDtlsbyStore.dart';
import 'package:sellerkitcalllog/src/api/orderApi/getOrderQTHApi.dart';

class PdfInvoicePdfviewHelper {
//  static dynamic height;
//   static dynamic width;
  static List<GetOrderQTLData> data2 = [];

  static CustomerdetData? customermodeldata;
  static List<GetOrderDeatilsQTHData>? orderMasterdata2 = [];
  static List<GetOrderDeatilsQTHData>? orderMasterdata = [];
  static String paymode = '';
// int i=0;
//  int pageNumber=i+1;
  // static List<InvoiceData>? dasa = [];
  String? date = '';
  static Future<TtfFont> loadFont() async {
    final ByteData data = await rootBundle.load('Assets/Ingeborg-Regular.ttf');
    final Uint8List bytes = data.buffer.asUint8List();
    return TtfFont(bytes.buffer.asByteData());
  }

  static Future<TtfFont> caliberFont() async {
    final ByteData data = await rootBundle.load('Assets/Calibri.ttf');
    final Uint8List bytes = data.buffer.asUint8List();
    return TtfFont(bytes.buffer.asByteData());
  }

  static Future<TtfFont> caliberFontbold() async {
    final ByteData data = await rootBundle.load('Assets/CalibriBold.ttf');
    final Uint8List bytes = data.buffer.asUint8List();
    return TtfFont(bytes.buffer.asByteData());
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<Uint8List> generatePdf(
      PdfPageFormat format, String title) async {
    Config config = Config();
    final TtfFont font = await loadFont();
    final TtfFont Calibrifont = await caliberFont();
    final TtfFont Calibrifontbold = await caliberFontbold();
    final pdf = Document(
      // pageFormat: PdfPageFormat.a4.copyWith(
      //     //  marginBottom: 0,
      //     //     marginLeft: 0,
      //     //     marginRight: PdfPageFormat.cm*0.07,
      //     //     marginTop: 0,
      //         width: PdfPageFormat.a4.width ,
      //     height: PdfPageFormat.a4.height ,

      //      ),
      pageMode: PdfPageMode.none,
    );
// for (int pageNumber = 1; pageNumber <= 10; pageNumber++) {
    pdf.addPage(MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4.copyWith(
        marginBottom: 0,
        marginLeft: 0,
        marginRight: PdfPageFormat.a4.width * 0.07,
        marginTop: 0,
        width: PdfPageFormat.a4.width,
        height: PdfPageFormat.a4.height,
      ),
      header: (context) {
        return buildHeader(
            orderMasterdata, font, Calibrifont, config, Calibrifontbold);
      },
      build: (context) => [
        // SizedBox(height: 1 * PdfPageFormat.cm),
        // buildTitle(invoice),
        buildInvoice(data2, font, Calibrifont, config, Calibrifontbold),
        Padding(
          padding: EdgeInsets.only(left: PdfPageFormat.a4.width * 0.07),
          child: Divider(),
        ),

        buildTotal(orderMasterdata, font, Calibrifont, config, Calibrifontbold),
        buildcontainer(),
      ],
      footer: (context) => buildFooter(context, config, Calibrifont),
    ));
// }

    return pdf.save();
  }

  static Widget buildcontainer() => Expanded(
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: PdfColor.fromHex("#750537"),
                      width: PdfPageFormat.a4.width * 0.07)))));

  static pw.Widget buildHeader(
          List<GetOrderDeatilsQTHData>? orderMasterdata,
          TtfFont font,
          TtfFont Calibrifont,
          Config config,
          TtfFont Calibrifontbold) =>
      // Row(
      //   children: [
      //       Container(
      //    width: PdfPageFormat.a4.width*0.05,

      //    height:PdfPageFormat.a4.marginLeft*0.3,
      //             color: PdfColor.fromHex("#750537"),
      //  ),
      //             SizedBox(width: PdfPageFormat.a4.width*0.05),

      Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: PdfColor.fromHex("#750537"),
                      width: PdfPageFormat.a4.width * 0.07))),
          child: Padding(
              padding: EdgeInsets.only(left: PdfPageFormat.a4.width * 0.07),
              child: Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 1 * PdfPageFormat.cm),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            // color: PdfColors.amber,
                            child: Text(
                              'ORDER',
                              style: TextStyle(
                                  font: font,
                                  // fontWeight:FontWeight.bold,
                                  //  fontStyle: P,
                                  fontSize: 40,
                                  color: PdfColor.fromHex("#750537")),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            // width: width*0.5,
                            //  color: PdfColors.amber,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${customermodeldata!.cardName}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: PdfColor.fromHex("#750537")),
                                  ),
                                  Container(
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerRight,
                                    width: PdfPageFormat.a4.width * 0.5,
                                    child: Text(
                                      '${customermodeldata!.address1}, ${customermodeldata!.address2}, ${customermodeldata!.city}, ${customermodeldata!.state}, ${customermodeldata!.pincode}',
                                      textAlign: TextAlign.right,
                                      maxLines: 3,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerRight,
                                    width: PdfPageFormat.a4.width * 0.5,
                                    child: Text(
                                      ' GSTIN:${customermodeldata!.gstin}',
                                      textAlign: TextAlign.right,
                                      maxLines: 3,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ]),
                    SizedBox(height: 1 * PdfPageFormat.cm),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TO:',
                                    style: TextStyle(
                                        font: Calibrifontbold,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: PdfColor.fromHex("#750537")),
                                  ),
                                  Text(
                                    '  ${orderMasterdata![0].CardName}',
                                    style: TextStyle(
                                      font: Calibrifont,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Container(
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerLeft,
                                    width: PdfPageFormat.a4.width * 0.5,
                                    child: Text(
                                      '  ${orderMasterdata[0].CardCode}',
                                      textAlign: TextAlign.right,
                                      maxLines: 3,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        decoration: TextDecoration.underline,
                                        color: PdfColors.blue,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.5,
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '  ${orderMasterdata[0].Address1},${orderMasterdata[0].Address2}',
                                      textAlign: TextAlign.left,
                                      maxLines: 10,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight:FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   width: width * 0.5,
                                  //   // color: PdfColors.amber,
                                  //   alignment:
                                  //       Alignment.centerLeft,
                                  //   child: Text(
                                  //     '',
                                  //     textAlign: TextAlign.left,
                                  //     maxLines: 10,
                                  //     style: TextStyle(
                                  //       // fontWeight:FontWeight.bold,
                                  //       fontSize: 15,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.5,
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '  ${orderMasterdata[0].area},${orderMasterdata[0].City}',
                                      textAlign: TextAlign.left,
                                      maxLines: 10,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight:FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   width: width * 0.5,
                                  //   // color: PdfColors.amber,
                                  //   alignment:
                                  //       Alignment.centerLeft,
                                  //   child: Text(
                                  //     '',
                                  //     textAlign: TextAlign.left,
                                  //     maxLines: 10,
                                  //     style: TextStyle(
                                  //       // fontWeight:FontWeight.bold,
                                  //       fontSize: 15,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.5,
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '  ${orderMasterdata[0].state},${orderMasterdata[0].Pincode}',
                                      textAlign: TextAlign.left,
                                      maxLines: 10,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight:FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.5,
                                    // color: PdfColors.amber,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '  GSTIN: ${orderMasterdata[0].gst}',
                                      textAlign: TextAlign.left,
                                      maxLines: 10,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight:FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                              width: PdfPageFormat.a4.width * 0.3,
                              // color: PdfColors.amber,
                              child: Column(children: [
                                Row(children: [
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.13,
                                    //  color: PdfColors.red,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order No ',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: PdfPageFormat.a4.width * 0.15,
                                    //  color: PdfColors.red,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ': ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.15,
                                    //  alignment: Alignment.centerLeft,
                                    child: Text(
                                      '#${orderMasterdata[0].OrderNum}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  )
                                ]),
                                Row(children: [
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.13,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order Dt',
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: PdfPageFormat.a4.width * 0.15,
                                    //  color: PdfColors.red,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ': ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.15,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      config.alignDate(orderMasterdata[0].OrderCreatedDate.toString()),
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.13,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sales Person',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: PdfPageFormat.a4.width * 0.15,
                                    //  color: PdfColors.red,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ': ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.15,
                                    //  alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${Utils.firstName}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  )
                                ]),
                                Row(children: [
                                  Container(
                                    width: PdfPageFormat.a4.width * 0.13,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Store',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: PdfPageFormat.a4.width * 0.15,
                                    //  color: PdfColors.red,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ': ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        font: Calibrifontbold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //  alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${orderMasterdata[0].StoreCode}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        font: Calibrifont,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        //  color: PdfColor.fromHex("#750537")
                                      ),
                                    ),
                                  )
                                ]),
                              ]))
                        ]),
                    // ])
                    SizedBox(height: 1 * PdfPageFormat.cm),
                  ])));

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildInvoice(List<GetOrderQTLData> data2, TtfFont font,
      TtfFont Calibrifont, Config config, TtfFont Calibrifontbold) {
    int i = 1;
    final headers = [
      'S.No',
      'Description',
      'Qty',
      'Price',
      "Disc %",
      'Tax %',
      'Total',
    ];
    data2.sort((a, b) => b.BasePrice!.compareTo(a.BasePrice!));
    final data = data2.map((item) {
      double? mrpvalue;
      double? Discount;
      if (item.MRP! > 0.00) {
        double mrp2 = double.parse(item.MRP!.toStringAsFixed(2));

        double tax2 = double.parse(item.TaxCode!.toStringAsFixed(2));
        mrpvalue = mrp2 / (1 + (tax2 / 100));
        log("mrpvalue::$mrpvalue");

        if (item.MRP! > 0.00 || item.Price! > 0.00) {
          // double mrp2=double.parse(item.MRP!.toStringAsFixed(2));
          double Price2 = double.parse(item.Price!.toStringAsFixed(2));
          log("mrp${mrp2}Price2$Price2");

          Discount = ((mrp2 - Price2) / mrp2) * 100;

          log("Discount2222::$Discount");
        } else {
          Discount = 0.00;
          log("Discount::$Discount");
        }
        if (mrpvalue.isNaN || mrpvalue.isInfinite) {
          mrpvalue = 0.0;
        }
        if (Discount.isNaN || Discount.isInfinite) {
          Discount = 0.0;
        }
      } else {
        double mrp2 = double.parse(item.BasePrice!.toStringAsFixed(2));

        double tax2 = double.parse(item.TaxCode!.toStringAsFixed(2));
        mrpvalue = mrp2 / (1 + (tax2 / 100));
        log("mrpvalue0000::$mrpvalue");

        if (item.MRP! > 0.00 || item.Price! > 0.00) {
          // double mrp2=double.parse(item.MRP!.toStringAsFixed(2));
          double Price2 = double.parse(item.Price!.toStringAsFixed(2));
          log("mrp${mrp2}Price2$Price2");

          Discount = ((mrp2 - Price2) / mrp2) * 100;

          log("Discount2222::$Discount");
        } else {
          Discount = 0.00;
          log("Discount::$Discount");
        }
        if (mrpvalue.isNaN || mrpvalue.isInfinite) {
          mrpvalue = 0.0;
        }
        if (Discount.isNaN || Discount.isInfinite) {
          Discount = 0.0;
        }
      }

      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        i++,
        item.ItemName,
        item.Quantity!.toInt(),
        config.slpitCurrencypdf(mrpvalue.round().toStringAsFixed(2)),
        Discount.round().toStringAsFixed(2),
        item.TaxCode!.round().toStringAsFixed(2),
        config
            .slpitCurrencypdf(item.GrossLineTotal!.round().toStringAsFixed(2)),
      ];
    }).toList();

    return Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: PdfColor.fromHex("#750537"),
                    width: PdfPageFormat.a4.width * 0.07))),
        child: Padding(
            padding: EdgeInsets.only(left: PdfPageFormat.a4.width * 0.07),
            child: Table.fromTextArray(
              headers: headers,
              data: data,
              border: null,
              cellStyle: TextStyle(font: Calibrifont, fontSize: 10),
              headerStyle: TextStyle(
                  font: Calibrifontbold,
                  // fontWeight: FontWeight.bold,
                  color: PdfColors.white),
              headerDecoration:
                  BoxDecoration(color: PdfColor.fromHex("#750537")),
              cellHeight: 0.0,
              columnWidths: {
                0: FlexColumnWidth(PdfPageFormat.a4.width * 0.06),
                1: FlexColumnWidth(PdfPageFormat.a4.width * 0.2),
                2: FlexColumnWidth(PdfPageFormat.a4.width * 0.1),
                3: FlexColumnWidth(PdfPageFormat.a4.width * 0.1),
                4: FlexColumnWidth(PdfPageFormat.a4.width * 0.1),
                5: FlexColumnWidth(PdfPageFormat.a4.width * 0.1),
                6: FlexColumnWidth(PdfPageFormat.a4.width * 0.1),
              },
              headerAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.center,
                2: Alignment.centerRight,
                3: Alignment.centerRight,
                4: Alignment.centerRight,
                5: Alignment.centerRight,
                6: Alignment.centerRight,
              },
              cellAlignments: {
                0: Alignment.topCenter,
                1: Alignment.centerLeft,
                2: Alignment.centerRight,
                3: Alignment.centerRight,
                4: Alignment.centerRight,
                5: Alignment.centerRight,
                6: Alignment.centerRight,
              },
            )));
//    Row(children: [
//  Container(
//              width: PdfPageFormat.a4.width*0.05,

//              height:PdfPageFormat.a4.marginLeft*0.3,
//                       color: PdfColor.fromHex("#750537"),
//            ),
//                       SizedBox(width: PdfPageFormat.a4.width*0.05),
//                       Column(children: [

    //                     ])
    //  ]);
  }

  static Widget buildTotal(
      List<GetOrderDeatilsQTHData>? orderMasterdata,
      TtfFont font,
      TtfFont Calibrifont,
      Config config,
      TtfFont Calibrifontbold) {
    //

    return
        //  Row(children: [
        //   Container(
        //            width: PdfPageFormat.a4.width*0.05,

        //            height:PdfPageFormat.a4.marginLeft*0.3,
        //                     color: PdfColor.fromHex("#750537"),
        //          ),
        //                     SizedBox(width: PdfPageFormat.a4.width*0.05),
        Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: PdfColor.fromHex("#750537"),
                        width: PdfPageFormat.a4.width * 0.07))),
            child: Padding(
                padding: EdgeInsets.only(left: PdfPageFormat.a4.width * 0.07),
                child: Column(children: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // color:PdfColors.amber,
                            width: PdfPageFormat.a4.width * 0.50,
                            // color: PdfColors.amber,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text("Terms and Conditions",
                                          style: TextStyle(
                                            font: Calibrifontbold,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ))),
                                  Row(children: [
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        // color: PdfColors.red,
                                        child: Text("Delivery Date",
                                            style: TextStyle(
                                              font: Calibrifontbold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                    Container(
                                        // width: PdfPageFormat.a4.width * 0.15,
                                        // color: PdfColors.red,
                                        child: Text(": ",
                                            style: TextStyle(
                                              font: Calibrifontbold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        // color: PdfColors.red,
                                        child: Text(
                                            config.alignDate(orderMasterdata![0].deliveryduedate.toString()),
                                            style: TextStyle(
                                              font: Calibrifont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                  ]),
                                  Row(children: [
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        child: Text("Payment Due Date",
                                            style: TextStyle(
                                              font: Calibrifontbold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                    Container(
                                        //  width: PdfPageFormat.a4.width * 0.15,
                                        child: Text(": ",
                                            style: TextStyle(
                                              font: Calibrifontbold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        child: Text(
                                            config.alignDate(orderMasterdata[0].PaymentDueDate.toString()),
                                            style: TextStyle(
                                              font: Calibrifont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                  ]),
                                  Row(children: [
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        child: Text("Mode of Payment",
                                            style: TextStyle(
                                              font: Calibrifontbold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ))),
                                    Container(
                                        // width: PdfPageFormat.a4.width * 0.15,
                                        child: Text(": ",
                                            style: TextStyle(
                                              font: Calibrifont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ))),
                                    Container(
                                        width: PdfPageFormat.a4.width * 0.15,
                                        child: Text(paymode,
                                            style: TextStyle(
                                              font: Calibrifont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ))),
                                  ]),
                                ]),
                          ),
                          Container(
                              width: PdfPageFormat.a4.width * 0.25,
                              // color: PdfColors.pink,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: PdfPageFormat.a4.width * 0.20,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width:
                                                  PdfPageFormat.a4.width * 0.10,
                                              // color: PdfColors.amber,
                                              child: Text("  Sub Total",
                                                  style: TextStyle(
                                                    font: Calibrifontbold,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ))),
                                          Container(
                                              // width: PdfPageFormat.a4.width * 0.15,
                                              child: Text(": ",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    font: Calibrifontbold,

                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ))),
                                          Container(
                                              // color: PdfColors.red,
                                              width:
                                                  PdfPageFormat.a4.width * 0.13,
                                              child: Text(
                                                  config.slpitCurrencypdf(orderMasterdata[0].GrossTotal!.round().toStringAsFixed(2)),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    font: Calibrifont,
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ))),
                                          // Text(
                                          //     "${orderMasterdata[0].GrossTotal!.toStringAsFixed(2)}",
                                          //     style: TextStyle(
                                          //       font: Calibrifont,
                                          //       fontSize: 12,
                                          //     )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        child: Row(children: [
                                      // Spacer(flex: 6),
                                      Container(
                                        width: PdfPageFormat.a4.width * 0.2,
                                        // color: PdfColors.red,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: PdfPageFormat.a4.width *
                                                    0.10,
                                                child: Text("  Tax",
                                                    style: TextStyle(
                                                      font: Calibrifontbold,
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ))),
                                            Container(
                                                //  width: PdfPageFormat.a4.width * 0.10,
                                                child: Text(": ",
                                                    style: TextStyle(
                                                      font: Calibrifontbold,
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ))),
                                            Container(
                                              width:
                                                  PdfPageFormat.a4.width * 0.13,
                                              child: Text(
                                                  config.slpitCurrencypdf(orderMasterdata[0].taxAmount!.round().toStringAsFixed(2)),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    font: Calibrifont,
                                                    fontSize: 10,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                                    Container(
                                        child: Row(children: [
                                      // Spacer(flex: 6),
                                      Container(
                                        width: PdfPageFormat.a4.width * 0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: PdfPageFormat.a4.width *
                                                    0.10,
                                                child: Text("  Round off",
                                                    style: TextStyle(
                                                      font: Calibrifontbold,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    ))),
                                            Container(
                                                child: Text(": ",
                                                    style: TextStyle(
                                                      font: Calibrifontbold,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    ))),
                                            Container(
                                              width:
                                                  PdfPageFormat.a4.width * 0.13,
                                              child: Text(
                                                  config.slpitCurrencypdf(orderMasterdata[0].RoundOff!.abs().round().toStringAsFixed(2)),
                                                  // orderMasterdata[0].roundoff!.toStringAsFixed(2)
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    font: Calibrifont,
                                                    fontSize: 10,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                                    Container(
                                        color: PdfColor.fromHex("#750537"),
                                        child: Row(children: [
                                          // Spacer(flex: 6),
                                          Container(
                                            width: PdfPageFormat.a4.width * 0.2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    width:
                                                        PdfPageFormat.a4.width *
                                                            0.10,
                                                    child: Text("  Total",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            font:
                                                                Calibrifontbold,
                                                            fontSize: 10,
                                                            color: PdfColors
                                                                .white))),
                                                Container(
                                                    child: Text(": ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            font:
                                                                Calibrifontbold,
                                                            fontSize: 10,
                                                            color: PdfColors
                                                                .white))),
                                                Container(
                                                  width:
                                                      PdfPageFormat.a4.width *
                                                          0.13,
                                                  child: Text(
                                                      config.slpitCurrencypdf(orderMasterdata[0].DocTotal!.round().toStringAsFixed(2)),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        font: Calibrifont,
                                                        color: PdfColors.white,
                                                        fontSize: 10,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ])),
                                  ])),
                        ]),
                  ),
                ])));

    //  ]) ;
  }

  static Widget buildFooter(context, Config config, TtfFont font) =>
//   Row(children: [
// Container(
//              width: PdfPageFormat.a4.width*0.05,

//              height:PdfPageFormat.a4.marginLeft*0.3,
//                       color: PdfColor.fromHex("#750537"),
//            ),
//                       SizedBox(width: PdfPageFormat.a4.width*0.05),
      Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: PdfColor.fromHex("#750537"),
                      width: PdfPageFormat.a4.width * 0.07))),
          child: Padding(
              padding: EdgeInsets.only(left: PdfPageFormat.a4.width * 0.07),
              child: Column(
                  // cc
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Page ${context.pageNumber} of ${context.pagesCount}",
                              style: TextStyle(font: font, fontSize: 10),
                              textAlign: TextAlign.start),
                          Text(
                            '${Utils.firstName}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              font: font,
                              // fontWeight: FontWeight.bold,
                              fontSize: 10,
                              //  color: PdfColor.fromHex("#750537")
                            ),
                          ),
                          Container(
                            // width: PdfPageFormat.a4.width*0.7,
                            child: Text(
                                'This is a System Generated Document.Signature not Required',
                                textAlign: TextAlign.center,
                                style: TextStyle(font: font, fontSize: 7)),
                          ),
                          Text(config.currentDatepdf(),
                              textAlign: TextAlign.end,
                              style: TextStyle(font: font, fontSize: 10)),
                        ]),

                    SizedBox(height: 1 * PdfPageFormat.mm),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [

                    //     ]),
                    //  SizedBox(height: 1 * PdfPageFormat.mm),

                    // SizedBox(height: 1 * PdfPageFormat.mm),

                    // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
                    //   ],
                    // )
                  ])));

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
// Uint8List uint8list = await file.readAsBytes();
    return file;
  }
}
