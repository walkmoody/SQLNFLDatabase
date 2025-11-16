/*
*/
CREATE DATABASE IF NOT EXISTS NFL;
USE NFL;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS team_stats;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS coaches;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS stadium;

SET FOREIGN_KEY_CHECKS = 1;

-- Stadiums
CREATE TABLE stadium (
    stadiumId INT PRIMARY KEY AUTO_INCREMENT,
    stadiumName VARCHAR(150) NOT NULL,
    locationCity VARCHAR(100) NOT NULL,
    locationState VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    surfaceType VARCHAR(50) NOT NULL
);

-- Positions
CREATE TABLE positions (
    positionCode VARCHAR(5) PRIMARY KEY,
    positionName VARCHAR(50) NOT NULL,
    offenseOrDefense ENUM('Offense', 'Defense', 'Special') NOT NULL
);

-- Teams
CREATE TABLE team (
    teamId INT PRIMARY KEY AUTO_INCREMENT,
    teamName VARCHAR(100) NOT NULL UNIQUE,
    conference ENUM('AFC','NFC') NOT NULL,
    division ENUM('East','West','North','South') NOT NULL,
    stadiumId INT,
    establishedYear INT,
    FOREIGN KEY (stadiumId) REFERENCES stadium(stadiumId)
);

-- Players
CREATE TABLE player (
    playerId INT PRIMARY KEY AUTO_INCREMENT,
    teamId INT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    position VARCHAR(5),
    dob DATE,
    height INT,
    weight INT,
    college VARCHAR(100),
    draftYear INT,
    draftRound INT,
    draftPick INT,
    status ENUM('Active','IR','Practice Squad') DEFAULT 'Active',

    FOREIGN KEY (teamId) REFERENCES team(teamId),
    FOREIGN KEY (position) REFERENCES positions(positionCode)
);

-- Coaches
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

-- Schedules / Games
CREATE TABLE schedules (
    gameId INT PRIMARY KEY AUTO_INCREMENT,
    season INT NOT NULL,
    week INT NOT NULL,
    gameDate DATE NOT NULL,
    gameTime TIME,
    homeTeamId INT NOT NULL,
    awayTeamId INT NOT NULL,
    stadiumId INT,
    homeScore INT DEFAULT 0,
    awayScore INT DEFAULT 0,

    FOREIGN KEY (homeTeamId) REFERENCES team(teamId),
    FOREIGN KEY (awayTeamId) REFERENCES team(teamId),
    FOREIGN KEY (stadiumId) REFERENCES stadium(stadiumId)
);

-- Team Stats by Season
CREATE TABLE team_stats (
    teamId INT NOT NULL,
    season INT NOT NULL,

    pointsScored INT NOT NULL DEFAULT 0,
    pointsPerGame FLOAT NOT NULL DEFAULT 0,
    pointsAllowed INT NOT NULL DEFAULT 0,

    passingYards INT NOT NULL DEFAULT 0,
    passYrdPerGame FLOAT NOT NULL DEFAULT 0,

    rushingYards INT NOT NULL DEFAULT 0,
    rushYrdPerGame FLOAT NOT NULL DEFAULT 0,

    interceptions INT NOT NULL DEFAULT 0,
    fumblesForced INT NOT NULL DEFAULT 0,
    fumblesRec INT NOT NULL DEFAULT 0,

    PRIMARY KEY (teamId, season),
    FOREIGN KEY (teamId) REFERENCES team(teamId)
);

-- Positions INSERT
INSERT INTO positions (positionCode, positionName, offenseOrDefense) VALUES
('QB',  'Quarterback',       'Offense'),
('RB',  'Running Back',      'Offense'),
('FB',  'Fullback',          'Offense'),
('WR',  'Wide Receiver',     'Offense'),
('TE',  'Tight End',         'Offense'),
('LT',  'Left Tackle',       'Offense'),
('LG',  'Left Guard',        'Offense'),
('C',   'Center',            'Offense'),
('RG',  'Right Guard',       'Offense'),
('RT',  'Right Tackle',      'Offense'),

('LDE', 'Left Defensive End','Defense'),
('RDE', 'Right Defensive End','Defense'),
('DT',  'Defensive Tackle',  'Defense'),
('NT',  'Nose Tackle',       'Defense'),
('LOLB','Left Outside Linebacker','Defense'),
('ROLB','Right Outside Linebacker','Defense'),
('MLB', 'Middle Linebacker', 'Defense'),
('ILB', 'Inside Linebacker', 'Defense'),
('CB',  'Cornerback',        'Defense'),
('FS',  'Free Safety',       'Defense'),
('SS',  'Strong Safety',     'Defense'),

('K',   'Kicker',            'Special'),
('P',   'Punter',            'Special'),
('LS',  'Long Snapper',      'Special'),
('KR',  'Kick Returner',     'Special'),
('PR',  'Punt Returner',     'Special'),
('H',   'Holder',            'Special'),
('GUN', 'Gunner',            'Special');

INSERT INTO stadium (stadiumName, locationCity, locationState, capacity, surfaceType) VALUES
('Gillette Stadium', 'Foxborough', 'Massachusetts', 64628, 'turf'),
('Lucas Oil Stadium', 'Indianapolis', 'Indiana', 63000, 'turf'),
('Empower Field at Mile High', 'Denver', 'Colorado', 76124, 'grass'),
('Acrisure Stadium', 'Pittsburgh', 'Pennsylvania', 68400, 'grass'),
('Highmark Stadium', 'Orchard Park', 'New York', 71608, 'grass'),
('SoFi Stadium', 'Inglewood', 'California', 70240, 'turf'),
('EverBank Stadium', 'Jacksonville', 'Florida', 67814, 'grass'),
('Arrowhead Stadium', 'Kansas City', 'Missouri', 76416, 'grass'),
('NRG Stadium', 'Houston', 'Texas', 72220, 'turf'),
('M&T Bank Stadium', 'Baltimore', 'Maryland', 71008, 'grass'),
('Hard Rock Stadium', 'Miami Gardens', 'Florida', 65326, 'grass'),
('Paycor Stadium', 'Cincinnati', 'Ohio', 65515,'turf'),
('Allegiant Stadium', 'Las Vegas', 'Nevada', 65000, 'grass'),
('Huntington Bank Field', 'Cleveland', 'Ohio', 67431, 'grass'),
('MetLife Stadium', 'East Rutherford', 'New Jersey', 82500, 'turf'),
('Nissan Stadium', 'Nashville', 'Tennessee', 69143, 'turf'),

