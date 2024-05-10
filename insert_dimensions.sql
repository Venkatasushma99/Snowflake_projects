-- lets start with team dim and for simplicity, it is just tema name

select distinct team_name from (
select first_team as team_name from cricket.clean.match_detail_clean
union all
select first_team as team_name from cricket.clean.match_detail_clean
);

--v2
insert into cricket.consumption.team_dim (team_name)
select distinct team_name from (
select first_team as team_name from cricket.clean.match_detail_clean
union all
select second_team as team_name from cricket.clean.match_detail_clean
);

select * from cricket.consumption.team_dim;

-- team player

-- player country
select country,team_players from cricket.clean.player_clean_tbl group by country,team_players;

--v2
select a.country,b.team_id,a.team_players
from cricket.clean.player_clean_tbl a join cricket.consumption.team_dim b
on a.country=b.team_name
group by 
1,2,3;

-- insert data
insert into cricket.consumption.player_dim (team_id,player_name)
select b.team_id,a.team_players
from cricket.clean.player_clean_tbl a join cricket.consumption.team_dim b
on a.country=b.team_name
group by 
1,2;


select * from cricket.consumption.player_dim;

-- Referee dimension
-- since we have not populated the refree details in our privous layer
-- we will skip this for now.

--v1
select * from cricket.raw.match_raw_tbl limit 10;

--v2
select info:officials.match_referees[0]:: text as match_referees,
info:officials.reserve_umpires[0]::text as reserve_umpires,
info:officials.tv_umpires[0]::text as tv_umpires,
info:officials.umpires[0]:: text as first_umpire,
info:officials.umpires[1]:: text as second_umpire
from cricket.raw.match_raw_tbl;

--venue dimension
select venue,city from cricket.clean.match_detail_clean 
group by 1,2;

insert into cricket.consumption.venue_dim(venue_name,city)
select venue,city from cricket.clean.match_detail_clean 
group by 1,2;

--match dimension

drop table 

insert into cricket.consumption.match_type_dim(match_type)
select match_type from cricket.clean.match_detail_clean group by 1;

--date dimension

select min(event_date),max(event_date) from cricket.clean.match_detail_clean;
