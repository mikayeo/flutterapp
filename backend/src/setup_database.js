import mysql from "mysql";

// Create connection without database
const connection = mysql.createConnection({
    host: "127.0.0.1",
    port: 3306,
    user: "root",
    password: "",
    multipleStatements: true
});

// Connect to MySQL
connection.connect((err) => {
    if (err) {
        console.error("Error connecting to MySQL:", err);
        return;
    }
    console.log("Connected to MySQL server");

    // Create database
    connection.query("CREATE DATABASE IF NOT EXISTS geeksforgeeks", (err) => {
        if (err) {
            console.error("Error creating database:", err);
            return;
        }
        console.log("Database 'geeksforgeeks' created successfully");

        // Use the database
        connection.query("USE geeksforgeeks", (err) => {
            if (err) {
                console.error("Error using database:", err);
                return;
            }

            // Create admin table
            const createAdminTable = `
                CREATE TABLE IF NOT EXISTS admin (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    username VARCHAR(255) NOT NULL UNIQUE,
                    password VARCHAR(255) NOT NULL
                )
            `;

            connection.query(createAdminTable, (err) => {
                if (err) {
                    console.error("Error creating admin table:", err);
                    return;
                }
                console.log("Admin table created successfully");
            });

            // Create student table
            const createStudentTable = `
                CREATE TABLE IF NOT EXISTS student (
                    id VARCHAR(255) PRIMARY KEY,
                    firstname VARCHAR(255) NOT NULL,
                    lastname VARCHAR(255) NOT NULL,
                    email VARCHAR(255) NOT NULL,
                    major VARCHAR(255) NOT NULL,
                    photo TEXT
                )
            `;

            connection.query(createStudentTable, (err) => {
                if (err) {
                    console.error("Error creating student table:", err);
                    return;
                }
                console.log("Student table created successfully");
            });
        });
    });
});

// Close connection after 5 seconds
setTimeout(() => {
    connection.end((err) => {
        if (err) {
            console.error("Error closing connection:", err);
            return;
        }
        console.log("Database setup completed. Connection closed.");
    });
}, 5000); 