
 --name: Mohsen Elrhazi
 --gmail: mohsenelrhazi3@gmail.com

 --Créeaton de la base de données films_db
CREATE DATABASE films_db;

-- Utilisation de la base de données
USE films_db;

--Créeation de la table subscription
CREATE TABLE subscription(
SubscriptionID INT PRIMARY KEY AUTO_INCREMENT,
SubscriptionType VARCHAR(50) CHECK (SubscriptionType IN ('Basic','Standard','Premium')),
MonthlyFee DECIMAL(10,2)
);

--Créeation de la table review
CREATE TABLE review(
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    MovieID INT,
    Rating INT,
    ReviewText TEXT,
    ReviewDate DATE
);

--Créeation de la table movie
CREATE TABLE movie(
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Genre VARCHAR(100),
    ReleaseYear INT,
    Duration INT,
    Rating VARCHAR(10)
);

--Créeation de la table utilisateur
CREATE TABLE utilisateur(
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    RegistrationDate DATE,
    SubscriptionID INT
);

--Créeation de la table watchhistory
CREATE TABLE watchhistory(
    WatchHistoryID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    MovieID INT,
    WatchDate DATE,
    CompletionPercentage INT
);

--Ajouter la constrainte DEFAULT 0 pour CompletionPercentage de la table watchhistory
ALTER TABLE watchhistory
MODIFY COLUMN CompletionPercentage INT DEFAULT 0;

--Ajouter la constrainte NULL pour la colonne ReviewText de la table review
ALTER TABLE review
MODIFY COLUMN ReviewText Text NULL;

--Ajouter la constrainte foreign key pour la colonne SubscriptionID de la table utilisateur
ALTER TABLE utilisateur 
ADD CONSTRAINT fk_SubscriptionID FOREIGN KEY(SubscriptionID) references subscription(subscriptionID);

--Ajouter la constrainte foreign key pour la colonne UserID de la table review
ALTER TABLE review
ADD CONSTRAINT fk_UserID FOREIGN KEY(UserID) references utilisateur(UserID);

--Ajouter la constrainte foreign key pour la colonne UserID de la table watchhistory
ALTER TABLE watchhistory
ADD CONSTRAINT fk_UserID_watchhistory FOREIGN KEY(UserID) references utilisateur(UserID);

--Ajouter la constrainte foreign key pour la colonne MovieID de la table watchhistory
ALTER TABLE watchhistory
ADD CONSTRAINT fk_MovieID FOREIGN KEY(MovieID) references movie(MovieID);