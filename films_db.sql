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
