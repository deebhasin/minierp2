import 'dart:io';

import 'package:flutter/material.dart';

class CompanyLogoName extends StatelessWidget {
  final int sidebarWidth;
  final String companyLogo;
  final String companyName;
  const CompanyLogoName(
      {Key? key,
      required this.sidebarWidth,
      required this.companyLogo,
      required this.companyName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - sidebarWidth),
      height: 50,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
            child: Image.file(File(companyLogo)),
            // child: Image.(
            //   companyLogo,
            //   height: double.infinity,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              companyName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