('Lincoln Financial Field','Philadelphia','Pennsylvania','67594','turf'),
('Lumen Field','Seattle','Washington','68750','grass'),
('Soldier Field','Chicago','Illinois','62500','grass'),
('Raymond James Stadium','Tampa','Florida','69218','grass'),
('SoFi Stadium','Inglewood','California','70240','turf'),
('Ford Field','Detroit','Michigan','65000','turf'),
('Lambeau Field','Green Bay','Wisconsin','81441','grass'),
('Levis Stadium','Santa Clara','California','75000','turf'),
('Bank of America Stadium','Charlotte','North Carolina','75037','grass'),
('The US Bank Stadium','Minneapolis','Minnesota','66860','turf'),
('AT&T Stadium','Arlington','Texas','80000','turf'),
('State Farm Stadium','Glendale','Arizona','63400','grass'),
('Mercedes-Benz Stadium','Atlanta','Georiga','71000','turf'),
('FedExField','Atlanta','Georgia','64000','grass'),
('Caesars Superdome','New Orleans','Louisiana','73208','turf'),
('MetLife Stadium','East Rutherford','New Jersey','82500','turf');




INSERT INTO team (teamName, conference, division, stadiumId, establishedYear) VALUES

('New England Patriots', 'AFC', 'East', 1, 1959),
('Indianapolis Colts', 'AFC', 'South', 2, 1953),
('Denver Broncos', 'AFC', 'West', 3, 1959),
('Pittsburgh Steelers', 'AFC', 'North', 4, 1933),
('Buffalo Bills', 'AFC', 'East', 5, 1960),
('San Diego Chargers', 'AFC', 'West', 6, 1959),
('Jacksonville Jaguars', 'AFC', 'South', 7, 1993),
('Kansas City Chiefs', 'AFC', 'West', 8, 1960),
('Houston Texans', 'AFC', 'South', 9, 1999),
('Baltimore Ravens', 'AFC', 'North', 10, 1996),
('Miami Dolphins', 'AFC', 'East', 11, 1966),
('Cincinnati Bengals', 'AFC', 'North', 12, 1967),
('Las Vegas Raiders', 'AFC', 'West', 13, 1960),
('Cleveland Browns', 'AFC', 'North', 14, 1946),
('New York Jets', 'AFC', 'East', 15, 1960),
('Tennessee Titans', 'AFC', 'South', 16, 1960),
('Philadelphia Eagles', 'NFC', 'East', 17, 1933),
('Seattle Seahawks', 'NFC', 'West', 18, 1976),
('Chicago Bears', 'NFC', 'North', 19, 1920),
('Tampa Bay Buccaneers', 'NFC', 'South', 20, 1976),
('Los Angeles Rams', 'NFC', 'West', 21, 1936),
('Detroit Lions', 'NFC', 'North', 22, 1930),
('Greenbay Packers', 'NFC', 'North', 23, 1919),
('San Francisco 49ers', 'NFC', 'West', 24, 1946),
('Carolina Panthers', 'NFC', 'South', 25, 1995),
('Minnesota Vikings', 'NFC', 'North', 26, 1961),
('Dallas Cowboys', 'NFC', 'East', 27, 1960),
('Arizona Cardinals', 'NFC', 'West', 28, 1898),
('Atlanta Falcons', 'NFC', 'South', 29, 1966),
('Washington Commanders', 'NFC', 'East', 30, 1932),
('New Orleans Saints', 'NFC', 'South', 31, 1967),
('New York Giants', 'NFC', 'East', 32, 1925);


INSERT INTO coaches (teamId, firstName, lastName, coachPosition, isHeadCoach, dob) VALUES
(1,  'Jerod', 'Mayo',          'Head Coach', 1, '1986-02-23'),
(2,  'Shane', 'Steichen',      'Head Coach', 1, '1985-12-19'),
(3,  'Sean',  'Payton',        'Head Coach', 1, '1963-12-29'),
(4,  'Mike',  'Tomlin',        'Head Coach', 1, '1972-03-15'),
(5,  'Sean',  'McDermott',     'Head Coach', 1, '1974-03-21'),
(6,  'Jim',   'Harbaugh',      'Head Coach', 1, '1963-12-23'),
(7,  'Doug',  'Pederson',      'Head Coach', 1, '1968-01-31'),
(8,  'Andy',  'Reid',          'Head Coach', 1, '1958-03-19'),
(9,  'DeMeco','Ryans',         'Head Coach', 1, '1984-07-28'),
(10, 'John',  'Harbaugh',      'Head Coach', 1, '1962-09-23'),
(11, 'Mike',  'McDaniel',      'Head Coach', 1, '1983-03-06'),
(12, 'Zac',   'Taylor',        'Head Coach', 1, '1983-05-10'),
(13, 'Antonio','Pierce',       'Head Coach', 1, '1978-10-26'),
(14, 'Kevin', 'Stefanski',     'Head Coach', 1, '1982-05-08'),
(15, 'Robert','Saleh',         'Head Coach', 1, '1979-01-31'),
(16, 'Brian', 'Callahan',      'Head Coach', 1, '1984-06-10'),

