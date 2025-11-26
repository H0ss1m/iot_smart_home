import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/model/colors.dart';
import 'package:iot_smart_home/services/data/const_data/icons.dart';
import 'package:iot_smart_home/services/data/state_management/home_controller.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Notification Banner
            _buildNotificationBanner(controller),
            const SizedBox(height: 24),
            // Status Overview
            _buildSectionTitle('Status Overview'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildStatusCard(
                      icon: mainDoorIcon,
                      title: 'Door',
                      isOpen: controller.kitchenDoor.value,
                      onToggle: (value) => controller.setKitchenDoor(value),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => _buildStatusCard(
                      icon: windowIcon,
                      title: 'Window',
                      isOpen: controller.kitchenWindow.value,
                      onToggle: (value) => controller.setKitchenWindow(value),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Controls
            _buildSectionTitle('Controls'),
            const SizedBox(height: 12),
            Obx(() => _buildMainLightControl(controller)),
            const SizedBox(height: 24),

            // Sensors
            _buildSectionTitle('Sensors'),
            const SizedBox(height: 12),
            Obx(() => _buildMoistureCard(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        Get.context!,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required bool isOpen,
    required ValueChanged<bool> onToggle,
  }) {
    final Color statusColor = isOpen ? warningColor : activeColor;
    final String statusText = isOpen ? 'Open' : 'Closed';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: statusColor, size: 26),
              ),
              _buildCustomSwitch(
                value: isOpen,
                onChanged: onToggle,
                activeColor: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 15,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainLightControl(HomeController controller) {
    final Color onColor = const Color(0xFF3B82F6);
    final bool isOn = controller.kitchenLight.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOn ? onColor.withOpacity(0.2) : disableIconBack,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  lightIcon,
                  color: isOn ? onColor : Colors.grey.shade400,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Main Lights',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isOn ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 14,
                      color: isOn ? onColor : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildCustomSwitch(
            value: isOn,
            onChanged: (value) => controller.setKitchenLight(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
  }) {
    final Color switchActiveColor = activeColor ?? const Color(0xFF3B82F6);
    final Color inactiveColor = Colors.grey.shade700;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 52,
        height: 30,
        decoration: BoxDecoration(
          color: value ? switchActiveColor : inactiveColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 24 : 2,
              top: 2,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoistureCard(HomeController controller) {
    final double moisturePercent = controller.kitchenMoisture.value.clamp(
      0,
      100,
    );
    final bool isNormal = moisturePercent < 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  moistureIcon,
                  color: Colors.white70,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Moisture Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                isNormal ? 'Normal' : 'High',
                style: TextStyle(
                  fontSize: 15,
                  color: isNormal ? activeColor : warningColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 14,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueGrey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: moisturePercent / 100,
                      strokeWidth: 14,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B82F6),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Text(
                    '${moisturePercent.toInt()}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner(HomeController controller) {
    return Obx(() {
      final bool hasOpenWindow = controller.kitchenWindow.value;
      final bool hasOpenDoor = controller.kitchenDoor.value;
      final bool shouldShow = hasOpenWindow || hasOpenDoor;

      String message = '';
      if (hasOpenWindow && hasOpenDoor) {
        message = '1 Window and 1 Door Open';
      } else if (hasOpenWindow) {
        message = '1 Window Open';
      } else if (hasOpenDoor) {
        message = '1 Door Open';
      }

      return Visibility(
        visible: shouldShow,
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
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    });
  }
}
