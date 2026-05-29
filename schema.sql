-- Community Workshop Classes database schema
-- Target DB: SQLite.
-- SQLite-specific note: PRAGMA foreign_keys enables FK enforcement per connection.
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;

CREATE TABLE instructors (
    instructor_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    hired_on DATE NOT NULL
);

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    city TEXT NOT NULL,
    joined_on DATE NOT NULL
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    instructor_id INTEGER NOT NULL,
    title TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    starts_on DATE NOT NULL,
    seat_limit INTEGER NOT NULL,
    fee INTEGER NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrolled_on DATE NOT NULL,
    status TEXT NOT NULL,
    discount_percent INTEGER NOT NULL DEFAULT 0,
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER NOT NULL UNIQUE,
    paid_on DATE NOT NULL,
    amount INTEGER NOT NULL,
    method TEXT NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER NOT NULL,
    session_date DATE NOT NULL,
    attended INTEGER NOT NULL,
    note TEXT,
    UNIQUE (enrollment_id, session_date),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);
