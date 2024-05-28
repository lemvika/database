-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Час створення: Трв 28 2024 р., 14:04
-- Версія сервера: 10.4.32-MariaDB
-- Версія PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База даних: `bd_lab2_table`
--

-- --------------------------------------------------------

--
-- Структура таблиці `book`
--

CREATE TABLE `book` (
  `N` int(11) NOT NULL,
  `code` int(11) NOT NULL,
  `new` tinyint(1) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `id_publishing` int(11) NOT NULL,
  `pages` int(11) NOT NULL,
  `format` varchar(30) NOT NULL,
  `datee` date NOT NULL,
  `circulation` int(11) DEFAULT NULL,
  `id_topic` int(11) NOT NULL,
  `id_category` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп даних таблиці `book`
--

INSERT INTO `book` (`N`, `code`, `new`, `name`, `price`, `id_publishing`, `pages`, `format`, `datee`, `circulation`, `id_topic`, `id_category`) VALUES
(1, 5110, 0, 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, 1, 400, '70х100/16', '2000-07-24', 5000, 1, 6),
(2, 5141, 0, 'Структури даних та алгоритми', 37.8, 4, 384, '70х100/16', '2000-09-29', 5000, 1, 1),
(3, 5127, 0, 'Автоматизація інженерно-графічних робіт', 11.58, 1, 256, '70х100/16', '2000-06-15', 5000, 1, 1),
(4, 5199, 0, 'Залізо IMB 2001', 30.07, 2, 368, '70х100/16', '2000-12-02', 5000, 1, 6),
(5, 3851, 0, 'Захист інформації, та безбека комп\'ютених систем', 26, 3, 480, '84х108/16', '1999-02-04', 5000, 1, 6),
(6, 3932, 0, 'Як перетворити персональний комп\'ютер на вимірювальний комплекс', 7.65, 5, 144, '60х88/16', '1999-06-09', 5000, 1, 2),
(7, 4713, 0, 'Plug-ins. Додаткові програми для музичних програм', 11.41, 5, 144, '70х100/16', '2000-02-22', 5000, 1, 2),
(8, 5217, 0, 'Windows ME. Найновіші версії програм', 16.57, 6, 320, '70х100/16', '2000-08-25', 5000, 2, 3),
(9, 4829, 0, 'Windows 2000 Proffesional крок за кроком з CD', 27.25, 7, 320, '70х100/16', '2000-04-28', 5000, 2, 3),
(10, 5170, 0, 'Linux версії', 24.43, 5, 346, '70х100/16', '2000-09-29', 5000, 2, 4),
(11, 860, 0, 'Операційна система UNIX', 3.5, 1, 395, '84х10016', '1997-05-05', 5000, 2, 5),
(12, 44, 0, 'Відповіді на актуальні запитання щодо OS/2 Warp', 5, 3, 352, '60х84/16', '1996-03-20', 5000, 2, 6),
(13, 5176, 0, 'Windows ME. Супутник користувача', 12.79, 1, 306, '-', '2000-10-10', 5000, 2, 6),
(14, 5462, 0, 'Мова програмування С++. Лекції та вправи', 29, 3, 656, '84х108/16', '2000-12-12', 5000, 3, 7),
(15, 4982, 0, 'Мова програмування С. Лекції та вправи', 29, 3, 432, '84х108/16', '2000-07-12', 5000, 3, 7),
(16, 4687, 0, 'Ефективне використання C++ .50 рекомендацій щодо покращення ваших програм та проектів', 17.6, 5, 240, '70х100/16', '2000-02-03', 5000, 3, 7);

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`N`),
  ADD KEY `id_publishing` (`id_publishing`),
  ADD KEY `id_topic` (`id_topic`),
  ADD KEY `id_category` (`id_category`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `book`
--
ALTER TABLE `book`
  MODIFY `N` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`id_publishing`) REFERENCES `publishing` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_ibfk_2` FOREIGN KEY (`id_topic`) REFERENCES `topic` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_ibfk_3` FOREIGN KEY (`id_category`) REFERENCES `category` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
