-- name: Mohsen Elrhazi
 -- gmail: mohsenelrhazi3@gmail.com

 -- Créeaton de la base de données films_db
CREATE DATABASE films_db;

-- Utilisation de la base de données
USE films_db;

-- Créeation de la table subscription
CREATE TABLE subscription(
SubscriptionID INT PRIMARY KEY AUTO_INCREMENT,
SubscriptionType VARCHAR(50) NOT NULL CHECK (SubscriptionType IN ('Basic','Standard','Premium')),
MonthlyFee DECIMAL(10,2) NOT NULL
);

-- Créeation de la table review
CREATE TABLE review(
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    Rating INT NOT NULL,
    ReviewText TEXT NULL,
    ReviewDate DATE NOT NULL
);

-- Créeation de la table movie
CREATE TABLE movie(
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255)  NOT NULL,
    Genre VARCHAR(100)  NOT NULL,
    ReleaseYear INT  NOT NULL,
    Duration INT  NOT NULL,
    Rating VARCHAR(10) NOT NULL
);

-- Créeation de la table utilisateur
CREATE TABLE utilisateur(
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100)  NOT NULL,
    LastName VARCHAR(100)  NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL,
    SubscriptionID INT  NOT NULL
);

-- Créeation de la table watchhistory
CREATE TABLE watchhistory(
    WatchHistoryID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    WatchDate DATE NOT NULL,
    CompletionPercentage INT NOT NULL DEFAULT 0
);

-- Ajouter la constrainte foreign key pour la colonne SubscriptionID de la table utilisateur
ALTER TABLE utilisateur 
ADD CONSTRAINT fk_SubscriptionID FOREIGN KEY(SubscriptionID) references subscription(subscriptionID);

-- Ajouter la constrainte foreign key pour la colonne UserID de la table review
ALTER TABLE review
ADD CONSTRAINT fk_UserID FOREIGN KEY(UserID) references utilisateur(UserID);

-- Ajouter la constrainte foreign key pour la colonne UserID de la table watchhistory
ALTER TABLE watchhistory
ADD CONSTRAINT fk_UserID_watchhistory FOREIGN KEY(UserID) references utilisateur(UserID);

-- Ajouter la constrainte foreign key pour la colonne MovieID de la table watchhistory
ALTER TABLE watchhistory
ADD CONSTRAINT fk_MovieID FOREIGN KEY(MovieID) references movie(MovieID);

-- Ajouter la constrainte foreign key pour la colonne MovieID de la table review
ALTER TABLE review
ADD CONSTRAINT fk_MovieID_review FOREIGN KEY(MovieID) references movie(MovieID);

-- 1.Insérer un film : Ajouter un nouveau film intitulé Data Science Adventures dans le genre "Documentary"
INSERT INTO movie (Title, Genre, ReleaseYear, Duration, Rating) 
VALUES ('Data Science Adventures', 'Documentary', 2024, 120, '8.9');

-- 2.Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020
SELECT * FROM movie
where Genre='Comedy' AND ReleaseYear > 2020;

-- 3.Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"
UPDATE utilisateur AS u
JOIN subscription AS s 
ON u.SubscriptionID = s.SubscriptionID
SET s.SubscriptionType = 'Premium'
WHERE s.SubscriptionType = 'Basic';

-- 4.Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT u.UserID, u.FirstName, u.LastName, u.Email,u.RegistrationDate,s.SubscriptionType
FROM utilisateur AS u
JOIN subscription AS s
ON u.SubscriptionID = s.SubscriptionID;

-- 5.Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.
SELECT u.UserID, u.FirstName, u.LastName, m.MovieID, m.Title, m.Genre, m.ReleaseYear, wh.WatchDate, wh.CompletionPercentage
FROM utilisateur AS u
JOIN watchhistory AS wh ON u.UserID = wh.UserID
JOIN movie AS m ON wh.MovieID = m.MovieID
WHERE wh.CompletionPercentage =100;

