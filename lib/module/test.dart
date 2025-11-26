import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:iot_smart_home/services/data/const_data/icons.dart';
import 'package:iot_smart_home/view/widgets/combonent_container.dart';

// @Preview(name: 'test')
Widget test() {
  return Container();
}

@Preview(
    name: 'Livingroom Content',
  )
  Widget livingroomContent() {
    return ListView(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: combonentContainer(
                icon: lightIcon,
                text: 'Light',
                status: 'on', // Change to dynamic
                checkActive: true,
                isNormal: true,
                isActive: true, // Change to dynamic
                isChecked: true, // Change to dynamic
                onTap: (state) => print(state),
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: acIcon,
                text: 'Air Conditioner',
                status: 'on', // Change to dynamic
                checkActive: true,
                isNormal: true,
                isActive: true, // Change to dynamic
                // isChecked: true, // Change to dynamic
                onTap: (state) => print(state),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: combonentContainer(
                icon: windowIcon,
                text: 'Window',
                status: 'on', // Change to dynamic
                checkActive: false,
                isNormal: false,
                isActive: true, // Change to dynamic
                isChecked: true, // Change to dynamic
                onTap: (state) => print(state),
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: moistureIcon,
                text: 'Moisture',
                status: 'on', // Change to dynamic
                checkActive: true,
                isNormal: true,
                isActive: true, // Change to dynamic
                isChecked: true, // Change to dynamic
                onTap: (state) => print(state),
              ),
            ),
          ],
        )
      ],
    );
  }