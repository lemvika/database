-- Створення бази даних
CREATE DATABASE IF NOT EXISTS PharmacyDB;
USE PharmacyDB;

-- Створення таблиці користувачів
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(50),
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(50)
);

-- Створення таблиці постачальників
CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    ContactInfo VARCHAR(255)
);

-- Створення таблиці лікарських засобів
CREATE TABLE IF NOT EXISTS Medicines (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT,
    Dosage VARCHAR(50),
    SideEffects TEXT,
    Price DECIMAL(10, 2),
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Створення таблиці продажів
CREATE TABLE IF NOT EXISTS Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineID INT,
    Quantity INT,
    TotalPrice DECIMAL(10, 2),
    Date DATE,
    UserID INT,
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Створення таблиці замовлень
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineID INT,
    Quantity INT,
    OrderDate DATE,
    SupplierID INT,
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Створення таблиці запасів
CREATE TABLE IF NOT EXISTS Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineID INT,
    Quantity INT,
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);

-- Створення таблиці звітів
CREATE TABLE IF NOT EXISTS Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    Type VARCHAR(50),
    Content TEXT,
    Date DATE
);

-- Вставка даних у таблицю користувачів
INSERT INTO Users (Name, Role, Username, Password) VALUES
('Іван Іванов', 'Адміністратор', 'ivan_admin', 'password123'),
('Олена Петрова', 'Фармацевт', 'olena_pharm', 'password123'),
('Сергій Коваленко', 'Касир', 'sergiy_cashier', 'password123');

-- Вставка даних у таблицю постачальників
INSERT INTO Suppliers (Name, ContactInfo) VALUES
('Фармацевтична компанія "Здоров\'я"', 'вул. Миру, 12, Київ, Україна, +380441234567'),
('ТОВ "Медсервіс"', 'вул. Лесі Українки, 5, Харків, Україна, +380577654321');

-- Вставка даних у таблицю лікарських засобів
INSERT INTO Medicines (Name, Description, Dosage, SideEffects, Price, SupplierID) VALUES
('Парацетамол', 'Знеболювальний та жарознижувальний засіб', '500 мг', 'Нудота, головний біль', 35.50, 1),
('Амоксицилін', 'Антибіотик широкого спектру дії', '250 мг', 'Алергічні реакції, діарея', 58.00, 1),
('Ібупрофен', 'Протизапальний та знеболювальний засіб', '200 мг', 'Шлунковий біль, нудота', 42.75, 2);

-- Вставка даних у таблицю продажів
INSERT INTO Sales (MedicineID, Quantity, TotalPrice, Date, UserID) VALUES
(1, 2, 71.00, '2024-06-01', 2),
(2, 1, 58.00, '2024-06-01', 2),
(3, 3, 128.25, '2024-06-02', 3);

-- Вставка даних у таблицю замовлень
INSERT INTO Orders (MedicineID, Quantity, OrderDate, SupplierID) VALUES
(1, 100, '2024-05-15', 1),
(2, 200, '2024-05-20', 1),
(3, 150, '2024-05-25', 2);

-- Вставка даних у таблицю запасів
INSERT INTO Inventory (MedicineID, Quantity) VALUES
(1, 50),
(2, 120),
(3, 80);

-- Вставка даних у таблицю звітів
INSERT INTO Reports (Type, Content, Date) VALUES
('Sales', 'Звіт про продажі за червень 2024 року', '2024-06-03');

-- Запити

-- 1. Отримати список всіх лікарських засобів з їх постачальниками
SELECT M.Name AS MedicineName, S.Name AS SupplierName
FROM Medicines M
JOIN Suppliers S ON M.SupplierID = S.SupplierID;

-- 2. Отримати інформацію про продажі за останній місяць
SELECT SaleID, MedicineID, Quantity, TotalPrice, Date, UserID
FROM Sales
WHERE Date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 3. Отримати залишки товарів на складі
SELECT M.Name AS MedicineName, I.Quantity
FROM Inventory I
JOIN Medicines M ON I.MedicineID = M.MedicineID;

-- 4. Згенерувати звіт про продажі за певний період
INSERT INTO Reports (Type, Content, Date)
VALUES ('Sales', 
        (SELECT GROUP_CONCAT(CONCAT('SaleID: ', SaleID, ', MedicineID: ', MedicineID, ', Quantity: ', Quantity, ', TotalPrice: ', TotalPrice, ', Date: ', Date) SEPARATOR '; ')
         FROM Sales
         WHERE Date BETWEEN '2024-05-01' AND '2024-05-31'), 
        CURDATE());
