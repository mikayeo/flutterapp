# Frontend Setup and Usage

## Prerequisites
- Node.js installed
- Vue.js CLI installed (`npm install -g @vue/cli`)
- Git (optional)

## Setup Steps

1. Install Dependencies
```bash
cd frontend
npm install
```

2. Configure Backend URL
- Open `src/components/StudentRegistration.vue`
- Update the API URL if needed:
  ```javascript
  const API_URL = 'http://localhost:5000';
  ```

3. Start Development Server
```bash
npm run serve
```
The application will start on port 8080.

## Features

### Student Registration
- Register new students with:
  - Name
  - Email
  - Major
  - Photo URL
- QR code generation for each student
- Form validation
- Success/error notifications

### Student List
- View all registered students
- QR codes for each student
- Student information display
- Photo display

## Usage
1. Access the application at `http://localhost:8080`
2. Register new students using the registration form
3. View registered students in the list
4. Scan QR codes using the Flutter mobile app

## QR Code Generation
- QR codes are automatically generated for each student
- Contains student ID for easy scanning
- Used with the Flutter mobile app for quick information retrieval

## Troubleshooting
- If API calls fail, check backend server status
- Ensure correct backend URL configuration
- Check browser console for error messages
- Verify network connectivity between frontend and backend
