-- RaceDay-System Database
-- SQL Database Script

CREATE DATABASE IF NOT EXISTS RaceDaySystem;

USE RaceDaySystem;

-- 1. Roles
CREATE TABLE Roles (
    RoleId INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Users
CREATE TABLE Users (
    UserId INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleId INT NOT NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleId)
        REFERENCES Roles(RoleId)
);

-- 3. Categories
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    Distance DECIMAL(10,2) NOT NULL,
    Fee DECIMAL(10,2) NOT NULL
);

-- 4. Events
CREATE TABLE Events (
    EventId INT PRIMARY KEY AUTO_INCREMENT,
    EventName VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(200) NOT NULL,
    OrganiserId INT NOT NULL,

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserId)
        REFERENCES Users(UserId)
);

-- 5. EventCategories
-- Junction table resolving the many-to-many
-- relationship between Events and Categories.
CREATE TABLE EventCategories (
    EventCategoryId INT PRIMARY KEY AUTO_INCREMENT,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,

    CONSTRAINT FK_EventCategories_Events
        FOREIGN KEY (EventId)
        REFERENCES Events(EventId),

    CONSTRAINT FK_EventCategories_Categories
        FOREIGN KEY (CategoryId)
        REFERENCES Categories(CategoryId),

    CONSTRAINT UQ_EventCategories
        UNIQUE (EventId, CategoryId)
);

-- 6. Enrolments
CREATE TABLE Enrolments (
    EnrolmentId INT PRIMARY KEY AUTO_INCREMENT,
    ParticipantId INT NOT NULL,
    EventCategoryId INT NOT NULL,
    EnrolmentDate DATE NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantId)
        REFERENCES Users(UserId),

    CONSTRAINT FK_Enrolments_EventCategory
        FOREIGN KEY (EventCategoryId)
        REFERENCES EventCategories(EventCategoryId)
);

-- 7. Results
CREATE TABLE Results (
    ResultId INT PRIMARY KEY AUTO_INCREMENT,
    EnrolmentId INT NOT NULL,
    FinishTime TIME NOT NULL,
    `Rank` INT NOT NULL,

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentId)
        REFERENCES Enrolments(EnrolmentId)
);

-- Sample Roles
INSERT INTO Roles (RoleName)
VALUES
    ('Organiser'),
    ('Participant');

-- Sample Categories
INSERT INTO Categories (CategoryName, Distance, Fee)
VALUES
    ('5km', 5.00, 150.00),
    ('10km', 10.00, 200.00),
    ('21km', 21.00, 300.00);
