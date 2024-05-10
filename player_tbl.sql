-- extract players
-- version 1
select 
info:match_type_number::int as match_number,
info:players,
info:teams
from cricket.raw.match_raw_tbl;

select 
info:match_type_number::int as match_number,
p.*
--p.key::text as country
from cricket.raw.match_raw_tbl,
lateral flatten (input=> info:players) p
where match_number=4672;

select 
info:match_type_number::int as match_number,
p.key::text as country,
p.value::array as players
from cricket.raw.match_raw_tbl,
lateral flatten (input=> info:players) p
where match_number=4672;


select 
info:match_type_number::int as match_number,
p.key::text as country,
team.*
from cricket.raw.match_raw_tbl,
lateral flatten (input=> info:players) p,
lateral flatten (input=> p.value) team
where match_number=4672;

--flattening both team players and country
select 
info:match_type_number::int as match_number,
p.key::text as country,
team.value::text as team_players
from cricket.raw.match_raw_tbl,
lateral flatten (input=> info:players) p,
lateral flatten (input=> p.value) team
where match_number=4672;

create or replace table cricket.clean.player_clean_tbl as
select 
info:match_type_number::int as match_number,
p.key::text as country,
team.value::text as team_players,
stage_file_hash_key,
stage_file_name,
stage_file_row_number,
stage_modified_ts
from cricket.raw.match_raw_tbl,
lateral flatten (input=> info:players) p,
lateral flatten (input=> p.value) team;


-- lets desc table
desc table cricket.clean.player_clean_tbl;

--add not null and fk relationships
alter table cricket.clean.player_clean_tbl
modify column match_number set not null;

alter table cricket.clean.player_clean_tbl
modify column country set not null;

alter table cricket.clean.player_clean_tbl
modify column team_players set not null;

alter table cricket.clean.match_detail_clean
add constraint pk_match_num primary key (match_type_number);

alter table cricket.clean.player_clean_tbl
add constraint fk_match_num foreign key (match_number)
references cricket.clean.match_detail_clean (match_type_number);

--describe table
desc table cricket.clean.player_clean_tbl;

select get_ddl('table','cricket.clean.player_clean_tbl');

select distinct country from cricket.clean.player_clean_tbl;
