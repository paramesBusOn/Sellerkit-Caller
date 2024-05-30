// ignore_for_file: prefer_const_constructors

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:sellerkitcalllog/helpers/constans.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _pdfViwerState();
}

class _pdfViwerState extends State<TermsAndCondition> {
  PDFDocument? document;
  @override
  void initState() {
    super.initState();
    loadinit();
  }

  loadinit() async {
    document = await PDFDocument.fromAsset(Assets.termsPDF);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(AppLocalizations.of(context)!.termsandCondition),
        centerTitle: true,
      ),
      body: document == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: loadinit(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: Screens.padingHeight(context),
                      width: Screens.width(context),
                      child: PDFViewer(
                        document: document!,
                        //  lazyLoad: false,
                        showPicker: false,
                        showIndicator: true,
                        scrollDirection: Axis.vertical,
                        showNavigation: false,
                      ));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }
}
