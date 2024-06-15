-- Створення бази даних для проекту
CREATE DATABASE StudentGrades;
USE StudentGrades;

-- Створення таблиці "Успішність студента" з необхідними обмеженнями
CREATE TABLE StudentPerformance (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100),
    grade TINYINT DEFAULT 3,
    CHECK (grade >= 1 AND grade <= 5)
);

-- Вставка деяких даних для перевірки
INSERT INTO StudentPerformance (subject_name, grade) VALUES ('Mathematics', 4);
INSERT INTO StudentPerformance (subject_name, grade) VALUES ('Physics', 3);
INSERT INTO StudentPerformance (subject_name, grade) VALUES ('Chemistry', 5);
INSERT INTO StudentPerformance (subject_name, grade) VALUES ('History', 2);

-- Перевірка даних
SELECT * FROM StudentPerformance;

-- Видалення таблиці
DROP TABLE StudentPerformance;

-- Видалення бази даних
DROP DATABASE StudentGrades;
