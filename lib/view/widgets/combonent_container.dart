import 'package:flutter/material.dart';
import 'package:iot_smart_home/model/colors.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

Widget combonentContainer({
  required IconData icon,
  required String text,
  required String status,
  required bool checkActive,
  required bool isNormal,
  required bool isActive,
  required dynamic Function(bool?)? onTap,
  bool isChecked = false,
  Color backIconColor = const Color(0xff334155),
  Color iconColor = const Color(0xffffffff),
  Color titleColor = const Color(0xffffffff),
  Color statusColor = const Color(0xffffffff),
}) {
  return Container(
    padding: EdgeInsets.all(10),
    // width: 50,
    decoration: BoxDecoration(
      color: const Color.from(alpha: 1, red: 0.086, green: 0.114, blue: 0.192),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      spacing: 10,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isNormal
                    ? backIconColor
                    : isActive
                    ? backActiveColor
                    : backWarningColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isNormal
                    ? Colors.white
                    : isActive
                    ? activeColor
                    : warningColor,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 15,
                    color: isNormal
                        ? Colors.white
                        : isActive
                        ? activeColor
                        : warningColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        checkActive
            ? RoundCheckBox(onTap: onTap, isChecked: isChecked)
            : Container(),
      ],
    ),
  );
}
