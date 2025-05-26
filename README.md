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

