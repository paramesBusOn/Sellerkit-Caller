// ignore_for_file: public_member_api_docs, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sellerkitcalllog/src/api/orderApi/getOrderQTHApi.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sellerkitcalllog/src/pages/dasboard/widgets/pdfINvoiceDtls.dart';

import '../../../api/customerDetailsApiByStore/getCustomerDtlsbyStore.dart';

class pdfview extends StatefulWidget {
  const pdfview({Key? key}) : super(key: key);

  @override
  State<pdfview> createState() => pdfviewState();
}

class pdfviewState extends State<pdfview> {
  final pdf = pw.Document();
  static List<GetOrderQTLData> data = [];
  static String paymode = '';
  List<GetOrderQTLData> data2 = [];
  // List<DocumentLines> data4 = [];

  static CustomerdetData? customermodeldata;
  List<GetOrderQTLData> data5 = [];
  List<GetOrderQTLData> data6 = [];
  static List<GetOrderDeatilsQTHData>? orderMasterdata2 = [];
  List<GetOrderDeatilsQTHData>? orderMasterdata = [];
  // static List<InvoiceData>? dasa = [];
  String? date = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // Config config = Config();
      data2 = data;

      orderMasterdata = orderMasterdata2;
      log("orderMasterdata::" + data2!.length.toString());

      // date:
      // config.alignDate(orderMasterdata![0].DocDate.toString());
      // dasa = [
      //   InvoiceData(id: 1, invoiceNo: 'invoiceNo', total: 2, totalPayment: 1)
      // ];
    });
  }

  // static List<InvoiceDetails>? dasa = [];
  var name;
  var subject1;
  var subject2;
  var subject3;
  var marks;

  @override
  Widget build(BuildContext context) {
    // initState(){

    // }
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(
          initialPageFormat: PdfPageFormat.a4,
          dynamicLayout: true,
          // pages: [1,2],
          onPageFormatChanged: (PdfPageFormat) {},
          build: (format)
              // => generatePdf(format, 'title'),
              {
            PdfInvoicePdfviewHelper.data2 = data2;
            // PdfInvoicePdfviewHelper.paymode=paymode;
            // PdfInvoicePdfHelper.height=MediaQuery.of(context).size.height;
            // PdfInvoicePdfHelper.width=MediaQuery.of(context).size.width;
            PdfInvoicePdfviewHelper.orderMasterdata = orderMasterdata;
            PdfInvoicePdfviewHelper.customermodeldata = customermodeldata;
            PdfInvoicePdfviewHelper.paymode = paymode;
            return PdfInvoicePdfviewHelper.generatePdf(format, 'title');
          }),
    );
  }

  Future<pw.TtfFont> loadFont() async {
    final ByteData data = await rootBundle.load('Assets/Ingeborg-Regular.ttf');
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.TtfFont(bytes.buffer.asByteData());
  }

  Future<pw.TtfFont> caliberFont() async {
    final ByteData data = await rootBundle.load('Assets/Calibri.ttf');
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.TtfFont(bytes.buffer.asByteData());
  }
}
