library font_awesome_flutter;

import 'package:flutter/widgets.dart';

class IconDataBrands extends IconData {
  const IconDataBrands(int codePoint)
      : super(
    codePoint,
    fontFamily: 'FontAwesomeProBrands',
  );
}

class IconDataSolid extends IconData {
  const IconDataSolid(int codePoint)
      : super(
    codePoint,
    fontFamily: 'FontAwesomeProSolid',
  );
}

class IconDataDuoTone extends IconData {
  const IconDataDuoTone(int codePoint)
      : super(
    codePoint,
    fontFamily: 'FontAwesomeProDuoTone',
  );
}

class IconDataRegular extends IconData {
  const IconDataRegular(int codePoint)
      : super(codePoint, fontFamily: 'FontAwesomeProRegular');
}

class IconDataWebFont extends IconData {
  const IconDataWebFont(int codePoint)
      : super(codePoint, fontFamily: 'FontAwesomeWeb');
}