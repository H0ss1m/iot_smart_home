# IoT Smart Home App

A comprehensive Flutter application for managing and monitoring a smart home environment. This app provides real-time control over various home appliances and sensors across different rooms, utilizing Firebase for data synchronization and GetX for state management.

## Features Overview

### 🏠 Dashboard (Home Page)
The central hub of the application, providing a high-level overview of the home's status.
- **Room Navigation**: Quick access to detailed controls for the Living Room, Kitchen, and Bedroom.
- **Global Status**: Displays the overall temperature and active device counts.
- **Smart Notifications**: Alerts the user if any doors or windows are left open.

### 🛋️ Living Room
Complete control over the living room environment.
- **Climate Control**:
  - **Air Conditioning**: Toggle ON/OFF.
  - **Temperature**: Adjust the target temperature using a slider.
- **Lighting**:
  - **Ceiling Light**: Toggle ON/OFF.
- **Security**:
  - **Main Door**: Monitor status (Open/Closed) and toggle lock state.
  - **Window**: Monitor status (Open/Closed) and toggle state.
- **Environment**:
  - **Moisture**: Real-time moisture level monitoring with visual progress bar.

### 🍳 Kitchen
Manage kitchen appliances and safety sensors.
- **Controls**:
  - **Main Lights**: Toggle ON/OFF.
- **Status Overview**:
  - **Door**: Monitor and control the kitchen door.
  - **Window**: Monitor and control the kitchen window.
- **Sensors**:
  - **Moisture Level**: Visual indicator of moisture levels with "Normal" or "High" warnings.

### 🛏️ Bedroom
Personalized comfort and security for the bedroom.
- **Climate Control**:
  - **Air Conditioning**: Toggle ON/OFF.
  - **Temperature**: Precise temperature adjustment.
- **Lighting**:
  - **All Lights**: Master switch for bedroom lighting.
- **Sensors & Security**:
  - **Bedroom Door**: Monitor open/closed status.
  - **Window**: Monitor open/closed status.
- **Environment**:
  - **Moisture Level**: Circular progress indicator for humidity monitoring.

## 🛠️ Technical Details

### State Management
The app uses **GetX** (`HomeController`) for reactive state management.
- **Real-time Updates**: UI components (like `Obx` widgets) automatically update when state changes.
- **Unified Controller**: A single `HomeController` manages the state for all rooms, ensuring consistency across the app.

### Data Synchronization
- **Firebase Integration**:
  - **Cloud Firestore**: Stores and syncs room data (lights, doors, temperature, etc.) in real-time.
  - **Listeners**: The app listens to Firestore streams to update the UI instantly when data changes on the server.
  - **Offline Support**: Falls back to local data if the network is unavailable.

### Architecture
- **Modular Design**: Each room is a separate module (`livingroom_page.dart`, `ketchin_page.dart`, `bedroom_page.dart`) for better code organization.
- **Reusable Widgets**: Common UI elements like status cards and switches are extracted for consistency.

## Getting Started

1. **Prerequisites**: Ensure you have Flutter installed and a Firebase project set up.
2. **Installation**:
   ```bash
   flutter pub get
   ```
3. **Run**:
   ```bash
   flutter run
   ```
