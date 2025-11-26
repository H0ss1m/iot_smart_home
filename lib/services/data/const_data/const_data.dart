// import 'dart:ui';

import 'package:iot_smart_home/services/data/const_data/icons.dart';
// import 'package:iot_smart_home/services/language/english.dart';

List livingRoomData = [
  {
    'icon': lightIcon,
    'title': 'light',
    'status': 'on',
    'checkActive': true,
    'isChecked': false, // Change it, need to be dynamic.
    'isNormal': true,
    'isActive':
        false, // Not changing anything her put required to avoid errors.
  },
  {
    'icon': acIcon,
    'title': 'ac',
    'status': 'on',
    'checkActive': true,
    'isChecked': true, // Change it, need to be dynamic.
    'isNormal': true,
    'isActive':
        false, // Not changing anything her put required to avoid errors.
  },
  {
    'icon': windowIcon,
    'title': 'window',
    'status': 'open',
    'checkActive': false,
    'isChecked':
        false, // Not changing anything her put required to avoid errors.
    'isNormal': false,
    'isActive': false, // Change it, need to be dynamic.
  },
  {
    'icon': moistureIcon,
    'title': 'moisture',
    'status': 'on',
    'checkActive': false,
    'isChecked':
        false, // Not changing anything her put required to avoid errors.
    'isNormal': false,
    'isActive': true, // Change it, need to be dynamic
  },
];

List bedroomData = [
  {
    'key': 'light',
    'icon': lightIcon,
    'title': 'light',
    'status': 'on',
    'checkActive': true,
    'isChecked': true, // Change it, need to be dynamic.
    'isNormal': true,
    'isActive': false, // Not changing anything her put required to avoid errors
  },
  {
    'key': 'ac',
    'icon': acIcon,
    'title': 'ac',
    'status': 'off',
    'checkActive': true,
    'isChecked': true, // Change it, need to be dynamic.
    'isNormal': true,
    'isActive': false, // Not changing anything her put required to avoid errors
  },
  {
    'key': 'window',
    'icon': windowIcon,
    'title': 'window',
    'status': 'closed',
    'checkActive': false,
    'isChecked': false, // Change it, need to be dynamic
    'isNormal': false,
    'isActive': true, // Change it, need to be dynamic
  },
];

List kitchenData = [
  {
    'key': 'light',
    'icon': lightIcon,
    'title': 'light',
    'status': 'on',
    'checkActive': true,
    'isChecked': true, // Change it, need to be dynamic.
    'isNormal': true,
    'isActive': false, // Not changing anything her put required to avoid errors
  },
  {
    'key': 'door',
    'icon': mainDoorIcon,
    'title': 'mainDoor',
    'status': 'open',
    'checkActive': false,
    'isChecked': false, // Change it, need to be dynamic
    'isNormal': false,
    'isActive': true, // Change it, need to be dynamic
  },
  {
    'key': 'moisture',
    'icon': moistureIcon,
    'title': 'moisture',
    'status': 'on',
    'checkActive': false,
    'isChecked': false, // Change it, need to be dynamic
    'isNormal': false,
    'isActive': true, // Change it, need to be dynamic
  },
];

var acItem = livingRoomData.firstWhere(
  (item) => item['title'] == 'ac',
  orElse: () => null,
);

void getAcItem() {
  if (acItem != null) {
    bool isAcChecked = acItem['isChecked'];
    print('قيمة isChecked لـ AC هي: $isAcChecked');
  } else {
    print('لم يتم العثور على عنصر بعنوان "ac".');
  }
}
