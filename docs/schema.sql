-- ============================================================
--  Online Course Registration System - MySQL Schema
--  Run this file in MySQL before starting the application
-- ============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS course_registration;
USE course_registration;

-- ============================================================
--  TABLE: users
--  Stores registered user accounts
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)        NOT NULL,
    email       VARCHAR(150)        NOT NULL UNIQUE,
    password    VARCHAR(255)        NOT NULL,   -- store hashed passwords in production
    created_at  TIMESTAMP           DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  TABLE: courses
--  Stores available courses in the system
-- ============================================================
CREATE TABLE IF NOT EXISTS courses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200)        NOT NULL,
    description TEXT,
    instructor  VARCHAR(100)        NOT NULL,
    duration    VARCHAR(50),                    -- e.g. "8 Weeks"
    category    VARCHAR(100),
    seats       INT                 DEFAULT 30,
    created_at  TIMESTAMP           DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  TABLE: enrollments
--  Junction table linking users to their enrolled courses
-- ============================================================
CREATE TABLE IF NOT EXISTS enrollments (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT         NOT NULL,
    course_id    INT         NOT NULL,
    enrolled_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, course_id)  -- prevent duplicate enrollments
);

-- ============================================================
--  SAMPLE DATA: courses
-- ============================================================
INSERT INTO courses (title, description, instructor, duration, category, seats) VALUES
('Java Programming for Beginners',
 'Master the fundamentals of Java programming including OOP, collections, and file I/O. Perfect for absolute beginners.',
 'Dr. Anita Sharma', '10 Weeks', 'Programming', 40),

('Full-Stack Web Development',
 'Build complete web applications using HTML, CSS, JavaScript, and Node.js. Includes REST API design and database integration.',
 'Prof. Rajesh Kumar', '12 Weeks', 'Web Development', 35),

('Data Science with Python',
 'Learn data analysis, visualization, and machine learning using Python, Pandas, NumPy, and Scikit-learn.',
 'Dr. Priya Mehta', '14 Weeks', 'Data Science', 30),

('Cloud Computing with AWS',
 'Hands-on training on Amazon Web Services including EC2, S3, RDS, Lambda, and cloud architecture best practices.',
 'Mr. Vikram Singh', '8 Weeks', 'Cloud', 25),

('UI/UX Design Fundamentals',
 'Understand user-centred design principles, wireframing, prototyping with Figma, and usability testing.',
 'Ms. Deepa Nair', '6 Weeks', 'Design', 20),

('Database Management with MySQL',
 'Comprehensive guide to relational databases: schema design, SQL queries, stored procedures, and performance tuning.',
 'Prof. Suresh Patel', '8 Weeks', 'Database', 30),

('Android App Development',
 'Build Android applications using Kotlin. Covers Activities, Fragments, RecyclerView, Room, and Retrofit.',
 'Mr. Arjun Rao', '12 Weeks', 'Mobile', 30),

('Cybersecurity Essentials',
 'Introduction to network security, ethical hacking, cryptography, and secure coding practices.',
 'Dr. Kavitha Iyer', '10 Weeks', 'Security', 25);
