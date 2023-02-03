-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : my_db
-- Généré le : sam. 05 fév. 2022 à 10:49
-- Version du serveur : 5.7.36
-- Version de PHP : 7.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ia_sport`
--

-- --------------------------------------------------------

--
-- Structure de la table `entrainement`
--

CREATE TABLE `entrainement` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `niveau` varchar(50) NOT NULL,
  `gif` blob,
  `cote` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `entrainement`
--

INSERT INTO `entrainement` (`id`, `nom`, `niveau`, `gif`, `cote`) VALUES
(1, 'jambe', 'debutant', NULL, 'droit'),
(5, 'main', 'intermediaire', NULL, 'droit'),
(6, 'jambe', 'debutant', NULL, 'gauche');

-- --------------------------------------------------------

--
-- Structure de la table `kine`
--

CREATE TABLE `kine` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `kine`
--

INSERT INTO `kine` (`id`, `nom`, `prenom`, `email`, `password`) VALUES
(1, 'joe', 'demut', 'joe@gmail.com', '$2b$10$PqPDcgm0oLB4n3/5KMKCsOxfzMEAx4zdSa2OGXjVDhPXkF8V9d/Jq'),
(5, 'fabrizio', 'villani', 'fa@gmail.com', '$2b$10$PqPDcgm0oLB4n3/5KMKCsOxfzMEAx4zdSa2OGXjVDhPXkF8V9d/Jq'),
(12, 'fabrizio', 'villani', 'jean@gmail.com', '$2b$10$7GYH8TN33hECdKcQCShT7e2K7Lg7.N7bvamuN5JN5R.kwqm0hjCzK'),
(17, 'fabrizio', 'villani', 'draketrois@gmail.com', '$2b$10$CyLe2E2z3/Q2yhbdArEhhufmLmssJHuL85igwE6sAk.cZyReDHW.u'),
(18, 'fabrizio', 'villani', 'drake2@gmail.com', '$2b$10$4Hdid03zFjhUteG/wO/3X.8R7ERjh.NKsIq0sbR6.jCpQ4OWdws0C'),
(21, 'test', 'lol', 'asaprocky@gmail.com', '$2b$10$iwJQ3.zYcZqSd5fcj3sNfuoi3PJz50U/qerjjU8w0Mh.ABFqj0epG');

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

CREATE TABLE `session` (
  `id` int(11) NOT NULL,
  `id_entrainement` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `fini` tinyint(1) NOT NULL DEFAULT '0',
  `message_user` varchar(255) DEFAULT NULL,
  `repetition_fait` int(11) DEFAULT '0',
  `id_kine` int(11) NOT NULL,
  `commentaire_kine` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`id`, `id_entrainement`, `id_user`, `fini`, `message_user`, `repetition_fait`, `id_kine`, `commentaire_kine`) VALUES
(20, 1, 47, 0, NULL, 0, 1, 'fais doucement'),
(21, 1, 42, 1, 'j\'ai eu quelques difficultés à faire cet exercice ', 0, 1, 'fais doucement'),
(22, 1, 42, 1, 'ijijiji', 9, 1, 'descends bien'),
(23, 1, 43, 0, NULL, 0, 1, 'descends bien drake'),
(25, 1, 42, 1, 'salutr', 0, 1, 'ze'),
(26, 6, 42, 0, NULL, 0, 1, 'attention à ta jambe quand tu fais la flexion');

-- --------------------------------------------------------

--
-- Structure de la table `session_meta`
--

CREATE TABLE `session_meta` (
  `id` int(11) NOT NULL,
  `meta_name` varchar(255) NOT NULL,
  `meta_value` int(11) NOT NULL,
  `id_session` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `session_meta`
--

INSERT INTO `session_meta` (`id`, `meta_name`, `meta_value`, `id_session`) VALUES
(4, 'nombre_repetition', 100, 20),
(5, 'nombre_repetition', 25, 21),
(6, 'nombre_repetition', 25, 22),
(7, 'nombre_repetition', 25, 23),
(9, 'nombre_repetition', 10, 25),
(10, 'nombre_repetition', 2, 26);

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `sexe` tinyint(1) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `pathologie` varchar(255) DEFAULT NULL,
  `seance_restante` int(11) NOT NULL DEFAULT '0',
  `id_kine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `nom`, `prenom`, `sexe`, `email`, `password`, `age`, `pathologie`, `seance_restante`, `id_kine`) VALUES
(42, 'cavallaro', 'fabrizio', 0, 'fabrizio@gmail.com', '$2b$10$OMP3.aaX2pwNp7EqX46aM.diVx1INCuRNunrkskqWRoUU5zMioDzK', 50, 'tendinite de la main', 12, 1),
(43, 'drake', 'grahbam', 0, 'drake@gmail.com', '$2b$12$IUNuhw/fvzFbjGgaT7SceuqE9eXQQjjtkvPmRaN7/Yxy2lfuPuvha', 27, 'tendinite jambe droite', 15, 1),
(47, 'drake', 'grahbam', 0, 'drakee@gmail.com', '$2b$12$w/d0l0yFSKMMVEgpSDbRlu3q5vHL3oVAEmX7g11AFi2LmVa34o8SO', 27, 'tendinite jambe droite', 15, 5),
(50, 'deep', 'learning', 0, 'joemaniae@gmail.com', '$2b$10$2AO/yMnkqPUu9hB8xIkUUexMfCZOsvG/bX/ZoDarKh8A9qsLWRtq.', 27, 'tendinite main droite', 5, 5),
(51, 'cavallaro', 'maria', 0, 'maria@gmail.com', '$2b$10$wSv6tI2fSaGIKW7Jq9TXr.g9OrKBxeNuxBGSe9lzzvBDaXPlWaOM2', 20, 'tendinite', 15, 1);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `entrainement`
--
ALTER TABLE `entrainement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `kine`
--
ALTER TABLE `kine`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `ix_kine_id` (`id`);

--
-- Index pour la table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `entrainement_FK` (`id_entrainement`),
  ADD KEY `user_FK` (`id_user`),
  ADD KEY `kineFk_FK` (`id_kine`);

--
-- Index pour la table `session_meta`
--
ALTER TABLE `session_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_to_meta_FK` (`id_session`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `kine_FK` (`id_kine`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `entrainement`
--
ALTER TABLE `entrainement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `kine`
--
ALTER TABLE `kine`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `session`
--
ALTER TABLE `session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pour la table `session_meta`
--
ALTER TABLE `session_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `entrainement_FK` FOREIGN KEY (`id_entrainement`) REFERENCES `entrainement` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `kineFk_FK` FOREIGN KEY (`id_kine`) REFERENCES `kine` (`id`),
  ADD CONSTRAINT `user_FK` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `session_meta`
--
ALTER TABLE `session_meta`
  ADD CONSTRAINT `session_to_meta_FK` FOREIGN KEY (`id_session`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `kine_FK` FOREIGN KEY (`id_kine`) REFERENCES `kine` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
