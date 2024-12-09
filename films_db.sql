CREATE DATABASE films_db;

USE films_db;
CREATE TABLE subscription(
SubscriptionID INT PRIMARY KEY AUTO_INCREMENT,
SubscriptionType VARCHAR(50) CHECK (SubscriptionType IN ('Basic','Standard','Premium')),
MonthlyFee DECIMAL(10,2)
);

CREATE TABLE review(
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    MovieID INT,
    Rating INT,
    ReviewText TEXT,
    ReviewDate DATE
);

CREATE TABLE movie(
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Genre VARCHAR(100),
    ReleaseYear INT,
    Duration INT,
    Rating VARCHAR(10)
);