// ignore_for_file: camel_case_types, unused_element

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/constant/constant.dart';
import 'package:voxxie/core/extensions/context.extension.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildBody(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: logoColor),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              height: context.dynamicHeight(0.5),
              width: context.dynamicWidth(1),
              child: SfPdfViewer.asset(
                ApplicationConstants.POLICY_EN_PATH,
                canShowScrollStatus: true,
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              height: context.dynamicHeight(0.5),
              width: context.dynamicWidth(1),
              child: SfPdfViewer.asset(
                ApplicationConstants.POLICY_TR_PATH,
                canShowScrollStatus: true,
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.1)),
          ],
        ),
      ),
    );
  }
}
