-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 23 mars 2025 à 23:58
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `geeksforgeeks`
--

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `Username` text NOT NULL,
  `Password` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`Username`, `Password`) VALUES
('admin1', 'admin123'),
('admin', 'admin123');

-- --------------------------------------------------------

--
-- Structure de la table `destinations`
--

DROP TABLE IF EXISTS `destinations`;
CREATE TABLE IF NOT EXISTS `destinations` (
  `id` int NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `phonenumber` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `destinations`
--

INSERT INTO `destinations` (`id`, `firstname`, `lastname`, `email`, `country`, `phonenumber`) VALUES
(0, 'ddd', 'sdfd', 'yeomika50@gmail.com', 'Bahamas', '788777'),
(0, 'Mikael', 'Yeo', 'yeomika50@gmail.com', 'Austria', '788777'),
(0, 'mika', 'Yeo', 'yeomika320@gmail.com', 'Bahrain', '0798199889'),
(0, 'jacob', 'soro', 'yeomika50@gmail.com', 'Belize', '455677'),
(0, 'opp', 'jj', 'euryr2@gmail.com', 'Bangladesh', '22222');

-- --------------------------------------------------------

--
-- Structure de la table `student`
--

DROP TABLE IF EXISTS `student`;
CREATE TABLE IF NOT EXISTS `student` (
  `id` int NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `Photo` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `major` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `student`
--

INSERT INTO `student` (`id`, `firstname`, `lastname`, `email`, `Photo`, `major`) VALUES
(106330, 'Paul Eliel', 'Kouame', 'kouamep2@student.iugb.edu.ci', 'https://i.ibb.co/gMC9W754/Whats-App-Image-2025-03-21-at-00-45-19-ab9f3d27.jpg', 'Computer science'),
(106544, 'christ bassole', 'gnamke', 'bassole3@student.iugb.edu.ci', 'https://i.ibb.co/RdSJnCX/Whats-App-Image-2025-03-21-at-09-53-51-b9dd7e06.jpg', 'BBA'),
(106333, 'Jacob', 'Yeo', 'yeoj1@student.iugb.edu.ci', 'https://i.ibb.co/23zZY4pg/Whats-App-Image-2025-03-22-at-13-14-41-e5eb5b7e.jpg', 'data science'),
(106545, 'Cheick', 'Traore', 'traorec12@student.iugb.edu.ci', 'https://i.ibb.co/MknxL60w/Whats-App-Image-2025-03-23-at-21-28-06-9d91a88a.jpg', 'Political science');

-- --------------------------------------------------------

--
-- Structure de la table `user-account`
--

DROP TABLE IF EXISTS `user-account`;
CREATE TABLE IF NOT EXISTS `user-account` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `cpassword` varchar(50) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `user-account`
--

INSERT INTO `user-account` (`id`, `username`, `password`, `cpassword`, `date`) VALUES
(0, 'dd', '$2y$10$twH/fqA.3SyWmXqtKD0Z/ePMw2HdztSp984X7TYrRxD', '', '2024-10-29 22:21:20'),
(0, 'Mikaelyeo', '$2y$10$ZggGB.sZ6SjCM8CoZfDEde1/L8T9uIg1egVdHz4pI7K', '', '2024-10-29 23:33:55'),
(0, 'miki', '$2y$10$NcuQtS2X9CkKcPc4tvLbIOn/7cwoeqNZT3AdM5/jOVr', '', '2024-10-29 23:34:14'),
(0, 'greg', '$2y$10$nDsNzBUbZSpsYAQCRhd/5u.yfeq6I5hDJ/G.bm6Yrcg', '', '2024-10-29 23:35:02'),
(0, 'jacob', '$2y$10$RwuIGKU71rVS00y073vs7OGNR4/HqZJ0yHxihNYknMW', '', '2024-10-29 23:46:25'),
(0, 'kdodo', '$2y$10$YnNY5AGu.hh4fW2lXa/iH.0pgdKPM1icOs5/T5G7xc8', '', '2024-10-29 23:53:18'),
(0, 'luna', '$2y$10$NoFZVTLP7xCvB2m104bFROd9fIVs7.Z0rgluMEn4yi2', '', '2024-10-30 00:01:49'),
(0, 'kile', '$2y$10$puWitqUvfAwwwzpf76dRCecL7b96pQ/bUNyBiGM6JRE', '', '2024-10-30 00:11:03'),
(0, 'Jacob_2', '$2y$10$JcxUST023NbTilwK.NWFWOvUS3M8ECikWqCXQ.LRxGz', '', '2024-10-30 00:15:02'),
(0, 'wer', '$2y$10$CC2vtpP/XAnLeu5YZwUSL.SrBdhRqPl85u8jjDHr2H3', '', '2024-10-30 08:53:50'),
(0, 'mika', '$2y$10$C2CrauvJjA1fCFs0H5I5uu0YneeoeiIynFXzrIuIMgn', '', '2024-10-30 10:21:13'),
(0, 'kouame', '$2y$10$XHVAcZX7xYYCitGv.SfSI.wXZ8Oi1GOXpqy9osxgsSE', '', '2024-10-30 10:50:12'),
(0, 'mk', '$2y$10$z/Uuy52CqCkXuQERfreLmu0IVFgStIWAhQRvqDnbUYU', '', '2024-11-02 22:07:54'),
(0, 'nmm', '$2y$10$Kt5AjmMRvIceRS9h3Uw3Pu1S9uIlzSatY/g5o8yir6q', '', '2024-11-24 20:27:45'),
(0, 'er', '$2y$10$aTkC0RrIckTjmnMh6TnI1Ozv7go1tiHF99rSg8Eou/4', '', '2024-12-01 21:43:37'),
(0, '', '$2y$10$B/tndcSOS6HoJ9IqJIiaEuBrb0mbuVjimDqQX7Wz1KS', '', '2024-12-09 01:10:10'),
(0, '', '$2y$10$SIDspwJ9yya/pdrqE/5qqOU/LsAtZcuFnord67HT0m/', '', '2024-12-09 01:11:54'),
(0, '', '$2y$10$ns3g84DHiiyDpc.yc4oz1Op0SFLgAYmWEm5CALfHpHG', '', '2024-12-09 01:12:12'),
(0, '', '$2y$10$vHlI2nk/SKWioaseUO7GJeOamYxTkOfNQrWPi2tr.1N', '', '2024-12-09 01:13:00'),
(0, '', '$2y$10$xnfnY9/RTuzp.3p84Wwyv.K83EwKdENuGziCshU9C3E', '', '2024-12-09 01:13:43'),
(0, '', '$2y$10$o7iQwuyqzS5VrKCVowuC0./YOMV3tQhjNXKNibs0uJq', '', '2024-12-09 01:13:51'),
(0, '', '$2y$10$mve.EUKydMoyv03o2pkJfuUFxLYTJQNKM8KBvjRZiln', '', '2024-12-09 01:14:03'),
(0, '', '$2y$10$/TvqF6c1J8AdAbXlRH7E9.S863UKuYxkXmvWWutom2S', '', '2024-12-09 01:18:59');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cpassword` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `cpassword`, `date`) VALUES
(0, 'Mikaelyeo', '$2y$10$9M13xU1XcLOdaj8ZV9lfvON2iqQw544dgSrb66VgEsfZiEZf3bHCa', '', '2024-10-09 10:09:31'),
(0, 'mika', '$2y$10$.QsnxyAiyLsLenu1Tu3qx.Gz6R5RCv36H..n773On2XZxE1m2tsAC', '', '2024-10-09 10:14:14'),
(0, 'Yeo', '$2y$10$8BnSCgQXWxUYmX1pAWDuQ.DaEgQS/TStpt8NIi.TmJDwR8bthLZzW', '', '2024-10-09 10:15:58'),
(0, 'Chimingnon', '$2y$10$zoSBWcZAf7nzjZxFP99Obu7gX/ahFx2qGGkJXmN5m4Y1rXe/d6mhW', '', '2024-10-09 10:17:31'),
(0, 'yeomikael', '$2y$10$flu7vMm7G6/b3gMcvtrFTuViohiRo78ZES0mHQncdQkZeMZvLmJAa', '', '2024-10-09 11:08:36'),
(0, 'tra', '$2y$10$iyohn0aQgCVA/pNrB/0fMeQBVFoj8iCxSK2Vb6c2u5TguLW15fqpq', '', '2024-10-14 10:12:51'),
(0, 'abd', '$2y$10$jbFO31mSIHfBLa0RmKE8J.GV8nizvPf.3z3alpnj6r6xc0.k8hm7K', '', '2024-10-29 22:44:30'),
(0, 'tyu', '$2y$10$hH8fYEe54ZkbRyYcwqFRx.8V.OF1fqWo.9d/F7d7v52AqlMjTVvKm', '', '2024-10-29 23:13:39');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
