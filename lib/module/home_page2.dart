import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/model/colors.dart';
import 'package:iot_smart_home/services/data/const_data/icons.dart';
import 'package:iot_smart_home/services/data/state_management/home_controller.dart';
import 'package:iot_smart_home/view/widgets/combonent_container.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f172a),
        elevation: 0,
        title: const Text(
          'My Flat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Notification Banner
            Obx(
              () => Visibility(
                visible: controller.alarmActive.value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bacContentContainers,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: warningColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        controller.alarmMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Livingroom Section
            _buildSectionHeader(
              title: 'Livingroom',
              onPressed: () {
                Get.toNamed('/livingroom');
              },
            ),
            const SizedBox(height: 12),
            Obx(() => _livingroomContent(controller)),
            const SizedBox(height: 24),

            // Bedroom Section
            _buildSectionHeader(
              title: 'Bedroom',
              onPressed: () {
                Get.toNamed('/bedroom');
              },
            ),
            const SizedBox(height: 12),
            Obx(() => _bedroomContent(controller)),
            const SizedBox(height: 24),

            // Kitchen Section
            _buildSectionHeader(
              title: 'Kitchen',
              onPressed: () {
                Get.toNamed('/kitchen');
              },
            ),
            const SizedBox(height: 12),
            Obx(() => _kitchenContent(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required Function() onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'View All',
            style: TextStyle(color: const Color(0xFF2196F3)),
          ),
        ),
      ],
    );
  }

  Widget _livingroomContent(HomeController controller) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: combonentContainer(
                icon: lightIcon,
                text: 'Light',
                status: controller.livingroomLight.value ? 'on' : 'off',
                checkActive: true,
                isNormal: false,
                isActive: controller.livingroomLight.value,
                isChecked: controller.livingroomLight.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setLivingroomLight(state);
                  }
                },
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: acIcon,
                text: 'AC',
                status: controller.livingroomAc.value ? 'on' : 'off',
                checkActive: true,
                isNormal: false,
                isActive: controller.livingroomAc.value,
                isChecked: controller.livingroomAc.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setLivingroomAc(state);
                  }
                },
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
                icon: mainDoorIcon,
                text: 'Door',
                status: controller.livingroomDoor.value ? 'Open' : 'Closed',
                checkActive: false,
                isNormal: false,
                isActive: !controller.livingroomDoor.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setLivingroomDoor(state);
                  }
                },
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: moistureIcon,
                text: 'Moisture',
                status: controller.livingroomMoisture.value >= 60
                    ? 'High'
                    : 'Normal',
                checkActive: false,
                isNormal: false,
                isActive: controller.livingroomMoisture.value >= 60
                    ? false
                    : true,
                onTap: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bedroomContent(HomeController controller) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: combonentContainer(
                icon: lightIcon,
                text: 'Light',
                status: controller.bedroomLight.value ? 'on' : 'off',
                checkActive: true,
                isNormal: false,
                isActive: controller.bedroomLight.value,
                isChecked: controller.bedroomLight.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setBedroomLight(state);
                  }
                },
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: acIcon,
                text: 'AC',
                status: controller.bedroomAc.value ? 'on' : 'off',
                checkActive: true,
                isNormal: false,
                isActive: controller.bedroomAc.value,
                isChecked: controller.bedroomAc.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setBedroomAc(state);
                  }
                },
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
                icon: moistureIcon,
                text: 'Moisture',
                status: controller.bedroomMoisture.value >= 60
                    ? 'High'
                    : 'Normal',
                checkActive: false,
                isNormal: false,
                isActive: controller.bedroomMoisture.value >= 60 ? false : true,
                onTap: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kitchenContent(HomeController controller) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: combonentContainer(
                icon: lightIcon,
                text: 'Light',
                status: controller.kitchenLight.value ? 'on' : 'off',
                checkActive: true,
                isNormal: false,
                isActive: controller.kitchenLight.value,
                isChecked: controller.kitchenLight.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setKitchenLight(state);
                  }
                },
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
                icon: mainDoorIcon,
                text: 'Door',
                status: controller.kitchenDoor.value ? 'Open' : 'Closed',
                checkActive: false,
                isNormal: false,
                isActive: !controller.kitchenDoor.value,
                onTap: (state) {
                  if (state != null) {
                    controller.setKitchenDoor(state);
                  }
                },
              ),
            ),
            Expanded(
              child: combonentContainer(
                icon: moistureIcon,
                text: 'Moisture',
                status: controller.kitchenMoisture.value >= 60
                    ? 'High'
                    : 'Normal',
                checkActive: false,
                isNormal: false,
                isActive: controller.kitchenMoisture.value >= 60 ? false : true,
                onTap: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