-- NFC
(17, 'Nick',  'Sirianni',       'Head Coach', 1, '1981-06-15'),
(18, 'Mike',  'Macdonald',      'Head Coach', 1, '1987-06-26'),
(19, 'Matt',  'Eberflus',       'Head Coach', 1, '1970-05-17'),
(20, 'Todd',  'Bowles',         'Head Coach', 1, '1963-11-18'),
(21, 'Sean',  'McVay',          'Head Coach', 1, '1986-01-24'),
(22, 'Dan',   'Campbell',       'Head Coach', 1, '1976-04-13'),
(23, 'Matt',  'LaFleur',        'Head Coach', 1, '1979-11-03'),
(24, 'Kyle',  'Shanahan',       'Head Coach', 1, '1979-12-14'),
(25, 'Dave',  'Canales',        'Head Coach', 1, '1981-05-07'),
(26, 'Kevin', 'OConnell',      'Head Coach', 1, '1985-05-25'),
(27, 'Mike',  'McCarthy',       'Head Coach', 1, '1963-11-10'),
(28, 'Jonathan','Gannon',       'Head Coach', 1, '1983-04-03'),
(29, 'Raheem','Morris',         'Head Coach', 1, '1976-09-03'),
(30, 'Dan',   'Quinn',          'Head Coach', 1, '1970-09-11'),
(31, 'Dennis','Allen',          'Head Coach', 1, '1972-09-22'),
(32, 'Brian', 'Daboll',         'Head Coach', 1, '1975-04-14');

INSERT INTO player (teamId, firstName, lastName, position, dob, height, weight, college, draftYear, draftRound, draftPick, status) VALUES
-- AFC / NFC, 3 players per team

-- Arizona Cardinals (teamId = 28)
(28, 'Trey', 'McBride',    'TE', NULL, 75, 250, 'South Dakota State', 2022, 3, 92, 'Active'),
(28, 'Kyler', 'Murray',    'QB', '1997-08-07', 70, 207, 'Oklahoma', 2019, 1, 1, 'Active'),
(28, 'Budda', 'Baker',     'SS', '1996-04-27', 71, 195, 'Washington', 2017, 2, 36, 'Active'),

-- Atlanta Falcons (teamId = 29)
(29, 'Jessie', 'Bates III', 'SS', '1997-11-27', 71, 200, 'Wake Forest', 2018, 3, 92, 'Active'),
(29, 'Chris', 'Lindstrom', 'LG', '1998-05-22', 75, 320, 'Boston College', 2020, 2, 14, 'Active'),
(29, 'Bijan', 'Robinson',  'RB', '2002-01-30', 70, 220, 'Texas', 2023, 1, 8, 'Active'),

-- Baltimore Ravens (teamId = ? — not in your listed NFC only, skipping)

-- Buffalo Bills (teamId = ?) — skipping (AFC)

-- Carolina Panthers (teamId = 25)
(25, 'Brian', 'Burns',      'ROLB', '1998-10-23', 75, 250, 'Florida State', 2020, 1, 16, 'Active'),  -- NOTE: Burns isn't in the PFF top3, I'm using a known star  
(25, 'Bryce', 'Young',      'QB', '2001-07-25', 72, 204, 'Alabama', 2023, 1, 1, 'Active'),
(25, 'Taylor', 'Horn',     'CB', '2001-12-24', 74, 205, 'South Carolina', 2022, 1, 8, 'Active'),

-- Chicago Bears (teamId = 19)
(19, 'Justin', 'Fields',    'QB', '1999-03-05', 74, 228, 'Ohio State', 2021, 1, 11, 'Active'),
(19, 'Cole', 'Kmet',        'TE', '1999-05-10', 77, 262, 'Notre Dame', 2020, 2, 43, 'Active'),
(19, 'Roquan', 'Smith',     'MLB', '1997-04-14', 73, 230, 'Georgia', 2018, 1, 8, 'Active'),

-- Dallas Cowboys (teamId = 27)
(27, 'Micah', 'Parsons',    'LOLB', '1999-05-19', 74, 245, 'Penn State', 2021, 1, 12, 'Active'),
(27, 'CeeDee', 'Lamb',      'WR', '1999-04-17', 73, 199, 'Oklahoma', 2020, 1, 17, 'Active'),
(27, 'Dak', 'Prescott',     'QB', '1993-07-29', 75, 238, 'Mississippi State', 2016, 4, 135, 'Active'),

-- Philadelphia Eagles (teamId = 17)
(17, 'A.J.', 'Brown',       'WR', '1997-06-30', 74, 226, 'Ole Miss', 2019, 2, 51, 'Active'),
(17, 'Jordan', 'Mailata',  'LT', '1997-08-13', 82, 350, NULL, 2018, 7, 233, 'Active'),
(17, 'Lane', 'Johnson',    'RT', '1990-05-08', 78, 327, 'Oklahoma', 2013, 1, 4, 'Active'),
-- Detroit Lions (teamId = 22)
(22, 'Amon-Ra', 'St. Brown','WR', '1999-10-24', 72, 202, 'USC', 2021, 4, 112, 'Active'),
(22, 'Aidan', 'Hutchinson', 'ROLB', '2000-08-26', 76, 258, 'Michigan', 2022, 1, 2, 'Active'),
(22, 'Penei', 'Sewell',     'LT', '2000-10-09', 78, 331, 'Oregon', 2021, 1, 7, 'Active'),
-- Denver Broncos (teamId = 3)
(3, 'Patrick', 'Surtain II','CB', '1998-06-13', 75, 202, 'Alabama', 2021, 1, 9, 'Active'),
(3, 'Quinn', 'Meinerz',     'LG', '1999-11-18', 76, 322, 'Wisconsin', 2022, 1, 19, 'Active'),
(3, 'Courtland', 'Sutton', 'WR', '1995-10-16', 75, 215, 'SMU', 2018, 2, 40, 'Active'),

-- Los Angeles Rams (teamId = 21)
(21, 'Aaron', 'Donald',     'DT', '1991-05-23', 71, 280, 'Pittsburgh', 2014, 1, 13, 'Active'),
(21, 'Leonard', 'Floyd',    'ROLB', '1992-08-20', 75, 250, 'UCLA', 2016, 1, 9, 'Active'),
(21, 'Cooper', 'Kupp',      'WR', '1993-06-15', 74, 208, 'Eastern Washington', 2017, 3, 69, 'Active'),

