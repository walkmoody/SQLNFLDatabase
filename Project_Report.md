# CS 4354: Concepts of Database Systems - Project Report
## NFL Database Management System

---

## 1. Requirements (R1–R5)

**R1:** The system must track NFL team information including team name, conference (AFC/NFC), division, home stadium, and establishment year. Testable by querying all teams with their stadium details.

**R2:** The system must track player information including name, position, physical attributes (height, weight), draft history, college, date of birth, and current status (Active/IR/Practice Squad). Testable by retrieving all active players for a specific team.

**R3:** The system must track team statistics by season including points scored/allowed, passing/rushing yards, and turnover statistics. Testable by querying team performance metrics for a given season.

**R4:** The system must track game schedules including season, week, date, time, participating teams, stadium, and final scores. Testable by retrieving all games for a specific week and season.

**R5:** The system must track coaching staff information including name, position, head coach designation, date of birth, and team affiliation. Testable by querying all coaches for a specific team.

---

## 2. ER Diagram

### Entities and Attributes:

**Stadium** (Primary Key: stadiumId)
- Attributes: stadiumName, locationCity, locationState, capacity, surfaceType

**Position** (Primary Key: positionCode)
- Attributes: positionName, offenseOrDefense

**Team** (Primary Key: teamId)
- Attributes: teamName (UNIQUE), conference, division, stadiumId (FK), establishedYear

**Player** (Primary Key: playerId)
- Attributes: teamId (FK), firstName, lastName, position (FK), dob, height, weight, college, draftYear, draftRound, draftPick, status

**Coach** (Primary Key: coachID)
- Attributes: teamId (FK), firstName, lastName, coachPosition, isHeadCoach, dob

**Schedule** (Primary Key: gameId)
- Attributes: season, week, gameDate, gameTime, homeTeamId (FK), awayTeamId (FK), stadiumId (FK), homeScore, awayScore

**Team_Stats** (Composite Primary Key: teamId, season)
- Attributes: teamId (FK), season, pointsScored, pointsPerGame, pointsAllowed, passingYards, passYrdPerGame, rushingYards, rushYrdPerGame, interceptions, fumblesForced, fumblesRec

### Relationships and Cardinalities:

- **Stadium ↔ Team**: One-to-Many (1:N)
  - Participation: Stadium (partial), Team (total)
  - A stadium can host multiple teams (rare but possible), but each team has one primary stadium

- **Team ↔ Player**: One-to-Many (1:N)
  - Participation: Team (partial), Player (partial)
  - A team has many players; a player belongs to one team at a time

- **Position ↔ Player**: One-to-Many (1:N)
  - Participation: Position (partial), Player (partial)
  - A position can be held by many players; a player has one primary position

- **Team ↔ Coach**: One-to-Many (1:N)
  - Participation: Team (partial), Coach (partial)
  - A team has many coaches; a coach belongs to one team

- **Team ↔ Schedule**: One-to-Many (1:N) for both home and away
  - Participation: Team (total), Schedule (total)
  - A team participates in many games as home or away team; each game involves exactly two teams

- **Stadium ↔ Schedule**: One-to-Many (1:N)
  - Participation: Stadium (partial), Schedule (total)
  - A stadium hosts many games; each game is played at one stadium

- **Team ↔ Team_Stats**: One-to-Many (1:N)
  - Participation: Team (partial), Team_Stats (total)
  - A team has statistics for multiple seasons; each statistic record belongs to one team and one season

---

## 3. Relational Schema

### stadium
- **PK:** stadiumId (INT, AUTO_INCREMENT)
- **Attributes:**
  - stadiumName (VARCHAR(150), NOT NULL)
  - locationCity (VARCHAR(100), NOT NULL)
  - locationState (VARCHAR(100), NOT NULL)
  - capacity (INT, NOT NULL, CHECK > 0)
  - surfaceType (VARCHAR(50), NOT NULL)

### positions
- **PK:** positionCode (VARCHAR(5))
- **Attributes:**
  - positionName (VARCHAR(50), NOT NULL)
  - offenseOrDefense (ENUM('Offense', 'Defense', 'Special'), NOT NULL)

### team
- **PK:** teamId (INT, AUTO_INCREMENT)
- **UNIQUE:** teamName (VARCHAR(100), NOT NULL)
- **Attributes:**
  - conference (ENUM('AFC','NFC'), NOT NULL)
  - division (ENUM('East','West','North','South'), NOT NULL)
  - stadiumId (INT, NULL, FK → stadium.stadiumId)
  - establishedYear (INT, NULL)
- **FK:** stadiumId REFERENCES stadium(stadiumId)

### player
- **PK:** playerId (INT, AUTO_INCREMENT)
- **Attributes:**
  - teamId (INT, NULL, FK → team.teamId)
  - firstName (VARCHAR(100), NOT NULL)
  - lastName (VARCHAR(100), NOT NULL)
  - position (VARCHAR(5), NULL, FK → positions.positionCode)
  - dob (DATE, NULL)
  - height (INT, NULL, CHECK: 60-90 if not NULL)
  - weight (INT, NULL, CHECK: 150-400 if not NULL)
  - college (VARCHAR(100), NULL)
  - draftYear (INT, NULL)
  - draftRound (INT, NULL)
  - draftPick (INT, NULL)
  - status (ENUM('Active','IR','Practice Squad'), DEFAULT 'Active')
