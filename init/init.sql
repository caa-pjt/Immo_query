-- Description: Ce script permet de créer les tables et d'insérer des données dans la base de données

-- Activer les contraintes de clés étrangères
SET foreign_key_checks = 1;

-- Supprimer les tables existantes
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `nouvelles_donnees`;
DROP TABLE IF EXISTS `indice_insee`;
DROP TABLE IF EXISTS `bien_immo`;

-- Création des tables avec les contraintes de clés étrangères
CREATE TABLE IF NOT EXISTS `bien_immo` (
  `id_bien` integer PRIMARY KEY NOT NULL,
  `valeur_fonciere_actuelle` float,
  `no_voie` integer,
  `bis_ter_quater` varchar(10) DEFAULT NULL,
  `type_de_voie` varchar(30),
  `code_voie` integer,
  `voie` varchar(500),
  `code_postal` varchar(10),
  `commune` varchar(100),
  `code_departement` varchar(5),
  `code_commune` integer,
  `surface` float,
  `type` varchar(50),
  `nb_pieces` integer
);

CREATE TABLE IF NOT EXISTS `indice_insee` (
  `date` DATE PRIMARY KEY NOT NULL,
  `indice_prix_logement` FLOAT
);

CREATE TABLE IF NOT EXISTS `nouvelles_donnees` (
  `commune` TEXT,
  `surface` NUMERIC,
  `valeur_fonciere_actuelle` NUMERIC,
  `type` TEXT,
  `adresse` TEXT
);

CREATE TABLE IF NOT EXISTS `transactions` (
  `date_vente` DATE,
  `valeur_fonciere` FLOAT,
  `bien_immobilier` INTEGER,
  FOREIGN KEY (`bien_immobilier`) REFERENCES `bien_immo` (`id_bien`),
  FOREIGN KEY (`date_vente`) REFERENCES `indice_insee` (`date`)
);