-- San Francisco 49ers (teamId = 24)
(24, 'Nick', 'Bosa',        'RDE', '1997-10-25', 76, 266, 'Ohio State', 2019, 1, 2, 'Active'),
(24, 'Fred', 'Warner',      'MLB', '1996-11-19', 74, 230, 'Brigham Young', 2018, 3, 70, 'Active'),
(24, 'George', 'Kittle',    'TE', '1993-10-09', 77, 250, 'Iowa', 2017, 5, 146, 'Active');


INSERT INTO schedules (season, week, gameDate, gameTime, homeTeamId, awayTeamId, stadiumId, homeScore, awayScore) VALUES
(2025, 1, '2025-09-04', '13:00:00', 25, 5, 25, 0, 0),
(2025, 1, '2025-09-05', '16:25:00', 9, 23, 9, 0, 0),
(2025, 1, '2025-09-07', '13:00:00', 19, 7, 19, 0, 0),
(2025, 1, '2025-09-07', '16:25:00', 3, 16, 3, 0, 0),
(2025, 1, '2025-09-07', '20:20:00', 10, 21, 10, 0, 0),
(2025, 1, '2025-09-07', '20:15:00', 20, 26, 20, 0, 0),
(2025, 1, '2025-09-07', '13:00:00', 1, 6, 1, 0, 0),
(2025, 1, '2025-09-07', '16:25:00', 14, 28, 14, 0, 0),
(2025, 1, '2025-09-07', '20:20:00', 12, 27, 12, 0, 0),
(2025, 1, '2025-09-07', '20:15:00', 31, 8, 31, 0, 0),
(2025, 1, '2025-09-07', '13:00:00', 22, 2, 22, 0, 0),
(2025, 1, '2025-09-07', '16:25:00', 17, 4, 17, 0, 0),
(2025, 1, '2025-09-07', '20:20:00', 18, 11, 18, 0, 0),
(2025, 1, '2025-09-07', '20:15:00', 15, 13, 15, 0, 0),
(2025, 1, '2025-09-07', '13:00:00', 29, 30, 29, 0, 0),
(2025, 1, '2025-09-07', '16:25:00', 24, 32, 24, 0, 0),

(2025, 2, '2025-09-14', '13:00:00', 14, 6, 14, 0, 0),
(2025, 2, '2025-09-14', '16:25:00', 20, 10, 20, 0, 0),
(2025, 2, '2025-09-14', '20:20:00', 9, 1, 9, 0, 0),
(2025, 2, '2025-09-14', '20:15:00', 26, 18, 26, 0, 0),
(2025, 2, '2025-09-14', '13:00:00', 27, 31, 27, 0, 0),
(2025, 2, '2025-09-14', '16:25:00', 17, 21, 17, 0, 0),
(2025, 2, '2025-09-14', '20:20:00', 12, 22, 12, 0, 0),
(2025, 2, '2025-09-14', '20:15:00', 2, 25, 2, 0, 0),
(2025, 2, '2025-09-14', '13:00:00', 16, 15, 16, 0, 0),
(2025, 2, '2025-09-14', '16:25:00', 7, 11, 7, 0, 0),
(2025, 2, '2025-09-14', '20:20:00', 28, 3, 28, 0, 0),
(2025, 2, '2025-09-14', '20:15:00', 13, 24, 13, 0, 0),
(2025, 2, '2025-09-14', '13:00:00', 8, 5, 8, 0, 0),
(2025, 2, '2025-09-14', '16:25:00', 4, 23, 4, 0, 0),
(2025, 2, '2025-09-14', '20:20:00', 32, 19, 32, 0, 0),
(2025, 2, '2025-09-14', '20:15:00', 30, 29, 30, 0, 0),

(2025, 3, '2025-09-21', '13:00:00', 2, 3, 2, 0, 0),
(2025, 3, '2025-09-21', '16:25:00', 12, 1, 12, 0, 0),
(2025, 3, '2025-09-21', '20:20:00', 22, 7, 22, 0, 0),
(2025, 3, '2025-09-21', '20:15:00', 9, 20, 9, 0, 0),
(2025, 3, '2025-09-21', '13:00:00', 24, 13, 24, 0, 0),
(2025, 3, '2025-09-21', '16:25:00', 18, 4, 18, 0, 0),
(2025, 3, '2025-09-21', '20:20:00', 15, 6, 15, 0, 0),
(2025, 3, '2025-09-21', '20:15:00', 30, 11, 30, 0, 0),
(2025, 3, '2025-09-21', '13:00:00', 21, 28, 21, 0, 0),
(2025, 3, '2025-09-21', '16:25:00', 8, 27, 8, 0, 0),
(2025, 3, '2025-09-21', '20:20:00', 16, 10, 16, 0, 0),
(2025, 3, '2025-09-21', '20:15:00', 5, 14, 5, 0, 0),
(2025, 3, '2025-09-21', '13:00:00', 19, 25, 19, 0, 0),
(2025, 3, '2025-09-21', '16:25:00', 17, 23, 17, 0, 0),
(2025, 3, '2025-09-21', '20:20:00', 31, 32, 31, 0, 0),
(2025, 3, '2025-09-21', '20:15:00', 26, 29, 26, 0, 0),

(2025, 4, '2025-09-28', '13:00:00', 21, 24, 21, 0, 0),
(2025, 4, '2025-09-28', '16:25:00', 2, 18, 2, 0, 0),
(2025, 4, '2025-09-28', '20:20:00', 4, 20, 4, 0, 0),
(2025, 4, '2025-09-28', '20:15:00', 14, 9, 14, 0, 0),
(2025, 4, '2025-09-28', '13:00:00', 17, 6, 17, 0, 0),
(2025, 4, '2025-09-28', '16:25:00', 1, 31, 1, 0, 0),
(2025, 4, '2025-09-28', '20:20:00', 28, 8, 28, 0, 0),
(2025, 4, '2025-09-28', '20:15:00', 13, 3, 13, 0, 0),
(2025, 4, '2025-09-28', '13:00:00', 12, 23, 12, 0, 0),
(2025, 4, '2025-09-28', '16:25:00', 10, 26, 10, 0, 0),
(2025, 4, '2025-09-28', '20:20:00', 11, 30, 11, 0, 0),
(2025, 4, '2025-09-28', '20:15:00', 15, 25, 15, 0, 0),
(2025, 4, '2025-09-28', '13:00:00', 22, 5, 22, 0, 0),
(2025, 4, '2025-09-28', '16:25:00', 16, 27, 16, 0, 0),
(2025, 4, '2025-09-28', '20:20:00', 19, 29, 19, 0, 0),
(2025, 4, '2025-09-28', '20:15:00', 32, 7, 32, 0, 0),

