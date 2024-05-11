#Snowflake Cricket Analysis Project

#Introduction

Cricket is a globally popular sport with various match formats such as ODI, T-20, IPL (in India), and the Asian Cup. This project focuses on analyzing ODI matches played among different countries.

Methodology
Dataset
The dataset used for analysis is in JSON format.

Schema Overview
Land Schema: This schema serves as the initial landing area for the data, where an internal stage is created to load data from an internal storage area using snowcli.

Raw Schema: In this schema, raw data is processed. The nested structure is unwound, and relevant data including meta, info, and innings details are extracted along with additional attributes like hash value, file name, timestamp, and row number.

Clean Schema: The data undergoes cleaning processes in this schema. Unnecessary elements in the meta variable are removed, and essential elements from the info variable are extracted and stored in the match detail table. Additionally, a separate table is created to store player details, and flattening techniques are employed to handle JSON-formatted player data.

Dimension and Fact Tables: Dimension tables for Date, Referee, Team, Player, and Venue are created and linked to the match fact table, enabling comprehensive analysis.

Tables Created
Match Detail Table: Contains match number, event name, event date, match type, season, team type, overs, venue, teams, and match outcome.

Player Details Table: Stores match number, country, and team player information.

Innings Table: Records match number, team name, overs, batters, bowlers, non-strikers, runs, extras, total score, extra type, and fielder name for each inning.

Usage
This project provides a structured approach to analyze ODI cricket matches, facilitating efficient data cleaning, organization, and analysis. The provided schema and tables allow for complex queries and insights generation.
