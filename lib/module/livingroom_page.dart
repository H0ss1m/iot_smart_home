import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/model/colors.dart';
import 'package:iot_smart_home/services/data/const_data/icons.dart';
import 'package:iot_smart_home/services/data/state_management/home_controller.dart';

class LivingroomPage extends StatelessWidget {
  const LivingroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Living Room'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
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
                    isOn: controller.livingroomAc.value,
                    onChanged: (value) =>
                        controller.setLivingroomAc(value ?? false),
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
                    title: 'Ceiling Light',
                    isOn: controller.livingroomLight.value,
                    onChanged: (value) =>
                        controller.setLivingroomLight(value ?? false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Security Section
            _buildSection(
              title: 'Security',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildStatusCard(
                          icon: mainDoorIcon,
                          title: 'Main Door',
                          isOpen: controller.livingroomDoor.value,
                          onToggle: (value) =>
                              controller.setLivingroomDoor(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => _buildStatusCard(
                          icon: windowIcon,
                          title: 'Window',
                          isOpen: controller.livingroomWindow.value,
                          onToggle: (value) =>
                              controller.setLivingroomWindow(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Environment Section
            _buildSection(
              title: 'Environment',
              children: [Obx(() => _buildMoistureItem(controller))],
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
                '${controller.livingroomTemperature.value.toInt()}°C',
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
              value: controller.livingroomTemperature.value,
              min: 16,
              max: 30,
              divisions: 14,
              label: '${controller.livingroomTemperature.value.toInt()}°C',
              onChanged: (value) {
                controller.setLivingroomTemperature(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required bool isOpen,
    required ValueChanged<bool> onToggle,
  }) {
    final Color statusColor = isOpen
        ? const Color(0xFFEF4444) // Red for warning
        : const Color(0xFF22C55E); // Green for safe
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

  Widget _buildMoistureItem(HomeController controller) {
    double moistureValue = controller.livingroomMoisture.value;
    const Color moistureColor = Color(0xFF3B82F6); // Blue

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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: moistureColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(moistureIcon, color: moistureColor, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Moisture',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${moistureValue.toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: moistureColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: moistureValue / 100,
              backgroundColor: Colors.grey.shade700,
              valueColor: const AlwaysStoppedAnimation<Color>(moistureColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