(2025, 5, '2025-10-05', '13:00:00', 11, 19, 11, 0, 0),
(2025, 5, '2025-10-05', '16:25:00', 30, 15, 30, 0, 0),
(2025, 5, '2025-10-05', '20:20:00', 6, 21, 6, 0, 0),
(2025, 5, '2025-10-05', '20:15:00', 1, 24, 1, 0, 0),
(2025, 5, '2025-10-05', '13:00:00', 27, 8, 27, 0, 0),
(2025, 5, '2025-10-05', '16:25:00', 3, 26, 3, 0, 0),
(2025, 5, '2025-10-05', '20:20:00', 16, 12, 16, 0, 0),
(2025, 5, '2025-10-05', '20:15:00', 14, 2, 14, 0, 0),
(2025, 5, '2025-10-05', '13:00:00', 22, 29, 22, 0, 0),
(2025, 5, '2025-10-05', '16:25:00', 10, 5, 10, 0, 0),
(2025, 5, '2025-10-05', '20:20:00', 4, 32, 4, 0, 0),
(2025, 5, '2025-10-05', '20:15:00', 23, 18, 23, 0, 0),
(2025, 5, '2025-10-05', '13:00:00', 9, 28, 9, 0, 0),
(2025, 5, '2025-10-05', '16:25:00', 20, 13, 20, 0, 0),
(2025, 5, '2025-10-05', '20:20:00', 25, 7, 25, 0, 0),
(2025, 5, '2025-10-05', '20:15:00', 31, 17, 31, 0, 0),

(2025, 6, '2025-10-12', '13:00:00', 8, 16, 8, 0, 0),
(2025, 6, '2025-10-12', '16:25:00', 2, 11, 2, 0, 0),
(2025, 6, '2025-10-12', '20:20:00', 28, 12, 28, 0, 0),
(2025, 6, '2025-10-12', '20:15:00', 30, 24, 30, 0, 0),
(2025, 6, '2025-10-12', '13:00:00', 21, 4, 21, 0, 0),
(2025, 6, '2025-10-12', '16:25:00', 1, 27, 1, 0, 0),
(2025, 6, '2025-10-12', '20:20:00', 15, 14, 15, 0, 0),
(2025, 6, '2025-10-12', '20:15:00', 23, 32, 23, 0, 0),
(2025, 6, '2025-10-12', '13:00:00', 22, 6, 22, 0, 0),
(2025, 6, '2025-10-12', '16:25:00', 26, 3, 26, 0, 0),
(2025, 6, '2025-10-12', '20:20:00', 5, 19, 5, 0, 0),
(2025, 6, '2025-10-12', '20:15:00', 17, 10, 17, 0, 0),
(2025, 6, '2025-10-12', '13:00:00', 29, 13, 29, 0, 0),
(2025, 6, '2025-10-12', '16:25:00', 18, 25, 18, 0, 0),
(2025, 6, '2025-10-12', '20:20:00', 31, 9, 31, 0, 0),
(2025, 6, '2025-10-12', '20:15:00', 20, 32, 20, 0, 0),

(2025, 7, '2025-10-19', '13:00:00', 4, 8, 4, 0, 0),
(2025, 7, '2025-10-19', '16:25:00', 12, 31, 12, 0, 0),
(2025, 7, '2025-10-19', '20:20:00', 27, 11, 27, 0, 0),
(2025, 7, '2025-10-19', '20:15:00', 1, 21, 1, 0, 0),
(2025, 7, '2025-10-19', '13:00:00', 24, 17, 24, 0, 0),
(2025, 7, '2025-10-19', '16:25:00', 3, 30, 3, 0, 0),
(2025, 7, '2025-10-19', '20:20:00', 10, 2, 10, 0, 0),
(2025, 7, '2025-10-19', '20:15:00', 23, 26, 23, 0, 0),
(2025, 7, '2025-10-19', '13:00:00', 16, 13, 16, 0, 0),
(2025, 7, '2025-10-19', '16:25:00', 15, 6, 15, 0, 0),
(2025, 7, '2025-10-19', '20:20:00', 14, 29, 14, 0, 0),
(2025, 7, '2025-10-19', '20:15:00', 28, 9, 28, 0, 0),
(2025, 7, '2025-10-19', '13:00:00', 22, 18, 22, 0, 0),
(2025, 7, '2025-10-19', '16:25:00', 32, 5, 32, 0, 0),
(2025, 7, '2025-10-19', '20:20:00', 19, 20, 19, 0, 0),
(2025, 7, '2025-10-19', '20:15:00', 25, 30, 25, 0, 0),

(2025, 8, '2025-10-26', '13:00:00', 2, 24, 2, 0, 0),
(2025, 8, '2025-10-26', '16:25:00', 17, 9, 17, 0, 0),
(2025, 8, '2025-10-26', '20:20:00', 6, 3, 6, 0, 0),
(2025, 8, '2025-10-26', '20:15:00', 27, 1, 27, 0, 0),
(2025, 8, '2025-10-26', '13:00:00', 12, 16, 12, 0, 0),
(2025, 8, '2025-10-26', '16:25:00', 31, 11, 31, 0, 0),
(2025, 8, '2025-10-26', '20:20:00', 22, 21, 22, 0, 0),
(2025, 8, '2025-10-26', '20:15:00', 4, 29, 4, 0, 0),
(2025, 8, '2025-10-26', '13:00:00', 13, 10, 13, 0, 0),
(2025, 8, '2025-10-26', '16:25:00', 14, 28, 14, 0, 0),
(2025, 8, '2025-10-26', '20:20:00', 23, 5, 23, 0, 0),
(2025, 8, '2025-10-26', '20:15:00', 15, 20, 15, 0, 0),
(2025, 8, '2025-10-26', '13:00:00', 8, 18, 8, 0, 0),
(2025, 8, '2025-10-26', '16:25:00', 32, 30, 32, 0, 0),
(2025, 8, '2025-10-26', '20:20:00', 19, 25, 19, 0, 0),
(2025, 8, '2025-10-26', '20:15:00', 26, 7, 26, 0, 0),

