use role sysadmin;
use warehouse data_wh;
use database cricket;
use schema clean;

select * from cricket.clean.match_detail_clean where match_type_number=4672;

-- sum of scores by team
select 
team_name,sum(runs)+sum(extra_runs)
from cricket.clean.delivery_clean_tbl
where match_number=4672
group by team_name;

-- sum of scores by batsman

select 
team_name,batter,sum(runs)
from cricket.clean.delivery_clean_tbl
where match_number=4672
group by team_name,batter;