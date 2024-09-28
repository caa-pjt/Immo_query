-- Description: Ce script permet de créer les tables et d'insérer des données dans la base de données

-- Supprimer les tables existantes
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `nouvelles_donnees`;
DROP TABLE IF EXISTS `indice_insee`;
DROP TABLE IF EXISTS `bien_immo`;

-- Création des tables avec les contraintes de clés étrangères
CREATE TABLE IF NOT EXISTS `bien_immo` (
  `id_bien` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `valeur_fonciere_actuelle` DECIMAL(10, 2),
  `no_voie` INT,
  `bis_ter_quater` VARCHAR(10) DEFAULT NULL,
  `type_de_voie` VARCHAR(30),
  `code_voie` INT,
  `voie` VARCHAR(500),
  `code_postal` VARCHAR(10),
  `commune` VARCHAR(100),
  `code_departement` VARCHAR(5),
  `code_commune` INT,
  `surface` DECIMAL(10, 2),
  `type` VARCHAR(50),
  `nb_pieces` INT
);

CREATE TABLE IF NOT EXISTS `indice_insee` (
  `date` DATE PRIMARY KEY NOT NULL,
  `indice_prix_logement` DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS `nouvelles_donnees` (
  `commune` TEXT,
  `surface` DECIMAL(10, 2),
  `valeur_fonciere_actuelle` DECIMAL(10, 2),
  `type` TEXT,
  `adresse` TEXT
);

CREATE TABLE IF NOT EXISTS `transactions` (
  `date_vente` DATE NOT NULL,
  `valeur_fonciere` DECIMAL(10, 2),
  `bien_immobilier` INT NOT NULL,
  PRIMARY KEY (`date_vente`, `bien_immobilier`),
  FOREIGN KEY (`bien_immobilier`) REFERENCES `bien_immo` (`id_bien`) ON DELETE CASCADE,
  FOREIGN KEY (`date_vente`) REFERENCES `indice_insee` (`date`)
);