(2025, 9, '2025-11-02', '13:00:00', 21, 2, 21, 0, 0),
(2025, 9, '2025-11-02', '16:25:00', 9, 12, 9, 0, 0),
(2025, 9, '2025-11-02', '20:20:00', 17, 26, 17, 0, 0),
(2025, 9, '2025-11-02', '20:15:00', 1, 13, 1, 0, 0),
(2025, 9, '2025-11-02', '13:00:00', 24, 4, 24, 0, 0),
(2025, 9, '2025-11-02', '16:25:00', 6, 10, 6, 0, 0),
(2025, 9, '2025-11-02', '20:20:00', 31, 28, 31, 0, 0),
(2025, 9, '2025-11-02', '20:15:00', 22, 3, 22, 0, 0),
(2025, 9, '2025-11-02', '13:00:00', 14, 11, 14, 0, 0),
(2025, 9, '2025-11-02', '16:25:00', 19, 8, 19, 0, 0),
(2025, 9, '2025-11-02', '20:20:00', 25, 15, 25, 0, 0),
(2025, 9, '2025-11-02', '20:15:00', 29, 30, 29, 0, 0),
(2025, 9, '2025-11-02', '13:00:00', 5, 16, 5, 0, 0),
(2025, 9, '2025-11-02', '16:25:00', 27, 23, 27, 0, 0),
(2025, 9, '2025-11-02', '20:20:00', 18, 32, 18, 0, 0),
(2025, 9, '2025-11-02', '20:15:00', 20, 7, 20, 0, 0),

(2025, 10, '2025-11-09', '13:00:00', 3, 1, 3, 0, 0),
(2025, 10, '2025-11-09', '16:25:00', 11, 14, 11, 0, 0),
(2025, 10, '2025-11-09', '20:20:00', 24, 6, 24, 0, 0),
(2025, 10, '2025-11-09', '20:15:00', 8, 12, 8, 0, 0),
(2025, 10, '2025-11-09', '13:00:00', 17, 27, 17, 0, 0),
(2025, 10, '2025-11-09', '16:25:00', 22, 4, 22, 0, 0),
(2025, 10, '2025-11-09', '20:20:00', 9, 21, 9, 0, 0),
(2025, 10, '2025-11-09', '20:15:00', 13, 2, 13, 0, 0),
(2025, 10, '2025-11-09', '13:00:00', 25, 16, 25, 0, 0),
(2025, 10, '2025-11-09', '16:25:00', 5, 18, 5, 0, 0),
(2025, 10, '2025-11-09', '20:20:00', 10, 15, 10, 0, 0),
(2025, 10, '2025-11-09', '20:15:00', 23, 30, 23, 0, 0),
(2025, 10, '2025-11-09', '13:00:00', 28, 19, 28, 0, 0),
(2025, 10, '2025-11-09', '16:25:00', 26, 31, 26, 0, 0),
(2025, 10, '2025-11-09', '20:20:00', 29, 20, 29, 0, 0),
(2025, 10, '2025-11-09', '20:15:00', 32, 7, 32, 0, 0),

(2025, 11, '2025-11-16', '13:00:00', 6, 24, 6, 0, 0),
(2025, 11, '2025-11-16', '16:25:00', 4, 14, 4, 0, 0),
(2025, 11, '2025-11-16', '20:20:00', 2, 9, 2, 0, 0),
(2025, 11, '2025-11-16', '20:15:00', 21, 12, 21, 0, 0),
(2025, 11, '2025-11-16', '13:00:00', 28, 27, 28, 0, 0),
(2025, 11, '2025-11-16', '16:25:00', 16, 1, 16, 0, 0),
(2025, 11, '2025-11-16', '20:20:00', 25, 13, 25, 0, 0),
(2025, 11, '2025-11-16', '20:15:00', 19, 3, 19, 0, 0),
(2025, 11, '2025-11-16', '13:00:00', 11, 22, 11, 0, 0),
(2025, 11, '2025-11-16', '16:25:00', 8, 15, 8, 0, 0),
(2025, 11, '2025-11-16', '20:20:00', 17, 26, 17, 0, 0),
(2025, 11, '2025-11-16', '20:15:00', 5, 10, 5, 0, 0),
(2025, 11, '2025-11-16', '13:00:00', 32, 23, 32, 0, 0),
(2025, 11, '2025-11-16', '16:25:00', 29, 31, 29, 0, 0),
(2025, 11, '2025-11-16', '20:20:00', 30, 20, 30, 0, 0),
(2025, 11, '2025-11-16', '20:15:00', 18, 7, 18, 0, 0),

(2025, 12, '2025-11-23', '13:00:00', 1, 17, 1, 0, 0),
(2025, 12, '2025-11-23', '16:25:00', 14, 27, 14, 0, 0),
(2025, 12, '2025-11-23', '20:20:00', 24, 2, 24, 0, 0),
(2025, 12, '2025-11-23', '20:15:00', 21, 11, 21, 0, 0),
(2025, 12, '2025-11-23', '13:00:00', 8, 20, 8, 0, 0),
(2025, 12, '2025-11-23', '16:25:00', 30, 3, 30, 0, 0),
(2025, 12, '2025-11-23', '20:20:00', 19, 26, 19, 0, 0),
(2025, 12, '2025-11-23', '20:15:00', 13, 6, 13, 0, 0),
(2025, 12, '2025-11-23', '13:00:00', 25, 12, 25, 0, 0),
(2025, 12, '2025-11-23', '16:25:00', 4, 9, 4, 0, 0),
(2025, 12, '2025-11-23', '20:20:00', 22, 29, 22, 0, 0),
(2025, 12, '2025-11-23', '20:15:00', 16, 28, 16, 0, 0),
(2025, 12, '2025-11-23', '13:00:00', 5, 31, 5, 0, 0),
(2025, 12, '2025-11-23', '16:25:00', 10, 15, 10, 0, 0),
(2025, 12, '2025-11-23', '20:20:00', 23, 18, 23, 0, 0),
(2025, 12, '2025-11-23', '20:15:00', 32, 7, 32, 0, 0),

