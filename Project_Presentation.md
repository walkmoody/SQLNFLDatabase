# NFL Database Management System
## CS 4354: Concepts of Database Systems - Project Presentation

---

## Slide 1: Title Slide
**NFL Database Management System**

CS 4354: Concepts of Database Systems  
Fall 2025

Team: [Your Team Name]

---

## Slide 2: Project Overview
**What We Built**

- **Purpose**: Comprehensive database system for managing NFL teams, players, coaches, games, and statistics
- **Scope**: 
  - 7 core tables
  - Complete team and player tracking
  - Game scheduling and statistics
  - Coaching staff management
- **Technology**: MySQL 9.5.0
- **Database**: NFL

---

## Slide 3: Requirements Overview
**System Requirements (R1-R5)**

**R1**: Track team information (conference, division, stadium)  
**R2**: Track player information (position, status, attributes)  
**R3**: Track team statistics by season  
**R4**: Track game schedules (season, week, teams, scores)  
**R5**: Track coaching staff information

*Each requirement is testable via specific SQL queries*

---

## Slide 4: Database Schema Overview
**Core Entities**

- **stadium** - Venue information
- **positions** - Player position definitions
- **team** - NFL team data
- **player** - Player roster information
- **coaches** - Coaching staff
- **schedules** - Game schedules
- **team_stats** - Seasonal team statistics

*7 tables with proper relationships and constraints*

---

## Slide 5: ER Diagram - Key Relationships
**Entity Relationships**

- **Stadium ↔ Team**: 1:N (One stadium can host multiple teams)
- **Team ↔ Player**: 1:N (One team has many players)
- **Team ↔ Coach**: 1:N (One team has many coaches)
- **Team ↔ Schedule**: 1:N (Home/Away relationships)
- **Team ↔ Team_Stats**: 1:N (One team, multiple seasons)
- **Position ↔ Player**: 1:N (One position, many players)

*All relationships properly defined with foreign keys*

---

## Slide 6: Relational Schema - Primary Keys
**Table Structure**

| Table | Primary Key | Type |
|-------|-------------|------|
| stadium | stadiumId | INT AUTO_INCREMENT |
| positions | positionCode | VARCHAR(5) |
| team | teamId | INT AUTO_INCREMENT |
| player | playerId | INT AUTO_INCREMENT |
| coaches | coachID | INT AUTO_INCREMENT |
| schedules | gameId | INT AUTO_INCREMENT |
| team_stats | (teamId, season) | Composite PK |

*Surrogate keys for most tables, composite key for team_stats*

---

## Slide 7: Relational Schema - Foreign Keys
**Referential Integrity**

- **team.stadiumId** → stadium.stadiumId
- **player.teamId** → team.teamId
- **player.position** → positions.positionCode
- **coaches.teamId** → team.teamId
- **schedules.homeTeamId** → team.teamId
- **schedules.awayTeamId** → team.teamId
- **schedules.stadiumId** → stadium.stadiumId
- **team_stats.teamId** → team.teamId

*All foreign keys enforce referential integrity*

---

## Slide 8: Constraints and Data Validation
**Data Integrity Features**

- **CHECK Constraints**: 
  - Capacity > 0
  - Height: 60-90 inches
  - Weight: 150-400 lbs
  - Week: 1-18
  - Season >= 1920
  - Scores >= 0
- **UNIQUE**: teamName
- **ENUM**: conference, division, status, offenseOrDefense
- **Custom CHECK**: homeTeamId != awayTeamId

*Comprehensive validation ensures data quality*

---

## Slide 9: Normalization Evidence
**Before: Denormalized Table**

```
player_team_stats (
    playerId, playerName, teamName, conference, division,
    position, pointsScored, touchdowns, passingYards, season
)
```

**Problems:**
- Update anomaly: Team name changes require multiple updates
- Insertion anomaly: Cannot add team without players
- Deletion anomaly: Removing players loses team data
- Redundancy: Team info repeated for every player

---

## Slide 10: Normalization Evidence
**After: Normalized Design**

**Decomposed into:**
1. **team** (teamId, teamName, conference, division, ...)
2. **player** (playerId, teamId, firstName, lastName, ...)
3. **team_stats** (teamId, season, pointsScored, ...)

**Benefits:**
- ✅ Eliminates update anomalies
- ✅ Allows teams without players
- ✅ Preserves team data when players removed
- ✅ No redundant team information

*Follows 3NF - removes transitive dependencies*

---

## Slide 11: NULL Policy
**Strategic NULL Usage**

- **team.stadiumId**: Teams may not have assigned stadium initially
- **player.teamId**: Free agents not on any team
- **player.position**: Players transitioning positions
- **player.dob/height/weight**: Incomplete historical data
- **player.college/draftYear**: Undrafted or international players
- **schedules.gameTime**: TBD game times
- **coaches.teamId**: Coaches between teams

*NULL values represent legitimate "unknown" or "not applicable" states*

---

## Slide 12: Index Strategy
**Composite Index: idx_schedules_season_week**

**Index:** `CREATE INDEX idx_schedules_season_week ON schedules(season, week)`

**Query Pattern:**
```sql
SELECT * FROM schedules 
WHERE season = 2025 AND week = 1;
```

**Benefit:** Single index lookup instead of full table scan for common weekly schedule queries

*Optimizes the most frequent query pattern in the system*

---

## Slide 13: Additional Indexes
**Performance Optimization**

- **idx_team_stats_season**: Fast season-based statistics queries
- **idx_player_team_position**: Efficient player roster lookups by team and position

**Query Examples:**
- "Show all 2024 season stats"
- "List all QBs for team X"

*Indexes support common access patterns*

---

