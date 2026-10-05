import 'package:flutter/material.dart';

import '../lists/ayah_by_ayah_list.dart';

class AyahByAyahPage extends StatelessWidget {
  final int pageNumber;

  const AyahByAyahPage({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) => AyahByAyahList(
    pageNumber: pageNumber,
    rows: const [],
  );
}
