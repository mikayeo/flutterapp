# Flutter App Setup and Usage

## Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- Physical device or emulator for testing
- Git (optional)

## Setup Steps

1. Install Dependencies
```bash
cd flutterapp
flutter pub get
```

2. Configure Backend URL
- Open `lib/main.dart`
- Update the baseUrl variable with your computer's IP address:
  ```dart
  final String baseUrl = 'http://192.168.1.12:5000';
  ```
  Replace 192.168.1.12 with your computer's IP address

3. Run the App
```bash
flutter run
```

## Features

### Student Information Scanner
- Scan QR codes containing student IDs
- Manual student ID entry
- Display student information including:
  - Name
  - Email
  - Major
  - Photo

### QR Code Scanner
- Built-in QR code scanner
- Camera permission handling
- Error handling for invalid QR codes
- Shows scanned content before searching

### Student Information Display
- Clean card-based layout
- Photo display with error handling
- Loading indicators
- Error messages for various scenarios

## Usage

1. Start the App
   - Connect your phone or start an emulator
   - Run `flutter run`

2. Scan QR Codes
   - Click "Scan QR Code" button
   - Grant camera permission if prompted
   - Point camera at student QR code
   - Confirm scanned ID in dialog

3. Manual Search
   - Enter student ID in text field
   - Click "Search Student" button

## Troubleshooting

### Common Issues
- If "Student not found" error:
  - Check if backend server is running
  - Verify student ID exists in database
  - Check network connectivity

### Network Issues
- Ensure phone and computer are on same network
- Verify backend URL is correct
- Check if backend server is accessible

### Camera Issues
- Grant camera permissions in app settings
- Restart app after granting permissions
- Ensure adequate lighting for scanning

### Debug Tips
- Check debug console for error messages
- Verify scanned QR code content
- Test manual ID entry first
- Check backend server logs