(2025, 13, '2025-11-30', '13:00:00', 2, 5, 2, 0, 0),
(2025, 13, '2025-11-30', '16:25:00', 24, 17, 24, 0, 0),
(2025, 13, '2025-11-30', '20:20:00', 12, 30, 12, 0, 0),
(2025, 13, '2025-11-30', '20:15:00', 9, 10, 9, 0, 0),
(2025, 13, '2025-11-30', '13:00:00', 21, 28, 21, 0, 0),
(2025, 13, '2025-11-30', '16:25:00', 26, 1, 26, 0, 0),
(2025, 13, '2025-11-30', '20:20:00', 14, 11, 14, 0, 0),
(2025, 13, '2025-11-30', '20:15:00', 19, 8, 19, 0, 0),
(2025, 13, '2025-11-30', '13:00:00', 16, 23, 16, 0, 0),
(2025, 13, '2025-11-30', '16:25:00', 22, 27, 22, 0, 0),
(2025, 13, '2025-11-30', '20:20:00', 31, 4, 31, 0, 0),
(2025, 13, '2025-11-30', '20:15:00', 29, 6, 29, 0, 0),
(2025, 13, '2025-11-30', '13:00:00', 25, 3, 25, 0, 0),
(2025, 13, '2025-11-30', '16:25:00', 15, 32, 15, 0, 0),
(2025, 13, '2025-11-30', '20:20:00', 13, 18, 13, 0, 0),
(2025, 13, '2025-11-30', '20:15:00', 20, 7, 20, 0, 0),

(2025, 14, '2025-12-07', '13:00:00', 10, 12, 10, 0, 0),
(2025, 14, '2025-12-07', '16:25:00', 1, 14, 1, 0, 0),
(2025, 14, '2025-12-07', '20:20:00', 24, 21, 24, 0, 0),
(2025, 14, '2025-12-07', '20:15:00', 4, 16, 4, 0, 0),
(2025, 14, '2025-12-07', '13:00:00', 17, 11, 17, 0, 0),
(2025, 14, '2025-12-07', '16:25:00', 3, 22, 3, 0, 0),
(2025, 14, '2025-12-07', '20:20:00', 19, 2, 19, 0, 0),
(2025, 14, '2025-12-07', '20:15:00', 28, 15, 28, 0, 0),
(2025, 14, '2025-12-07', '13:00:00', 26, 23, 26, 0, 0),
(2025, 14, '2025-12-07', '16:25:00', 8, 18, 8, 0, 0),
(2025, 14, '2025-12-07', '20:20:00', 29, 25, 29, 0, 0),
(2025, 14, '2025-12-07', '20:15:00', 20, 5, 20, 0, 0),
(2025, 14, '2025-12-07', '13:00:00', 31, 27, 31, 0, 0),
(2025, 14, '2025-12-07', '16:25:00', 30, 13, 30, 0, 0),
(2025, 14, '2025-12-07', '20:20:00', 32, 6, 32, 0, 0),
(2025, 14, '2025-12-07', '20:15:00', 9, 15, 9, 0, 0),

(2025, 15, '2025-12-14', '13:00:00', 2, 21, 2, 0, 0),
(2025, 15, '2025-12-14', '16:25:00', 11, 24, 11, 0, 0),
(2025, 15, '2025-12-14', '20:20:00', 12, 4, 12, 0, 0),
(2025, 15, '2025-12-14', '20:15:00', 14, 26, 14, 0, 0),
(2025, 15, '2025-12-14', '13:00:00', 1, 17, 1, 0, 0),
(2025, 15, '2025-12-14', '16:25:00', 23, 10, 23, 0, 0),
(2025, 15, '2025-12-14', '20:20:00', 16, 27, 16, 0, 0),
(2025, 15, '2025-12-14', '20:15:00', 6, 3, 6, 0, 0),
(2025, 15, '2025-12-14', '13:00:00', 22, 28, 22, 0, 0),
(2025, 15, '2025-12-14', '16:25:00', 25, 8, 25, 0, 0),
(2025, 15, '2025-12-14', '20:20:00', 19, 30, 19, 0, 0),
(2025, 15, '2025-12-14', '20:15:00', 15, 13, 15, 0, 0),
(2025, 15, '2025-12-14', '13:00:00', 5, 31, 5, 0, 0),
(2025, 15, '2025-12-14', '16:25:00', 18, 29, 18, 0, 0),
(2025, 15, '2025-12-14', '20:20:00', 20, 32, 20, 0, 0),
(2025, 15, '2025-12-14', '20:15:00', 7, 9, 7, 0, 0),

(2025, 16, '2025-12-21', '13:00:00', 28, 22, 28, 0, 0),
(2025, 16, '2025-12-21', '16:25:00', 17, 5, 17, 0, 0),
(2025, 16, '2025-12-21', '20:20:00', 1, 4, 1, 0, 0),
(2025, 16, '2025-12-21', '20:15:00', 21, 29, 21, 0, 0),
(2025, 16, '2025-12-21', '13:00:00', 11, 15, 11, 0, 0),
(2025, 16, '2025-12-21', '16:25:00', 6, 14, 6, 0, 0),
(2025, 16, '2025-12-21', '20:20:00', 12, 25, 12, 0, 0),
(2025, 16, '2025-12-21', '20:15:00', 24, 31, 24, 0, 0),
(2025, 16, '2025-12-21', '13:00:00', 10, 16, 10, 0, 0),
(2025, 16, '2025-12-21', '16:25:00', 2, 19, 2, 0, 0),
(2025, 16, '2025-12-21', '20:20:00', 13, 8, 13, 0, 0),
(2025, 16, '2025-12-21', '20:15:00', 30, 26, 30, 0, 0),
(2025, 16, '2025-12-21', '13:00:00', 27, 3, 27, 0, 0),
(2025, 16, '2025-12-21', '16:25:00', 23, 20, 23, 0, 0),
(2025, 16, '2025-12-21', '20:20:00', 32, 18, 32, 0, 0),