- **FK:** teamId REFERENCES team(teamId), position REFERENCES positions(positionCode)

### coaches
- **PK:** coachID (INT, AUTO_INCREMENT)
- **Attributes:**
  - teamId (INT, NULL, FK → team.teamId)
  - firstName (VARCHAR(100), NOT NULL)
  - lastName (VARCHAR(100), NOT NULL)
  - coachPosition (VARCHAR(50), NULL)
  - isHeadCoach (BOOLEAN, DEFAULT 0)
  - dob (DATE, NULL)
- **FK:** teamId REFERENCES team(teamId)

### schedules
- **PK:** gameId (INT, AUTO_INCREMENT)
- **Attributes:**
  - season (INT, NOT NULL, CHECK >= 1920)
  - week (INT, NOT NULL, CHECK: 1-18)
  - gameDate (DATE, NOT NULL)
  - gameTime (TIME, NULL)
  - homeTeamId (INT, NOT NULL, FK → team.teamId)
  - awayTeamId (INT, NOT NULL, FK → team.teamId)
  - stadiumId (INT, NULL, FK → stadium.stadiumId)
  - homeScore (INT, DEFAULT 0, CHECK >= 0)
  - awayScore (INT, DEFAULT 0, CHECK >= 0)
- **FK:** homeTeamId REFERENCES team(teamId), awayTeamId REFERENCES team(teamId), stadiumId REFERENCES stadium(stadiumId)
- **CHECK:** homeTeamId != awayTeamId

### team_stats
- **PK:** (teamId, season) - Composite Primary Key
- **Attributes:**
  - teamId (INT, NOT NULL, FK → team.teamId)
  - season (INT, NOT NULL, CHECK >= 1920)
  - pointsScored (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - pointsPerGame (FLOAT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - pointsAllowed (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - passingYards (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - passYrdPerGame (FLOAT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - rushingYards (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - rushYrdPerGame (FLOAT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - interceptions (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - fumblesForced (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
  - fumblesRec (INT, NOT NULL, DEFAULT 0, CHECK >= 0)
- **FK:** teamId REFERENCES team(teamId)

---

## 4. Normalization Evidence

### Before Normalization (Denormalized Table):

Consider a hypothetical denormalized `player_team_stats` table that combines player, team, and statistical information:

```
player_team_stats (
    playerId, playerName, teamName, conference, division,
    position, pointsScored, touchdowns, passingYards, season
)
```

**Problems:**
- Update anomaly: Changing a team's name requires updating all player records
- Insertion anomaly: Cannot add a team without players
- Deletion anomaly: Deleting the last player removes team information
- Redundancy: Team information repeated for every player-season combination

### After Normalization (Current Design):

The denormalized table is decomposed into three normalized tables:

1. **team** (teamId, teamName, conference, division, stadiumId, establishedYear)
2. **player** (playerId, teamId, firstName, lastName, position, ...)
3. **team_stats** (teamId, season, pointsScored, ...)

**Explanation:**
The decomposition follows 3NF by removing transitive dependencies. Team information is stored once in the `team` table, referenced via `teamId` foreign key in `player` and `team_stats`. This eliminates update anomalies (team name changes in one place), insertion anomalies (teams can exist without players), and deletion anomalies (removing players doesn't affect team data). The `team_stats` table properly represents the many-to-many relationship between teams and seasons with a composite primary key, ensuring each team-season combination is unique and allowing teams to have statistics for multiple seasons without redundancy.

---

## 5. NULL Policy

The following columns are allowed to be NULL for the following reasons:

- **team.stadiumId**: A team may not have an assigned stadium initially (e.g., expansion teams) or during stadium transitions. This allows teams to exist in the database before stadium assignment.

- **player.teamId**: Players may be free agents or recently released, not currently assigned to any team. This supports tracking players between team affiliations.

- **player.position**: New players or players transitioning positions may not have an assigned position yet. This accommodates roster changes and position flexibility.

- **player.dob, player.height, player.weight**: These physical attributes may be unknown for newly added players or historical records with incomplete data. Allows gradual data collection.

- **player.college, player.draftYear, player.draftRound, player.draftPick**: Undrafted players or international players may not have draft information. Supports diverse player backgrounds.

- **schedules.gameTime**: Some games may have TBD (to be determined) times initially. Allows scheduling flexibility for broadcast decisions.

- **schedules.stadiumId**: While typically the home team's stadium, neutral site games or special events may use different venues. This provides scheduling flexibility.

- **coaches.teamId**: Coaches may be between teams or in transition. Supports tracking coaching staff changes.

- **coaches.coachPosition, coaches.dob**: Position may be undefined for new hires, and date of birth may be unavailable for historical records.

---

## 6. Index Rationale

**Composite Index:** `idx_schedules_season_week ON schedules(season, week)`

**Query Pattern:** This index optimizes queries that filter games by both season and week, such as "SELECT * FROM schedules WHERE season = 2025 AND week = 1". The composite index allows MySQL to quickly locate all games for a specific week within a season using a single index lookup, rather than scanning the entire schedules table. This is particularly efficient for common queries like retrieving weekly game schedules or generating weekly reports, as the index supports both equality predicates on the leading columns (season, week) in the WHERE clause.

---

