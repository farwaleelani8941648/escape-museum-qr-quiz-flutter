# Escape Museum – Final QR Code Quiz App

This is my final project for the **Mobile Systems Programming** course (*Programmation des systèmes mobiles*). The app provides an interactive experience for museum visitors using mobile features like QR codes and sensors.  
Inspired by the exhibition “Le Meilleur du Terroir Belge” and fully developed by me as a solo student.

---

## What the App Does

The app allows museum visitors to play a digital quiz-based escape game. It uses the phone’s **camera**, **ambient light sensor**, and **gallery access** to create an interactive challenge.

### App Flow

1. **Start Screen**  
   - Players can:
     - **Generate QR Code**: Enter your name, generate a QR code.
     - **Scan QR Code**: Scan an existing QR code to continue.
   - QR codes can be saved to the gallery for later use.

2. **Player Details + Game Instructions**  
   - After scanning or generating a QR code, see your name, instructions, and a **Start Game** button.

3. **Quiz Screen with Ambient Light Logic**  
   - **5 questions** per game.
   - Uses the **ambient light sensor**:
     - If the **light is below 200 lux**, only the question is shown—answers are blurred.
     - When the **light is above 200 lux**, answer options appear.
   - Encourages play in a well-lit area.

4. **Result Screen**  
   - Score above 70% to win; otherwise, try again.
   - Options to **play again** or **exit**.

---

## Technologies Used

- **Flutter** (Dart)
- State management using **provider**
- Hardware features:
  - Camera (QR scanning)
  - Ambient light sensor (quiz logic)
  - File system/gallery (saving QR codes)

---

## Flutter Packages

| Package                | Use                                            |
|------------------------|------------------------------------------------|
| `provider`             | State management for quiz and player data      |
| `mobile_scanner`       | QR code scanning using the camera              |
| `qr_flutter`           | Generating QR codes from text                  |
| `light`                | Accessing the ambient light sensor             |
| `screenshot`           | Capturing QR code images                       |
| `permission_handler`   | Asking for storage permission                  |
| `path_provider`        | Saving files to the device                     |
| `google_fonts`         | Using custom fonts                             |
| `blur`                 | Blurring answer options                        |
| `audioplayers`         | Playing background music and sounds            |
| `vibration`            | Vibrating the phone for feedback               |
| `animate_do`, `lottie` | Animations for game feedback                   |

---

## Folder Structure

```text
lib/
├── main.dart                  # Entry point
├── screens/
│   ├── welcome_screen.dart    # First screen with QR options
│   ├── scan_screen.dart       # QR scanning
│   ├── home_screen.dart       # Player name + instructions
│   ├── quiz_screen.dart       # Quiz logic with light sensor
│   └── result_screen.dart     # Win or lose result
├── providers/
│   ├── player_provider.dart   # Manages player info
│   └── quiz_provider.dart     # Handles questions and score
assets/
├── images/                    # Quiz images
├── audio/                     # Background music
└── animations/                # Win/lose animations

How to Run the App

    Important:
    For best results, always use a physical Android device (not an emulator).
    Emulators usually do not support QR scanning or the ambient light sensor.

Step-by-step Instructions

    Install Flutter
    Follow the official Flutter install guide.

    Clone the project

git clone https://gitlab.com/Farwa1648/mobileapplicationdevelopment55983.git
cd final_qrcode_quiz

Install dependencies

flutter pub get

Connect your physical Android device

    Enable developer mode and USB debugging on your phone.

Check your devices
Run the following command to see all connected devices and emulators:

flutter devices

    Ensure your physical phone is listed.

    You can also run an emulator, but it will not support light sensor or reliable camera for QR code scanning.

Recommended: Use a physical device

    Ambient light sensor functionality only works on real hardware.

Run the app on your selected device
Replace <device_id> with the ID shown by flutter devices (for example, emulator-5554 or your phone's name):

flutter run -d <device_id>

    Example:

        flutter run -d Pixel_6_Pro_API_34
        flutter run -d RZ8M900XXXX (for a Samsung phone)

Permissions

    The app will request access to:

        Camera (for QR scanning)

        Storage/gallery (for saving QR codes)

        Light sensor (for quiz logic)

Notes

    Physical device is required for:

        QR scanning (reliable and real camera feed)

        Ambient light sensor (not available on emulators)

    If you only use an emulator, some features will not work as intended.

License / Credits

Project by Umm E Farwa Leealni, 2025.
No external collaborators.
Inspired by "Le Meilleur du Terroir Belge" exhibition.
