-- RaceDay-System Database
-- SQL Database Script for SSMS
CREATE DATABASE RaceDaySystem;
GO

USE RaceDaySystem;
GO

-- 1. Roles
CREATE TABLE Roles (
    RoleId INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(100) NOT NULL UNIQUE
);
GO

-- 2. Users
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleId INT NOT NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleId)
        REFERENCES Roles(RoleId)
);
GO

-- 3. Categories
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(100) NOT NULL,
    Distance DECIMAL(10,2) NOT NULL,
    Fee DECIMAL(10,2) NOT NULL
);
GO

-- 4. Events
CREATE TABLE Events (
    EventId INT PRIMARY KEY IDENTITY(1,1),
    EventName VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(200) NOT NULL,
    OrganiserId INT NOT NULL,

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserId)
        REFERENCES Users(UserId)
);
GO

-- 5. EventCategories
-- Junction table resolving the many-to-many
-- relationship between Events and Categories.
CREATE TABLE EventCategories (
    EventCategoryId INT PRIMARY KEY IDENTITY(1,1),
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
GO

-- 6. Enrolments
CREATE TABLE Enrolments (
    EnrolmentId INT PRIMARY KEY IDENTITY(1,1),
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
GO

-- 7. Results
CREATE TABLE Results (
    ResultId INT PRIMARY KEY IDENTITY(1,1),
    EnrolmentId INT NOT NULL,
    FinishTime TIME NOT NULL,
    [Rank] INT NOT NULL,

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentId)
        REFERENCES Enrolments(EnrolmentId)
);
GO

-- =============================================
-- SEED DATA
-- =============================================

-- Seed Roles
INSERT INTO Roles (RoleName)
VALUES
    ('Organiser'),
    ('Participant');
GO

-- Seed Users (2 Organisers, 2 Participants)
INSERT INTO Users (FullName, Email, PasswordHash, RoleId)
VALUES
    ('Alice Smith', 'alice.organiser@raceday.com', 'hashed_pass_1', 1),
    ('Bob Jones', 'bob.organiser@raceday.com', 'hashed_pass_2', 1),
    ('Charlie Brown', 'charlie.runner@raceday.com', 'hashed_pass_3', 2),
    ('Diana Prince', 'diana.runner@raceday.com', 'hashed_pass_4', 2);
GO

-- Seed Categories
INSERT INTO Categories (CategoryName, Distance, Fee)
VALUES
    ('5km Fun Run', 5.00, 150.00),
    ('10km Challenge', 10.00, 200.00),
    ('21km Half Marathon', 21.00, 300.00);
GO

-- Seed Events (3 Events)
INSERT INTO Events (EventName, EventDate, Location, OrganiserId)
VALUES
    ('Durban Coastal Marathon', '2026-10-15', 'Durban Promenade', 1),
    ('City Center Sprint', '2026-11-01', 'Central Park', 1),
    ('Summer Trail Run', '2026-12-05', 'Green Valley Trail', 2);
GO

-- Seed EventCategories
INSERT INTO EventCategories (EventId, CategoryId)
VALUES
    (1, 2), -- Durban Coastal: 10km
    (1, 3), -- Durban Coastal: 21km
    (2, 1), -- City Sprint: 5km
    (3, 1), -- Summer Trail: 5km
    (3, 2); -- Summer Trail: 10km
GO

-- Seed Enrolments
INSERT INTO Enrolments (ParticipantId, EventCategoryId, EnrolmentDate, PaymentStatus)
VALUES
    (3, 1, '2026-09-01', 'Paid'),
    (4, 1, '2026-09-02', 'Paid'),
    (3, 3, '2026-09-05', 'Paid');
GO

-- Seed Results
INSERT INTO Results (EnrolmentId, FinishTime, [Rank])
VALUES
    (1, '00:45:30', 1),
    (2, '00:48:15', 2);
GO