## Slide 14: Evidence Query 1
**Requirement R1: Team Information**

```sql
SELECT t.teamName, t.conference, t.division,
       s.stadiumName, s.locationCity, s.capacity
FROM team t
JOIN stadium s ON t.stadiumId = s.stadiumId
WHERE t.conference = 'NFC'
ORDER BY t.teamName;
```

**Demonstrates:** JOIN operations, filtering by conference, team-stadium relationship

---

## Slide 15: Evidence Query 2
**Requirement R2: Player Information**

```sql
SELECT t.teamName, 
       CONCAT(p.firstName, ' ', p.lastName) AS playerName,
       pos.positionName, pos.offenseOrDefense,
       p.height, p.weight, p.status
FROM player p
JOIN team t ON p.teamId = t.teamId
JOIN positions pos ON p.position = pos.positionCode
WHERE t.teamId = 1 AND p.status = 'Active'
ORDER BY pos.offenseOrDefense, pos.positionName;
```

**Demonstrates:** Multi-table JOIN, filtering by team and status, position categorization

---

## Slide 16: Evidence Query 3
**Requirement R3: Team Statistics**

```sql
SELECT t.teamName, ts.season, ts.pointsScored,
       ts.pointsPerGame, ts.pointsAllowed,
       (ts.pointsScored - ts.pointsAllowed) AS pointDifferential,
       ts.passingYards, ts.rushingYards,
       (ts.passingYards + ts.rushingYards) AS totalYards
FROM team_stats ts
JOIN team t ON ts.teamId = t.teamId
WHERE ts.season = 2024
ORDER BY ts.pointsScored DESC;
```

**Demonstrates:** Aggregation, calculated fields, season-based filtering, performance ranking

---

## Slide 17: Implementation Highlights
**Key Design Decisions**

1. **Surrogate Keys**: Used AUTO_INCREMENT for most tables (flexibility, performance)
2. **Composite Primary Key**: team_stats uses (teamId, season) - natural for the domain
3. **ENUM Types**: Enforce valid values for conference, division, status
4. **CHECK Constraints**: Validate data ranges (height, weight, scores, weeks)
5. **Foreign Keys**: Maintain referential integrity across all relationships

---

## Slide 18: Data Integrity Features
**Constraints and Validation**

- **Referential Integrity**: All foreign keys properly defined
- **Domain Constraints**: ENUM types restrict valid values
- **Range Validation**: CHECK constraints on numeric fields
- **Uniqueness**: teamName must be unique
- **Business Rules**: Teams cannot play themselves (homeTeamId != awayTeamId)

*Comprehensive data protection*

---

## Slide 19: Query Performance
**Optimization Strategy**

- **Composite Indexes**: Support multi-column WHERE clauses
- **Foreign Key Indexes**: Automatically created for FK columns
- **Query Patterns**: Indexes match common access patterns
- **Covering Indexes**: Reduce need for table lookups

*Designed for efficient query execution*

---

## Slide 20: Use Cases
**Real-World Applications**

1. **Team Management**: Track roster changes, player status
2. **Game Scheduling**: Manage season schedules and results
3. **Performance Analysis**: Compare team statistics across seasons
4. **Coaching Staff**: Track coaching assignments and roles
5. **Player Tracking**: Monitor player attributes and draft history

*Supports comprehensive NFL data management*

---

## Slide 21: Database Statistics
**Scale and Capacity**

- **Tables**: 7 core tables
- **Relationships**: 8 foreign key relationships
- **Constraints**: 15+ CHECK constraints
- **Indexes**: 3 performance indexes
- **Data Types**: Properly sized VARCHAR, INT, ENUM, DATE, TIME

*Scalable design for full NFL dataset*

---

## Slide 22: Testing and Validation
**Quality Assurance**

- **Schema Validation**: All tables created successfully
- **Constraint Testing**: CHECK constraints prevent invalid data
- **Foreign Key Testing**: Referential integrity enforced
- **Query Testing**: All evidence queries execute correctly
- **Data Integrity**: NULL policies tested and validated

*Thoroughly tested and verified*

---

## Slide 23: Key Takeaways
**Design Strengths**

✅ **Normalized Design**: Eliminates data anomalies  
✅ **Referential Integrity**: Foreign keys maintain relationships  
✅ **Data Validation**: CHECK constraints ensure quality  
✅ **Performance**: Indexes optimize common queries  
✅ **Flexibility**: NULL policies handle edge cases  
✅ **Scalability**: Design supports full NFL dataset

---

## Slide 24: Conclusion
**Project Summary**

- Complete NFL database system with 7 tables
- Proper normalization (3NF)
- Comprehensive constraints and validation
- Optimized with strategic indexes
- Three evidence queries demonstrate requirements
- Ready for production use

**Thank You!**

Questions?

---

## Slide 25: Q&A Preparation Notes
**Potential Questions & Answers**

**Q: Why surrogate keys instead of natural keys?**  
A: Surrogate keys (AUTO_INCREMENT) provide flexibility for team name changes, better join performance, and independence from business logic.

**Q: Why is team_stats a separate table?**  
A: Team statistics are time-dependent (per season). Separating them allows teams to have multiple season records without redundancy, following normalization principles.

**Q: Why allow NULL for player.teamId?**  
A: Players can be free agents or between teams. This supports real-world scenarios where players exist in the system but aren't currently assigned.

**Q: How does the composite index improve performance?**  
A: The index on (season, week) allows MySQL to quickly locate games for a specific week within a season using a single index lookup, avoiding full table scans.

**Q: Why CHECK constraint on homeTeamId != awayTeamId?**  
A: This enforces a business rule at the database level - a team cannot play itself. It's a domain constraint that prevents logical errors.

---

