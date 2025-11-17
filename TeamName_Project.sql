-- ============================================================================
-- 1. HEADER META (commented out)
-- ============================================================================
/*
Team Name: JJWNNC
Team Members:

    1.Josiah Lukee
    2.Walker Moody
    3.Connor Hansen
    4.John Heitzman
    5.Noah Kung
    6.Nate Cannon

MySQL Version Tested: 8.0.x

Run Instructions:
  1. Ensure MySQL 8.x is running
  2. Execute this entire file: mysql -u root -p < TeamName_Project.sql
  3. Or copy and paste into MySQL Workbench and execute
  4. The script will drop and recreate the NFL database from scratch
*/

-- ============================================================================
-- 2. SESSION SETUP
-- ============================================================================

SET sql_mode = 'STRICT_TRANS_TABLES,ONLY_FULL_GROUP_BY';
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 3. (RE)CREATE SCHEMA
-- ============================================================================

-- Drop database if exists
DROP DATABASE IF EXISTS NFL;

-- Create database
CREATE DATABASE NFL;

-- Use database
USE NFL;

-- Drop tables if exist (in reverse dependency order)
DROP TABLE IF EXISTS team_stats;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS coaches;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS stadium;

-- Create Stadiums table
CREATE TABLE stadium (
    stadiumId INT PRIMARY KEY AUTO_INCREMENT,
    stadiumName VARCHAR(150) NOT NULL,
    locationCity VARCHAR(100) NOT NULL,
    locationState VARCHAR(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    surfaceType VARCHAR(50) NOT NULL
);

-- Create Positions table
CREATE TABLE positions (
    positionCode VARCHAR(5) PRIMARY KEY,
    positionName VARCHAR(50) NOT NULL,
    offenseOrDefense ENUM('Offense', 'Defense', 'Special') NOT NULL
);

-- Create Teams table
CREATE TABLE team (
    teamId INT PRIMARY KEY AUTO_INCREMENT,
    teamName VARCHAR(100) NOT NULL UNIQUE,
    conference ENUM('AFC','NFC') NOT NULL,
    division ENUM('East','West','North','South') NOT NULL,
    stadiumId INT,
    establishedYear INT,
    FOREIGN KEY (stadiumId) REFERENCES stadium(stadiumId)
);

-- Create Players table
CREATE TABLE player (
    playerId INT PRIMARY KEY AUTO_INCREMENT,
    teamId INT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    position VARCHAR(5),
    dob DATE,
    height INT CHECK (height IS NULL OR (height >= 60 AND height <= 90)),
    weight INT CHECK (weight IS NULL OR (weight >= 150 AND weight <= 400)),
    college VARCHAR(100),
    draftYear INT,
    draftRound INT,
    draftPick INT,
    status ENUM('Active','IR','Practice Squad') DEFAULT 'Active',
    FOREIGN KEY (teamId) REFERENCES team(teamId),
    FOREIGN KEY (position) REFERENCES positions(positionCode)
);

-- Create Coaches table
CREATE TABLE coaches (
    coachID INT PRIMARY KEY AUTO_INCREMENT,
    teamId INT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    coachPosition VARCHAR(50),
    isHeadCoach BOOLEAN DEFAULT 0,
    dob DATE,
    FOREIGN KEY (teamId) REFERENCES team(teamId)
);

-- Create Schedules/Games table
CREATE TABLE schedules (
    gameId INT PRIMARY KEY AUTO_INCREMENT,
    season INT NOT NULL CHECK (season >= 1920),
    week INT NOT NULL CHECK (week >= 1 AND week <= 18),
    gameDate DATE NOT NULL,
    gameTime TIME,
    homeTeamId INT NOT NULL,
    awayTeamId INT NOT NULL,
    stadiumId INT,
    homeScore INT DEFAULT 0 CHECK (homeScore >= 0),
    awayScore INT DEFAULT 0 CHECK (awayScore >= 0),
    FOREIGN KEY (homeTeamId) REFERENCES team(teamId),
    FOREIGN KEY (awayTeamId) REFERENCES team(teamId),
    FOREIGN KEY (stadiumId) REFERENCES stadium(stadiumId),
    CONSTRAINT chk_different_teams CHECK (homeTeamId != awayTeamId)
);

-- Create Team Stats table
CREATE TABLE team_stats (
    teamId INT NOT NULL,
    season INT NOT NULL CHECK (season >= 1920),
    pointsScored INT NOT NULL DEFAULT 0 CHECK (pointsScored >= 0),
    pointsPerGame FLOAT NOT NULL DEFAULT 0 CHECK (pointsPerGame >= 0),
    pointsAllowed INT NOT NULL DEFAULT 0 CHECK (pointsAllowed >= 0),
    passingYards INT NOT NULL DEFAULT 0 CHECK (passingYards >= 0),
    passYrdPerGame FLOAT NOT NULL DEFAULT 0 CHECK (passYrdPerGame >= 0),
    rushingYards INT NOT NULL DEFAULT 0 CHECK (rushingYards >= 0),
    rushYrdPerGame FLOAT NOT NULL DEFAULT 0 CHECK (rushYrdPerGame >= 0),
    interceptions INT NOT NULL DEFAULT 0 CHECK (interceptions >= 0),
    fumblesForced INT NOT NULL DEFAULT 0 CHECK (fumblesForced >= 0),
    fumblesRec INT NOT NULL DEFAULT 0 CHECK (fumblesRec >= 0),
    PRIMARY KEY (teamId, season),
    FOREIGN KEY (teamId) REFERENCES team(teamId)
);

-- ============================================================================
-- 4. SEED DATA (minimal - just enough for evidence queries)
-- ============================================================================

-- Insert Positions
INSERT INTO positions (positionCode, positionName, offenseOrDefense) VALUES
('QB',  'Quarterback',       'Offense'),
('RB',  'Running Back',      'Offense'),
('WR',  'Wide Receiver',     'Offense'),
('TE',  'Tight End',         'Offense'),
('SS',  'Strong Safety',     'Defense'),
('MLB', 'Middle Linebacker', 'Defense'),
('K',   'Kicker',            'Special');

-- Insert Stadiums (minimal set)
INSERT INTO stadium (stadiumName, locationCity, locationState, capacity, surfaceType) VALUES
('Gillette Stadium', 'Foxborough', 'Massachusetts', 64628, 'turf'),
('Arrowhead Stadium', 'Kansas City', 'Missouri', 76416, 'grass'),
('SoFi Stadium', 'Inglewood', 'California', 70240, 'turf'),
('Lambeau Field', 'Green Bay', 'Wisconsin', 81441, 'grass'),
('AT&T Stadium', 'Arlington', 'Texas', 80000, 'turf');

-- Insert Teams (minimal set for evidence queries)
INSERT INTO team (teamName, conference, division, stadiumId, establishedYear) VALUES
('New England Patriots', 'AFC', 'East', 1, 1959),
('Kansas City Chiefs', 'AFC', 'West', 2, 1960),
('Los Angeles Rams', 'NFC', 'West', 3, 1936),
('Green Bay Packers', 'NFC', 'North', 4, 1919),
('Dallas Cowboys', 'NFC', 'East', 5, 1960);

-- Insert Coaches
INSERT INTO coaches (teamId, firstName, lastName, coachPosition, isHeadCoach, dob) VALUES
(1, 'Jerod', 'Mayo', 'Head Coach', 1, '1986-02-23'),
(2, 'Andy', 'Reid', 'Head Coach', 1, '1958-03-19'),
(3, 'Sean', 'McVay', 'Head Coach', 1, '1986-01-24'),
(4, 'Matt', 'LaFleur', 'Head Coach', 1, '1979-11-03'),
(5, 'Mike', 'McCarthy', 'Head Coach', 1, '1963-11-10');

-- Insert Players (minimal set)
INSERT INTO player (teamId, firstName, lastName, position, dob, height, weight, college, draftYear, draftRound, draftPick, status) VALUES
(1, 'Tom', 'Brady', 'QB', '1977-08-03', 76, 225, 'Michigan', 2000, 6, 199, 'Active'),
(2, 'Patrick', 'Mahomes', 'QB', '1995-09-17', 75, 230, 'Texas Tech', 2017, 1, 10, 'Active'),
(3, 'Cooper', 'Kupp', 'WR', '1993-06-15', 74, 208, 'Eastern Washington', 2017, 3, 69, 'Active'),
(4, 'Aaron', 'Rodgers', 'QB', '1983-12-02', 74, 225, 'California', 2005, 1, 24, 'Active'),
(5, 'Dak', 'Prescott', 'QB', '1993-07-29', 75, 238, 'Mississippi State', 2016, 4, 135, 'Active');

-- Insert Schedules (minimal set - Week 1 games)
INSERT INTO schedules (season, week, gameDate, gameTime, homeTeamId, awayTeamId, stadiumId, homeScore, awayScore) VALUES
(2025, 1, '2025-09-07', '13:00:00', 1, 2, 1, 24, 31),
(2025, 1, '2025-09-07', '16:25:00', 3, 4, 3, 28, 21),
(2025, 1, '2025-09-07', '20:20:00', 5, 1, 5, 35, 14);

-- Insert Team Stats (2024 season for all teams)
INSERT INTO team_stats (teamId, season, pointsScored, pointsPerGame, pointsAllowed,
                        passingYards, passYrdPerGame, rushingYards, rushYrdPerGame,
                        interceptions, fumblesForced, fumblesRec)
VALUES
(1, 2024, 450, 26.5, 380, 4200, 247.0, 1850, 108.8, 12, 8, 6),
(2, 2024, 470, 27.6, 350, 4500, 264.7, 1900, 111.8, 15, 11, 8),
(3, 2024, 435, 25.6, 375, 4300, 252.9, 1800, 105.9, 13, 9, 7),
(4, 2024, 430, 25.3, 370, 4350, 256.0, 1850, 108.8, 14, 10, 8),
(5, 2024, 455, 26.8, 365, 4450, 261.8, 1900, 111.8, 14, 10, 8);

-- ============================================================================
-- 5. POST-CREATE (indexes, grants, etc.)
-- ============================================================================

-- Composite index for schedules table: supports queries filtering by season and week
-- Query pattern: SELECT * FROM schedules WHERE season = X AND week = Y
CREATE INDEX idx_schedules_season_week ON schedules(season, week);

-- Index for team_stats: supports queries filtering by season
CREATE INDEX idx_team_stats_season ON team_stats(season);

-- Index for player: supports queries filtering by team and position
CREATE INDEX idx_player_team_position ON player(teamId, position);

-- ============================================================================
-- 6. VERIFICATION BLOCK (three evidence queries)
-- ============================================================================

-- Evidence Query 1: Find all teams in the NFC conference with their stadium information
-- This query demonstrates JOIN operations and filters by conference
-- Requirement: R1 - System must track team information including conference and stadium
SELECT 
    t.teamName,
    t.conference,
    t.division,
    s.stadiumName,
    s.locationCity,
    s.locationState,
    s.capacity
FROM team t
JOIN stadium s ON t.stadiumId = s.stadiumId
WHERE t.conference = 'NFC'
ORDER BY t.teamName;

-- Evidence Query 2: Get all active players for a specific team with their position details
-- This query demonstrates multi-table JOIN and filtering by team and status
-- Requirement: R2 - System must track player information including position and status
SELECT 
    t.teamName,
    CONCAT(p.firstName, ' ', p.lastName) AS playerName,
    pos.positionName,
    pos.offenseOrDefense,
    p.height,
    p.weight,
    p.status
FROM player p
JOIN team t ON p.teamId = t.teamId
JOIN positions pos ON p.position = pos.positionCode
WHERE t.teamId = 1 AND p.status = 'Active'
ORDER BY pos.offenseOrDefense, pos.positionName;

-- Evidence Query 3: Calculate team performance statistics for the 2024 season
-- This query demonstrates aggregation and JOIN operations
-- Requirement: R3 - System must track team statistics by season
SELECT 
    t.teamName,
    ts.season,
    ts.pointsScored,
    ts.pointsPerGame,
    ts.pointsAllowed,
    (ts.pointsScored - ts.pointsAllowed) AS pointDifferential,
    ts.passingYards,
    ts.rushingYards,
    (ts.passingYards + ts.rushingYards) AS totalYards
FROM team_stats ts
JOIN team t ON ts.teamId = t.teamId
WHERE ts.season = 2024
ORDER BY ts.pointsScored DESC;

-- ============================================================================
-- 7. SESSION RESTORE
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 1;

