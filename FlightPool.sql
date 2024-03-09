-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Мар 09 2024 г., 12:20
-- Версия сервера: 8.0.30
-- Версия PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `FlightPool`
--

-- --------------------------------------------------------

--
-- Структура таблицы `airports`
--

CREATE TABLE `airports` (
  `id` bigint NOT NULL,
  `city` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `iata` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL,
  `uploaded_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `airports`
--

INSERT INTO `airports` (`id`, `city`, `name`, `iata`, `created_at`, `uploaded_at`) VALUES
(1, 'Astana', 'Astana', 'AST', '2024-03-09 10:39:05', '2024-03-09 10:39:05'),
(3, 'Atyrau', 'Atyrau', 'GUW', '2024-03-09 10:48:21', '2024-03-09 10:48:21');

-- --------------------------------------------------------

--
-- Структура таблицы `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint NOT NULL,
  `flight_from` bigint NOT NULL,
  `flight_back` bigint NOT NULL,
  `date_from` date NOT NULL,
  `date_back` date NOT NULL,
  `code` varchar(5) NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `flights`
--

CREATE TABLE `flights` (
  `id` bigint NOT NULL,
  `flight_code` varchar(10) NOT NULL,
  `from_id` bigint NOT NULL,
  `to_id` bigint NOT NULL,
  `time_from` time NOT NULL,
  `time_to` time NOT NULL,
  `cost` int NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `flights`
--

INSERT INTO `flights` (`id`, `flight_code`, `from_id`, `to_id`, `time_from`, `time_to`, `cost`, `created_at`, `updated_at`) VALUES
(1, 'FP1200', 1, 12, '12:00:00', '13:35:00', 9500, '2024-03-09 08:45:31', '2024-03-09 08:45:31'),
(2, 'FP1200', 1, 3, '12:00:00', '13:35:00', 9500, '2024-03-09 08:50:34', '2024-03-09 08:50:34');

-- --------------------------------------------------------

--
-- Структура таблицы `passengers`
--

CREATE TABLE `passengers` (
  `id` bigint NOT NULL,
  `booking_id` bigint NOT NULL,
  `first__name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `both_date` date NOT NULL,
  `document_number` varchar(10) NOT NULL,
  `place_from` varchar(3) NOT NULL,
  `place_back` varchar(3) NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `document_number` varchar(255) NOT NULL,
  `api_token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `phone`, `password`, `document_number`, `api_token`, `created_at`, `updated_at`) VALUES
(1, 'dimash', 'aizharykov', '8129312', '$2a$10$w/v34NQsDDH0v7yuV1cg5e07CqRGp9Hcl873ZX/0N3x.ss3yb0yam', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE2ODMsImV4cCI6MTcwOTk3NTI4M30.kqo3LVCSW1qxGn7S014xEhxzArGa0ldY_ZeT3YEB-Yg', '2024-03-09 10:08:03', '2024-03-09 10:08:03'),
(2, 'dimash', 'aizharykov', '8129312', '$2a$10$1GecKrfg5APw48UAi1sh9.hue.rLM8JNqGv3C9lTcU9hN9RakmhIS', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE3MTMsImV4cCI6MTcwOTk3NTMxM30.-bsCICmd_wK5OjOkwpqqCqfJJCfk5V04DkcH26hw718', '2024-03-09 10:08:33', '2024-03-09 10:08:33'),
(3, 'dimash', 'aizharykov', '8129312', '$2a$10$4.TRMq731QRoWSa7CHx48elI3Yrdfc4SbQTOCEwAbqIaNrRvflmOy', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE3NjQsImV4cCI6MTcwOTk3NTM2NH0.ChsGnm69lqaV5mcdTHGQYCDTocJa7Q32Ps5jhu5lacg', '2024-03-09 10:09:24', '2024-03-09 10:09:24'),
(4, 'dimash', 'aizharsykov', '8129312', '$2a$10$wm9EKzN0O7eTHaPqT5cLMuQnd1HRKRZgiSq0Y2NgHEF.97Z.DVXiS', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE3ODIsImV4cCI6MTcwOTk3NTM4Mn0.UEpEln-q6fjaSwULbJ0IeMXEQrR4ctlUBq7ch2h0wfQ', '2024-03-09 10:09:42', '2024-03-09 10:09:42'),
(5, 'dimash', 'aizharsykov', '8129312', '$2a$10$W5LE9mhQWndoD/40Yc2p..U6qgW6pDH1kdUf8VJGql6ko1sGqDLzK', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE4MDQsImV4cCI6MTcwOTk3NTQwNH0.JJ-GMvcYQGzyolLUymfx30Ua4cJek4nKkdSipFVriRE', '2024-03-09 10:10:05', '2024-03-09 10:10:05'),
(6, 'dimash', 'aizharsykov', '8129312', '$2a$10$CybyqUkIdHMPpzQx6rJsEeG2aLB3Z.IyUeZyndatfAeUtPQaUig16', '1023023', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjgxMjkzMTIiLCJpYXQiOjE3MDk5NzE4MTksImV4cCI6MTcwOTk3NTQxOX0.uyaO0bMwRpk_JHx9lkNVWZbjnIVY8prCGBeOsvKQVOA', '2024-03-09 10:10:19', '2024-03-09 10:10:19'),
(7, 'asd', 'asdasd', '83838383838', '$2a$10$4YPQrFYW7JHDksd.z4v8EuDxqdOkSfhUf7GINlkr4avKl/7Ek9tE6', '122121', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6ODM4MzgzODM4MzgsImlhdCI6MTcwOTk3MjQ1NiwiZXhwIjoxNzA5OTc2MDU2fQ.UbZWZb7lLS11CCCLOIPUOQnWZwjz4F00C_cPJUGKokE', '2024-03-09 10:14:16', '2024-03-09 10:14:16');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `airports`
--
ALTER TABLE `airports`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `flights`
--
ALTER TABLE `flights`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `passengers`
--
ALTER TABLE `passengers`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `airports`
--
ALTER TABLE `airports`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `flights`
--
ALTER TABLE `flights`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `passengers`
--
ALTER TABLE `passengers`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
