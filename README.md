# Indoor Environmental Monitoring System (IEMS)
### A Flutter-based IoT application for real-time indoor air quality and environmental monitoring

IEMS is a cross-platform mobile application built with Flutter that connects to IoT sensors via Firebase Realtime Database to monitor indoor environmental parameters such as air quality index (AQI), temperature, humidity, and more. It features real-time gauge visualizations, historical data charts, weather integration, personalized health suggestions, and an intruder alarm system.

---

## Features

- **Real-Time Sensor Data** -- Streams live environmental readings (AQI, temperature, humidity, and 15+ other parameters) from IoT sensors via Firebase Realtime Database
- **Interactive Gauge Displays** -- Syncfusion radial gauges provide at-a-glance visualization of current environmental metrics
- **Historical Data Charts** -- Syncfusion line and bar charts display environmental trends over time for analysis
- **Air Quality Alert System** -- Triggers an audible intruder alarm when AQI exceeds dangerous thresholds (200+)
- **Weather Integration** -- Fetches and displays local weather forecasts alongside indoor data using WeatherAPI
- **User Authentication** -- Firebase Authentication with email/password sign-up, sign-in, and email verification
- **User Profile Management** -- Personalized profiles with health condition preferences for tailored suggestions
- **Personalized Health Suggestions** -- AI-driven recommendations based on current environmental conditions and user health profiles
- **Animated Onboarding** -- Rive-powered animations on the splash and onboarding screens
- **Convex Bottom Navigation** -- Smooth tab navigation between Indoor Analysis, Weather, Profile, and About screens
- **Glassmorphism UI** -- Blurry container effects with backdrop filters for a modern aesthetic
- **Cross-Platform** -- Runs on both Android and iOS from a single codebase

---

## Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Rive](https://img.shields.io/badge/Rive-1D1D1D?style=for-the-badge&logo=rive&logoColor=white)
![IoT](https://img.shields.io/badge/IoT_Sensors-00979D?style=for-the-badge&logo=arduino&logoColor=white)

---

## Getting Started

### Prerequisites

- Flutter SDK (>=3.3.1)
- Dart SDK (>=3.3.1 <4.0.0)
- Android Studio or VS Code with Flutter extensions
- A Firebase project configured with Realtime Database and Authentication
- IoT sensor hardware pushing data to your Firebase Realtime Database

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MajorAbdullah/Indoor-Environmental-Monitoring-System-IEMS-.git
   ```
2. Navigate to the project directory:
   ```bash
   cd Indoor-Environmental-Monitoring-System-IEMS-
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) to the appropriate platform directories.
   - Ensure `lib/firebase_options.dart` matches your Firebase project configuration.
5. Run the application:
   ```bash
   flutter run
   ```

---

## Usage

1. **Onboarding** -- New users are greeted with an animated onboarding screen. Sign up with email and verify your account.
2. **Indoor Analysis** -- The main dashboard displays live sensor readings through gauges and charts. An audio alarm triggers automatically if AQI rises above the safety threshold.
3. **Weather** -- View current and forecasted local weather conditions alongside indoor data.
4. **Profile** -- Manage your personal health profile and environmental preferences for tailored suggestions.
5. **About** -- Learn more about the IEMS project and team.

---

## Project Structure

```
Indoor-Environmental-Monitoring-System-IEMS-/
|-- lib/
|   |-- main.dart                       # App entry point, Firebase initialization, auth routing
|   |-- constants.dart                  # Theme color constants
|   |-- firebase_options.dart           # Firebase configuration
|   |-- screens/
|   |   |-- current_analysis.dart       # Real-time sensor dashboard with gauges, charts, and AQI alarm
|   |   |-- current_weather.dart        # Weather page with forecast, navigation bar, Rive animations
|   |   |-- personalized_suggestions.dart # Health-based environmental suggestions
|   |   |-- user_profile.dart           # User profile management screen
|   |   |-- user_info_form.dart         # User information form
|   |   |-- onboding/
|   |   |   |-- onboding_screen.dart    # Animated onboarding screen
|   |   |   |-- components/
|   |   |   |   |-- sign_in_form.dart   # Firebase email sign-in form
|   |   |   |   |-- sign_up_form.dart   # Firebase email sign-up form
|   |   |   |   |-- emailVerification.dart # Email verification screen
|   |   |   |   |-- about_screen.dart   # About page
|-- assets/
|   |-- Backgrounds/                    # Background images
|   |-- icons/                          # Custom icon assets
|   |-- RiveAssets/                     # Rive animation files
|   |-- weather/                        # Weather-related assets
|   |-- intruder_alarm.mp3             # AQI alarm audio
|-- pubspec.yaml                        # Flutter dependencies and asset declarations
|-- android/                            # Android platform configuration
|-- ios/                                # iOS platform configuration
|-- LICENSE                             # Mozilla Public License 2.0
|-- README.md                           # Project documentation
```

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` / `firebase_auth` / `firebase_database` / `cloud_firestore` | Firebase integration (auth, realtime DB, Firestore) |
| `syncfusion_flutter_gauges` | Radial gauge widgets for sensor data |
| `syncfusion_flutter_charts` | Line and bar charts for historical data |
| `rive` | Animated onboarding and UI elements |
| `http` | Weather API integration |
| `audioplayers` | AQI alarm audio playback |
| `awesome_notifications` | Push notification support |
| `convex_bottom_bar` | Curved bottom navigation bar |
| `blurrycontainer` | Glassmorphism UI effects |
| `flutter_svg` | SVG rendering for icons |

---

## Contributing

Contributions are welcome. Please fork this repository, create a feature branch, and submit a pull request for review.

---

## License

This project is licensed under the **Mozilla Public License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## Contact

- **Email:** sa.abdullahshah.2001@gmail.com
- **LinkedIn:** [Syed Abdullah Shah](https://www.linkedin.com/in/syed-abdullah-shah-4018a5176)
