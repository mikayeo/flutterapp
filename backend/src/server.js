import express from "express";
import mysql from "mysql";
import cors from "cors";
import bodyParser from "body-parser";
import 'dotenv/config';

const app = express();
app.use(cors());
app.use(bodyParser.json());

// MySQL connection
const db = mysql.createConnection({
    host: "127.0.0.1",  // Using IP address instead of localhost
    port: 3306,
    user: "root",
    password: "",  // Default WAMP MySQL password is blank
    database: "geeksforgeeks",
    multipleStatements: true,
    connectTimeout: 10000, // 10 seconds timeout
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Handle connection errors
db.connect((err) => {
    if (err) {
        console.error("Error connecting to MySQL:", err);
        if (err.code === 'ER_BAD_DB_ERROR') {
            console.log("Database 'geeksforgeeks' does not exist. Creating it...");
            createDatabase();
        } else if (err.code === 'ECONNREFUSED') {
            console.error("MySQL server is not running. Please start your MySQL server.");
        } else {
            console.error("MySQL connection error:", err.message);
        }
        return;
    }
    console.log("MySQL Connected Successfully!");
    createTables();
});

// Handle connection errors after initial connection
db.on('error', (err) => {
    console.error('MySQL connection error:', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        console.log('Attempting to reconnect to MySQL...');
        db.connect();
    }
});

// Function to create database if it doesn't exist
function createDatabase() {
    const connection = mysql.createConnection({
        host: "127.0.0.1",
        port: 3306,
        user: "root",
        password: ""
    });

    connection.connect((err) => {
        if (err) {
            console.error("Error connecting to MySQL:", err);
            return;
        }

        connection.query("CREATE DATABASE IF NOT EXISTS geeksforgeeks", (err) => {
            if (err) {
                console.error("Error creating database:", err);
                return;
            }
            console.log("Database 'geeksforgeeks' created successfully");
            connection.end();
            // Reconnect with the database selected
            db.connect();
        });
    });
}

// Function to create tables if they don't exist
function createTables() {
    // Create admin table
    const adminTableQuery = `
        CREATE TABLE IF NOT EXISTS admin (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL UNIQUE,
            password VARCHAR(255) NOT NULL
        )
    `;

    db.query(adminTableQuery, (err) => {
        if (err) {
            console.error("Error creating admin table:", err);
            return;
        }
        console.log("Admin table created successfully");
    });

    // Create student table
    const studentTableQuery = `
        CREATE TABLE IF NOT EXISTS student (
            id VARCHAR(50) PRIMARY KEY,
            firstname VARCHAR(100) NOT NULL,
            lastname VARCHAR(100) NOT NULL,
            email VARCHAR(100) NOT NULL,
            major VARCHAR(100) NOT NULL,
            photo VARCHAR(255)
        )
    `;

    db.query(studentTableQuery, (err) => {
        if (err) {
            console.error("Error creating student table:", err);
            return;
        }
        console.log("Student table created successfully");
    });
}

// Login route
app.post("/login", (req, res) => {
    const { username, password } = req.body;
    
    console.log("Login attempt:", { username, password });
    
    if (!username || !password) {
        console.log("Missing credentials");
        return res.status(400).json({ error: "Username and password are required" });
    }

    const sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
    console.log("Executing SQL:", sql);
    console.log("With parameters:", [username, password]);

    db.query(sql, [username, password], (err, results) => {
        if (err) {
            console.error("Database error:", err);
            return res.status(500).json({ error: "Internal server error" });
        }

        console.log("Query results:", results);

        if (results.length === 0) {
            console.log("No matching user found");
            return res.status(401).json({ error: "Invalid username or password" });
        }

        console.log("Login successful for user:", username);
        const token = "admin-token-" + Date.now();
        res.json({ success: true, token });
    });
});

// Token verification middleware
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ valid: false, error: 'No token provided' });
  }

  // In a real application, you would verify the JWT token here
  // For this demo, we'll just check if it starts with 'admin-token-'
  if (token.startsWith('admin-token-')) {
    next();
  } else {
    res.status(401).json({ valid: false, error: 'Invalid token' });
  }
};

// Token verification endpoint
app.get('/verify-token', verifyToken, (req, res) => {
  res.json({ valid: true });
});

// Protect student endpoints with token verification
app.post('/submit', verifyToken, (req, res) => {
    const { id, firstname, lastname, email, major, photoUrl } = req.body;
    
    console.log("Received student data:", { id, firstname, lastname, email, major, photoUrl });
    
    if (!id || !firstname || !lastname || !email || !major || !photoUrl) {
        return res.status(400).json({ error: "All fields are required" });
    }

    const sql = "INSERT INTO student (id, firstname, lastname, email, major, photo) VALUES (?, ?, ?, ?, ?, ?)";
    db.query(sql, [id, firstname, lastname, email, major, photoUrl], (err, result) => {
        if (err) {
            console.error("Database error:", err);
            return res.status(500).json({ error: err.message });
        }
        console.log("Student added successfully with photo URL:", photoUrl);
        res.json({ message: "Student added successfully" });
    });
});

// API to get all students
app.get("/students", verifyToken, (req, res) => {
    const sql = "SELECT id, firstname, lastname, email, major, photo as photoUrl FROM student";
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        console.log("Retrieved students:", results);
        res.json(results);
    });
});

// API to get a single student by ID
app.get("/students/:id", (req, res) => {
    const studentId = req.params.id;
    console.log("Fetching student with ID:", studentId);
    
    // First check if the connection is still alive
    if (!db.state || db.state === 'disconnected') {
        console.log("Database connection lost, attempting to reconnect...");
        db.connect((err) => {
            if (err) {
                console.error("Failed to reconnect to database:", err);
                return res.status(500).json({ error: "Database connection error" });
            }
            console.log("Successfully reconnected to database");
            queryStudent();
        });
    } else {
        console.log("Database connection is active, proceeding with query");
        queryStudent();
    }

    function queryStudent() {
        const sql = "SELECT id, firstname, lastname, email, major, photo as photoUrl FROM student WHERE id = ?";
        console.log("Executing SQL query:", sql);
        console.log("With parameters:", [studentId]);
        
        db.query(sql, [studentId], (err, results) => {
            if (err) {
                console.error("Database error:", err);
                console.error("Error code:", err.code);
                console.error("Error message:", err.message);
                return res.status(500).json({ error: err.message });
            }
            
            if (results.length === 0) {
                console.log("No student found with ID:", studentId);
                return res.status(404).json({ error: "Student not found" });
            }
            
            console.log("Found student:", results[0]);
            res.json(results[0]);
        });
    }
});

// Add a test endpoint to verify database connection
app.get("/test-connection", (req, res) => {
    console.log("Testing database connection...");
    console.log("Current database state:", db.state);
    
    db.query("SELECT 1", (err, results) => {
        if (err) {
            console.error("Database connection test failed:", err);
            return res.status(500).json({ 
                error: "Database connection failed",
                details: err.message,
                state: db.state
            });
        }
        console.log("Database connection test successful");
        res.json({ 
            success: true, 
            message: "Database connection is working",
            state: db.state
        });
    });
});

app.listen(5000, '0.0.0.0', () => {
    console.log("Server running on port 5000 and accepting connections from all IPs");
    console.log("Database connection state:", db.state);
});
