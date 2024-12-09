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
