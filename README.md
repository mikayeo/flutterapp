# Student Management System

A complete student management system with QR code-based student information retrieval. The system consists of three main components:
- Vue.js Frontend for student registration and management
- Node.js Backend with MySQL database
- Flutter Mobile App for scanning student QR codes

## System Architecture

```
├── frontend/          # Vue.js web application
├── backend/           # Node.js server & API
└── flutterapp/       # Flutter mobile application
```

## Prerequisites

### Backend
- Node.js
- MySQL Server
- npm

### Frontend
- Node.js
- Vue.js CLI (`npm install -g @vue/cli`)
- npm

### Mobile App
- Flutter SDK
- Android Studio or VS Code with Flutter extensions
- Physical device or emulator for testing

## Setup Instructions

### 1. Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Configure MySQL
# Open src/server.js and update database settings:
const connection = await mysql.createConnection({
  host: 'localhost',
  user: 'your_username',
  password: 'your_password',
  database: 'geekforgeeks'
});

# Start the server
cd src
node server.js
```

### 2. Frontend Setup

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Update API URL in src/components/StudentRegistration.vue if needed
const API_URL = 'http://localhost:5000';

# Start development server
npm run serve
```

### 3. Flutter App Setup

```bash
# Navigate to Flutter app directory
cd flutterapp

# Install dependencies
flutter pub get

# Update backend URL in lib/main.dart
# Replace 192.168.1.12 with your computer's IP address
final String baseUrl = 'http://192.168.1.12:5000';

# Run the app
flutter run
```

## Features

### Web Application (Frontend)
- Student registration with:
  - Name
  - Email
  - Major
  - Photo URL
- QR code generation for each student
- List view of all registered students
- Form validation
- Real-time updates

### Backend Server
- RESTful API endpoints
- MySQL database integration
- Student data management
- Secure data handling
- Error handling and logging

### Mobile App
- QR code scanning
- Student information display
- Manual ID search
- Photo display
- Offline error handling

## Usage Flow

1. Register Students (Web App)
   - Access frontend at `http://localhost:8080`
   - Fill registration form
   - QR code is generated automatically

2. View Students (Web App)
   - See list of all registered students
   - View individual student details
   - Access QR codes

3. Scan QR Codes (Mobile App)
   - Open Flutter app
   - Click "Scan QR Code"
   - Point camera at student QR code
   - View student information

## API Endpoints

- GET `/students/:id` - Get student by ID
- POST `/students` - Register new student
- PUT `/students/:id` - Update student
- DELETE `/students/:id` - Delete student

## Troubleshooting

### Backend Issues
- Verify MySQL is running
- Check database credentials
- Ensure port 5000 is available
- Check server logs

### Frontend Issues
- Verify backend URL configuration
- Check browser console for errors
- Ensure npm dependencies are installed
- Verify network connectivity

### Mobile App Issues
- Check backend URL configuration
- Ensure device and computer are on same network
- Verify camera permissions
- Check debug console for errors

## Network Configuration

1. All devices must be on the same network
2. Update IP addresses in configuration:
   - Frontend: Update API_URL
   - Mobile App: Update baseUrl
3. Verify ports are not blocked:
   - Backend: 5000
   - Frontend: 8080

## Development Tips

1. Test backend API endpoints using Postman
2. Use Vue.js DevTools for frontend debugging
3. Flutter debug mode for mobile app testing
4. Keep all components updated
5. Check logs in all components

## Security Notes

1. Never commit sensitive data
2. Use environment variables
3. Implement proper error handling
4. Validate all inputs
5. Secure database access

## Support

For issues:
1. Check respective README files in each component
2. Verify configurations
3. Check system requirements
4. Review error logs
5. Test network connectivity
