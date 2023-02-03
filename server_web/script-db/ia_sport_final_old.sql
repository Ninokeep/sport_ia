-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : my_db
-- Généré le : lun. 06 déc. 2021 à 10:07
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
  `commentaire` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `entrainement`
--

INSERT INTO `entrainement` (`id`, `nom`, `niveau`, `gif`, `commentaire`) VALUES
(1, 'jambe', 'debutant', NULL, 'descend bien sur ta jambe'),
(2, 'jambe', 'expert', NULL, 'descend très très bas');

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
  `repetition_fait` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`id`, `id_entrainement`, `id_user`, `fini`, `message_user`, `repetition_fait`) VALUES
(1, 1, 20, 1, 'lol', 1),
(2, 2, 20, 1, 'trop ez', 0),
(3, 1, 28, 0, NULL, NULL);

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
(1, 'repetition', 20, 1),
(3, 'repetition', 15, 3),
(4, 'repetition', 25, 2);

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
  `rule` tinyint(1) NOT NULL DEFAULT '0',
  `numero_telephone` varchar(50) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `age` int(11) NOT NULL,
  `pathologie` varchar(255) DEFAULT NULL,
  `seance_restante` int(11) NOT NULL DEFAULT '0',
  `id_kine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `nom`, `prenom`, `sexe`, `email`, `password`, `rule`, `numero_telephone`, `token`, `age`, `pathologie`, `seance_restante`, `id_kine`) VALUES
(20, 'jean', 'jean', 0, 'jean@gmail.com', 'sha256$Qc8DBBwgevjcHrsu$2523f3e8598a484cc3fc4a30267b7792da835769bc2c533ec7c73befea05b65d', 0, '0485463125', NULL, 27, 'tendinite genoux droit', 6, 27),
(27, 'delmu', 'joé', 1, 'joe@gmail.com', '12345678', 1, '0494425682', NULL, 28, NULL, 0, NULL),
(28, 'cavallaro', 'maria', 1, 'maria@gmail.com', '12345678', 0, '0495534333', NULL, 54, NULL, 8, 27);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `entrainement`
--
ALTER TABLE `entrainement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `entrainement_FK` (`id_entrainement`),
  ADD KEY `user_FK` (`id_user`);

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
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `entrainement`
--
ALTER TABLE `entrainement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `session`
--
ALTER TABLE `session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `session_meta`
--
ALTER TABLE `session_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `entrainement_FK` FOREIGN KEY (`id_entrainement`) REFERENCES `entrainement` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_FK` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `session_meta`
--
ALTER TABLE `session_meta`
  ADD CONSTRAINT `session_to_meta_FK` FOREIGN KEY (`id_session`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
