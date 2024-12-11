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

-- 6.Trier et limiter : Afficher les 5 films les plus longs, triés par durée.
SELECT Title, Genre, Duration
FROM movie 
ORDER BY Duration DESC
LIMIT 5

-- 7.Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.
SELECT m.MovieID, m.Title, AVG(wh.CompletionPercentage) AS pourcentage_moyen_complétion
FROM movie AS m
JOIN watchhistory AS wh
ON m.MovieID=wh.MovieID
GROUP BY m.MovieID, m.Title

-- 8.Group By : Grouper les utilisateurs par type d’abonnement et compter le nombre total d’utilisateurs par groupe.
SELECT s.SubscriptionType, count(u.UserID) as nbr_utilisateurs
FROM utilisateur AS u
JOIN subscription AS s
ON u.SubscriptionID=s.subscriptionID
GROUP BY s.SubscriptionType

-- 9.Sous-requête (Bonus): Trouver les films ayant une note moyenne supérieure à 4.
SELECT m.MovieID, m.Title, AVG(r.Rating) AS moyen_rating
FROM movie AS m
JOIN review AS r
ON m.MovieID=r.MovieID
GROUP BY m.MovieID, m.Title
HAVING AVG(r.Rating) > 4
--ou HAVING  moyen_rating >4

-- 2eme methode sous-requete
SELECT m.MovieID, m.Title, (SELECT AVG(Rating) FROM review AS r where m.MovieID = r.MovieID ) AS moyen_rating
FROM movie AS m
GROUP BY m.MovieID, m.Title
HAVING moyen_rating > 4;


-- 10.& (Bonus): Trouver des paires de films du même genre sortis la même année.
SELECT A.MovieID, B.MovieID,A.Title AS movie_1, B.Title AS movie_2, A.Genre, A.ReleaseYear
FROM movie AS A, movie AS B
WHERE A.MovieID < B.MovieID
AND A.Genre=B.Genre
AND A.ReleaseYear=B.ReleaseYear;


-- 11.CTE (Bonus): Lister les 3 films les mieux notés grâce à une expression de table commune.
CREATE VIEW trois_films_notés AS
SELECT M.MovieID, m.Title, r.Rating
FROM movie AS m
JOIN review AS r
ON m.MovieID=r.MovieID
ORDER BY r.Rating DESC
LIMIT 3;

-- 11. 2eme methode 
WITH trois_films_notés AS (
    SELECT M.MovieID, M.Title, R.Rating
    FROM movie AS M
    JOIN review AS R
    ON M.MovieID = R.MovieID
    ORDER BY R.Rating DESC
)
SELECT *
FROM trois_films_notés
LIMIT 3;

-- 12.Trigger (Bonus): Créer un trigger qui enregistre une alerte lorsqu’un film obtient une note moyenne inférieure à 3.
-- DROP TRIGGER alert_faible_rating;

CREATE TABLE alerts(
    AlertID INT PRIMARY KEY AUTO_INCREMENT,
    Message VARCHAR(255) NOT NULL,
    MovieID int NOT NULL,
    DateAlert DATE NOT NULL,
    FOREIGN KEY(MovieID) REFERENCES movie(MovieID)
);

CREATE TRIGGER alert_faible_rating
AFTER INSERT
ON review
FOR EACH ROW
BEGIN
IF((SELECT AVG(Rating) FROM review WHERE MovieID = NEW.MovieID) < 3) 
THEN
INSERT INTO alerts(Message, MovieID, DateAlert)
VALUES('film obtient une note moyenne inférieure à 3', NEW.MovieID, NOW());
END IF;
END;