import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/model/colors.dart';
import 'package:iot_smart_home/services/data/const_data/icons.dart';
import 'package:iot_smart_home/services/data/state_management/home_controller.dart';

class BedroomPage extends StatelessWidget {
  const BedroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedroom'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Climate Control Section
            _buildSection(
              title: 'Climate Control',
              children: [
                Obx(
                  () => _buildToggleItem(
                    icon: acIcon,
                    title: 'Air Conditioning',
                    isOn: controller.bedroomAc.value,
                    onChanged: (value) =>
                        controller.setBedroomAc(value ?? false),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => _buildTemperatureSlider(controller)),
              ],
            ),
            const SizedBox(height: 24),

            // Lighting Section
            _buildSection(
              title: 'Lighting',
              children: [
                Obx(
                  () => _buildToggleItem(
                    icon: lightIcon,
                    title: 'All Lights',
                    isOn: controller.bedroomLight.value,
                    onChanged: (value) =>
                        controller.setBedroomLight(value ?? false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sensors Section
            _buildSection(
              title: 'Sensors',
              children: [
                Obx(
                  () => _buildStatusItem(
                    icon: mainDoorIcon,
                    title: 'Bedroom Door',
                    status: controller.bedroomDoor.value ? 'Open' : 'Closed',
                    isWarning: controller.bedroomDoor.value,
                    onToggle: (value) => controller.setBedroomDoor(value),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => _buildStatusItem(
                    icon: windowIcon,
                    title: 'Window',
                    status: controller.bedroomWindow.value ? 'Open' : 'Closed',
                    isWarning: controller.bedroomWindow.value,
                    onToggle: (value) => controller.setBedroomWindow(value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Environment Section
            _buildSection(
              title: 'Environment',
              children: [Obx(() => _buildMoistureCard(controller))],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            title,
            style: Theme.of(
              Get.context!,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool isOn,
    required ValueChanged<bool?> onChanged,
  }) {
    final Color activeColor = const Color(0xFF3B82F6); // Blue color
    final Color inactiveColor = Colors.grey.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOn
                      ? activeColor.withOpacity(0.2)
                      : inactiveColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isOn ? activeColor : Colors.grey.shade400,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: isOn ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: isOn ? 22 : 2,
                  top: 2,
                  child: GestureDetector(
                    onTap: () => onChanged(!isOn),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSlider(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      temperatureIcon,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Temperature',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '${controller.bedroomTemperature.value.toInt()}°C',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: const Color(0xFF3B82F6),
              inactiveTrackColor: Colors.grey.shade700,
              thumbColor: const Color(0xFF3B82F6),
              overlayColor: const Color(0xFF3B82F6).withOpacity(0.2),
              valueIndicatorColor: const Color(0xFF3B82F6),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: controller.bedroomTemperature.value,
              min: 16,
              max: 30,
              divisions: 14,
              label: '${controller.bedroomTemperature.value.toInt()}°C',
              onChanged: (value) {
                controller.setBedroomTemperature(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String status,
    required bool isWarning,
    required ValueChanged<bool> onToggle,
  }) {
    final Color statusColor = isWarning
        ? warningColor // Orange for warning (open)
        : activeColor; // Green for safe (closed)

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bacContentContainers,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 14,
                              color: statusColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildCustomSwitch(
            value: isWarning,
            onChanged: onToggle,
            activeColor: statusColor,
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
    final double moisturePercent = controller.bedroomMoisture.value.clamp(
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
}
