create or replace table date_dim(
date_id int primary key autoincrement,
full_dt date,
day int,
month int,
year int,
quarter int,
dayofweek int,
dayofmonth int,
dayofyear int,
dayofweekname varchar(3),
isweekend boolean
);

-- refree details
create or replace table referee_dim(
referee_id int primary key autoincrement,
referee_name text not null,
referee_type text not null
);

-- teams
create or replace table team_dim(
team_id int primary key autoincrement,
team_name text not null
);

--player
create or replace table player_dim(
player_id int primary key autoincrement,
team_id int not null,
player_name text not null
);

alter table cricket.consumption.player_dim
add constraint fk_player_id foreign key (team_id)
references cricket.consumption.team_dim (team_id);

create or replace table venue_dim(
venue_id int primary key autoincrement,
venue_name text not null,
city text not null,
state text,
country text,
continent text,
end_names text,
capacity number,
pitch text,
flood_light boolean,
established_date date,
playing_area text,
other_sports text,
curator text,
lattitude number(10,6),
longitude number(10,6)
);


create or replace table match_type_dim(
match_type_id int primary key autoincrement,
match_type text not null
);

CREATE or replace TABLE match_fact (
    match_id INT PRIMARY KEY,
    date_id INT NOT NULL,
    referee_id INT NOT NULL,
    team_a_id INT NOT NULL,
    team_b_id INT NOT NULL,
    match_type_id INT NOT NULL,
    venue_id INT NOT NULL,
    total_overs number,
    balls_per_over number,

    overs_played_by_team_a number,
    bowls_played_by_team_a number,
    extra_bowls_played_by_team_a number,
    extra_runs_scored_by_team_a number,
    fours_by_team_a number,
    sixes_by_team_a number,
    total_score_by_team_a number,
    wicket_lost_by_team_a number,

    overs_played_by_team_b number,
    bowls_played_by_team_b number,
    extra_bowls_played_by_team_b number,
    extra_runs_scored_by_team_b number,
    fours_by_team_b number,
    sixes_by_team_b number,
    total_score_by_team_b number,
    wicket_lost_by_team_b number,

    toss_winner_team_id int not null, 
    toss_decision text not null, 
    match_result text not null, 
    winner_team_id int not null,

    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES date_dim (date_id),
    CONSTRAINT fk_referee FOREIGN KEY (referee_id) REFERENCES referee_dim (referee_id),
    CONSTRAINT fk_team1 FOREIGN KEY (team_a_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_team2 FOREIGN KEY (team_b_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_match_type FOREIGN KEY (match_type_id) REFERENCES match_type_dim (match_type_id),
    CONSTRAINT fk_venue FOREIGN KEY (venue_id) REFERENCES venue_dim (venue_id),

    CONSTRAINT fk_toss_winner_team FOREIGN KEY (toss_winner_team_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_winner_team FOREIGN KEY (winner_team_id) REFERENCES team_dim (team_id)
);