(2025, 17, '2025-12-28', '13:00:00', 4, 21, 4, 0, 0),
(2025, 17, '2025-12-28', '16:25:00', 9, 16, 9, 0, 0),
(2025, 17, '2025-12-28', '20:20:00', 1, 24, 1, 0, 0),
(2025, 17, '2025-12-28', '20:15:00', 14, 26, 14, 0, 0),
(2025, 17, '2025-12-28', '13:00:00', 18, 2, 18, 0, 0),
(2025, 17, '2025-12-28', '16:25:00', 12, 28, 12, 0, 0),
(2025, 17, '2025-12-28', '20:20:00', 31, 11, 31, 0, 0),
(2025, 17, '2025-12-28', '20:15:00', 23, 25, 23, 0, 0),
(2025, 17, '2025-12-28', '13:00:00', 30, 5, 30, 0, 0),
(2025, 17, '2025-12-28', '16:25:00', 17, 22, 17, 0, 0),
(2025, 17, '2025-12-28', '20:20:00', 8, 27, 8, 0, 0),
(2025, 17, '2025-12-28', '20:15:00', 13, 3, 13, 0, 0),
(2025, 17, '2025-12-28', '13:00:00', 32, 29, 32, 0, 0),
(2025, 17, '2025-12-28', '16:25:00', 10, 19, 10, 0, 0),
(2025, 17, '2025-12-28', '20:20:00', 6, 15, 6, 0, 0),
(2025, 17, '2025-12-28', '20:15:00', 20, 11, 20, 0, 0),

(2025, 18, '2026-01-04', '13:00:00', 21, 9, 21, 0, 0),
(2025, 18, '2026-01-04', '16:25:00', 1, 19, 1, 0, 0),
(2025, 18, '2026-01-04', '20:20:00', 14, 24, 14, 0, 0),
(2025, 18, '2026-01-04', '20:15:00', 2, 12, 2, 0, 0),
(2025, 18, '2026-01-04', '13:00:00', 28, 16, 28, 0, 0),
(2025, 18, '2026-01-04', '16:25:00', 26, 4, 26, 0, 0),
(2025, 18, '2026-01-04', '20:20:00', 31, 27, 31, 0, 0),
(2025, 18, '2026-01-04', '20:15:00', 8, 22, 8, 0, 0),
(2025, 18, '2026-01-04', '13:00:00', 11, 3, 11, 0, 0),
(2025, 18, '2026-01-04', '16:25:00', 25, 32, 25, 0, 0),
(2025, 18, '2026-01-04', '20:20:00', 13, 5, 13, 0, 0),
(2025, 18, '2026-01-04', '20:15:00', 15, 10, 15, 0, 0),
(2025, 18, '2026-01-04', '13:00:00', 23, 18, 23, 0, 0),
(2025, 18, '2026-01-04', '16:25:00', 29, 30, 29, 0, 0),
(2025, 18, '2026-01-04', '20:20:00', 20, 6, 20, 0, 0),
(2025, 18, '2026-01-04', '20:15:00', 17, 2, 17, 0, 0);


INSERT INTO team_stats (teamId, season, pointsScored, pointsPerGame, pointsAllowed,
                        passingYards, passYrdPerGame, rushingYards, rushYrdPerGame,
                        interceptions, fumblesForced, fumblesRec)
VALUES
(1, 2024, 450, 26.5, 380, 4200, 247.0, 1850, 108.8, 12, 8, 6),
(2, 2024, 390, 22.9, 410, 3900, 229.0, 1700, 100.0, 11, 7, 5),
(3, 2024, 420, 24.7, 395, 4100, 241.0, 1600, 94.0, 9, 6, 4),
(4, 2024, 380, 22.3, 360, 3900, 229.4, 1400, 82.3, 14, 10, 7),
(5, 2024, 410, 24.1, 430, 4000, 235.0, 1500, 88.2, 10, 9, 6);

SELECT 
    t.teamName,
    t.conference,
    t.division,
    s.stadiumName,
    s.locationCity,
    s.locationState,
    s.capacity,
    s.surfaceType
FROM team t
JOIN stadium s ON t.stadiumId = s.stadiumId
ORDER BY t.teamName;

SELECT 
    CONCAT(p.firstName, ' ', p.lastName) AS playerName,
    pos.positionName,
    p.height,
    p.weight,
    p.college,
    p.status
FROM player p
JOIN positions pos ON p.position = pos.positionCode
WHERE p.teamId = 1; -- change 1 to any teamId;

SELECT 
    t.teamName,
    CONCAT(c.firstName, ' ', c.lastName) AS coachName,
    c.coachPosition,
    CASE WHEN c.isHeadCoach = 1 THEN 'HEAD COACH' ELSE 'Assistant' END AS role
FROM coaches c
JOIN team t ON c.teamId = t.teamId
ORDER BY t.teamName, role DESC;


SELECT 
    s.season,
    s.week,
    s.gameDate,
    s.gameTime,
    ht.teamName AS homeTeam,
    at.teamName AS awayTeam,
    st.stadiumName,
    s.homeScore,
    s.awayScore
FROM schedules s
JOIN team ht ON s.homeTeamId = ht.teamId
JOIN team at ON s.awayTeamId = at.teamId
JOIN stadium st ON s.stadiumId = st.stadiumId
WHERE s.week = 1
ORDER BY s.gameDate, s.gameTime;

