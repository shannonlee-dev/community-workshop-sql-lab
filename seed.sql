-- Sample data for Community Workshop Classes.
-- Parent tables are inserted before child tables so FK references exist first.
PRAGMA foreign_keys = ON;

INSERT INTO instructors (instructor_id, full_name, specialty, email, hired_on) VALUES
(1, 'Mina Park', 'Python', 'mina.park@example.test', '2024-01-10'),
(2, 'Joon Kim', 'Data Analysis', 'joon.kim@example.test', '2023-11-20'),
(3, 'Sara Lee', 'UX Writing', 'sara.lee@example.test', '2024-02-15'),
(4, 'Daniel Choi', 'Web Basics', 'daniel.choi@example.test', '2023-09-01'),
(5, 'Hana Jung', 'Photography', 'hana.jung@example.test', '2024-03-05'),
(6, 'Alex Moon', 'Public Speaking', 'alex.moon@example.test', '2023-08-12'),
(7, 'Yuri Han', 'Digital Drawing', 'yuri.han@example.test', '2024-04-18'),
(8, 'Chris Lim', 'Excel Automation', 'chris.lim@example.test', '2023-10-30'),
(9, 'Somi Kwon', 'Financial Planning', 'somi.kwon@example.test', '2024-05-08'),
(10, 'Eun Seo', 'Korean Cooking', 'eun.seo@example.test', '2023-12-22');

INSERT INTO students (student_id, full_name, email, city, joined_on) VALUES
(1, 'Irene Cho', 'irene.cho@example.test', 'Seoul', '2024-01-15'),
(2, 'Min Ho', 'min.ho@example.test', 'Incheon', '2024-01-22'),
(3, 'Grace Song', 'grace.song@example.test', 'Seoul', '2024-02-02'),
(4, 'Leo Shin', 'leo.shin@example.test', 'Suwon', '2024-02-11'),
(5, 'Nari Baek', 'nari.baek@example.test', 'Busan', '2024-02-19'),
(6, 'Owen Yoo', 'owen.yoo@example.test', 'Seoul', '2024-03-01'),
(7, 'Jia Nam', 'jia.nam@example.test', 'Daegu', '2024-03-12'),
(8, 'Noah Kang', 'noah.kang@example.test', 'Daejeon', '2024-03-21'),
(9, 'Sumin Ahn', 'sumin.ahn@example.test', 'Gwangju', '2024-04-02'),
(10, 'Milo Ko', 'milo.ko@example.test', 'Seoul', '2024-04-09'),
(11, 'Yena Ryu', 'yena.ryu@example.test', 'Jeju', '2024-04-16'),
(12, 'Jae Won', 'jae.won@example.test', 'Seoul', '2024-04-25');

INSERT INTO courses (course_id, instructor_id, title, category, starts_on, seat_limit, fee) VALUES
(1, 1, 'Python Starter Lab', 'Programming', '2024-06-01', 20, 120000),
(2, 2, 'Data Dashboard Basics', 'Data', '2024-06-03', 18, 150000),
(3, 3, 'Clear UX Microcopy', 'Writing', '2024-06-05', 15, 90000),
(4, 4, 'HTML CSS Weekend', 'Web', '2024-06-08', 22, 110000),
(5, 5, 'Street Photo Walk', 'Creative', '2024-06-10', 12, 80000),
(6, 6, 'Confident Presentation', 'Career', '2024-06-12', 16, 95000),
(7, 7, 'Tablet Drawing Studio', 'Creative', '2024-06-14', 14, 130000),
(8, 8, 'Excel Macro Sprint', 'Productivity', '2024-06-17', 18, 100000),
(9, 9, 'Personal Budget Clinic', 'Finance', '2024-06-19', 15, 70000),
(10, 10, 'Home Cooking Foundations', 'Lifestyle', '2024-06-21', 10, 85000);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrolled_on, status, discount_percent) VALUES
(1, 1, 1, '2024-05-01', 'active', 0),
(2, 2, 1, '2024-05-02', 'active', 10),
(3, 3, 2, '2024-05-03', 'active', 0),
(4, 4, 2, '2024-05-04', 'cancelled', 0),
(5, 5, 3, '2024-05-05', 'active', 5),
(6, 6, 4, '2024-05-06', 'active', 0),
(7, 7, 4, '2024-05-07', 'active', 0),
(8, 8, 5, '2024-05-08', 'active', 0),
(9, 9, 6, '2024-05-09', 'active', 15),
(10, 10, 7, '2024-05-10', 'active', 0),
(11, 11, 8, '2024-05-11', 'active', 0),
(12, 12, 9, '2024-05-12', 'active', 20),
(13, 1, 2, '2024-05-13', 'active', 0),
(14, 2, 3, '2024-05-14', 'active', 0),
(15, 3, 4, '2024-05-15', 'waitlisted', 0),
(16, 4, 5, '2024-05-16', 'active', 10),
(17, 5, 6, '2024-05-17', 'active', 0),
(18, 6, 7, '2024-05-18', 'active', 0),
(19, 7, 8, '2024-05-19', 'cancelled', 0),
(20, 8, 10, '2024-05-20', 'active', 0);

INSERT INTO payments (payment_id, enrollment_id, paid_on, amount, method) VALUES
(1, 1, '2024-05-01', 120000, 'card'),
(2, 2, '2024-05-02', 108000, 'bank'),
(3, 3, '2024-05-03', 150000, 'card'),
(4, 5, '2024-05-05', 85500, 'card'),
(5, 6, '2024-05-06', 110000, 'cash'),
(6, 7, '2024-05-07', 110000, 'card'),
(7, 8, '2024-05-08', 80000, 'bank'),
(8, 9, '2024-05-09', 80750, 'card'),
(9, 10, '2024-05-10', 130000, 'card'),
(10, 11, '2024-05-11', 100000, 'bank'),
(11, 12, '2024-05-12', 56000, 'card'),
(12, 13, '2024-05-13', 150000, 'card'),
(13, 14, '2024-05-14', 90000, 'cash'),
(14, 16, '2024-05-16', 72000, 'bank'),
(15, 20, '2024-05-20', 85000, 'card');

INSERT INTO attendance (attendance_id, enrollment_id, session_date, attended, note) VALUES
(1, 1, '2024-06-01', 1, 'on time'),
(2, 2, '2024-06-01', 1, 'asked setup question'),
(3, 3, '2024-06-03', 1, 'completed exercise'),
(4, 5, '2024-06-05', 0, 'absent with notice'),
(5, 6, '2024-06-08', 1, 'on time'),
(6, 7, '2024-06-08', 1, 'late 5 minutes'),
(7, 8, '2024-06-10', 1, 'brought camera'),
(8, 9, '2024-06-12', 1, 'strong rehearsal'),
(9, 10, '2024-06-14', 1, 'shared sketch'),
(10, 11, '2024-06-17', 0, 'absent'),
(11, 12, '2024-06-19', 1, 'prepared budget'),
(12, 13, '2024-06-03', 1, 'joined online'),
(13, 14, '2024-06-05', 1, 'good feedback'),
(14, 16, '2024-06-10', 1, 'photo review'),
(15, 17, '2024-06-12', 1, 'group activity'),
(16, 18, '2024-06-14', 0, 'technical issue'),
(17, 20, '2024-06-21', 1, 'completed recipe'),
(18, 1, '2024-06-02', 1, 'practice complete'),
(19, 3, '2024-06-04', 0, 'missed homework'),
(20, 6, '2024-06-09', 1, 'finished layout');
