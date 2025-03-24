# Backend Setup and Usage

## Prerequisites
- Node.js installed
- MySQL installed and running
- Git (optional)

## Setup Steps

1. Install Dependencies
```bash
cd backend
npm install
```

2. Configure Database
- Open `src/server.js`
- Update MySQL connection settings if needed:
  ```javascript
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'your_username',
    password: 'your_password',
    database: 'geekforgeeks'
  });
  ```

3. Start the Server
```bash
cd src
node server.js
```
The server will start on port 5000.

## API Endpoints

### Students
- GET `/students/:id` - Get student information by ID
- POST `/students` - Register a new student
- PUT `/students/:id` - Update student information
- DELETE `/students/:id` - Delete a student

### Database Structure
The database contains a `student` table with the following fields:
- id (Primary Key)
- name
- email
- major
- photoUrl

## Testing
1. Make sure the server is running
2. Test the API using Postman or any API testing tool
3. Example URL: `http://localhost:5000/students/106330`

## Troubleshooting
- If database connection fails, check MySQL credentials
- Ensure port 5000 is not in use
- Check server logs for detailed error messages 