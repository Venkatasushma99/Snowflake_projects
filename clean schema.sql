use role sysadmin;
use warehouse data_wh;
use database cricket;

create or replace schema clean;

--step1
-- the meta column doesnot have any real information , it has teh version, created and revision vaulues 
-- extract these columns of data type object

select meta['data_version']::text as data_version,
meta['created']:: date as created,
meta['revision']::number as revision
from cricket.raw.match_raw_tbl;

select meta:data_version::text as data_version,
meta:created:: date as created,
meta:revision::number as revision
from cricket.raw.match_raw_tbl;

--step2
--extract elements in the info column of data type variant
-- we extrcat what info we need as we have lot of info in the info clm

select 
info:match_type_number::int as match_type_number,
info:match_type:: text as match_type,
info:season::text as season,
info:team_type:: text as team_type,
info:overs::text as overs,
info:city::text as city,
info:venue::text as venue
from cricket.raw.match_raw_tbl;

create or replace transient table cricket.clean.match_detail_clean as 
select 
info:match_type_number::int as match_type_number,
info:event.name::text as event_name,
info:event.match_number as match_stage,
info:dates[0]::date as event_date,
date_part('year',info:dates[0]::date) as event_year,
date_part('month',info:dates[0]::date) as event_month,
date_part('day',info:dates[0]::date) as event_day,
info:match_type:: text as match_type,
info:season::text as season,
info:team_type:: text as team_type,
info:overs::text as overs,
info:city::text as city,
info:venue::text as venue,
info:teams[0]::text as first_team,
info:teams[1]::text as second_team,
case when info:outcome.winner is not null then 'Result Declared'
when info:outcome.result='tie' then 'tie'
when info:outcome.result='no result' then 'no result declared'
end as match_result,
case when info:outcome.winner is not null then info:outcome.winner
else 'NA'
end as Winner,
info:toss.winner::text as toss_winner,
initcap(info:toss.decision::text) as toss_desicion,
stage_file_name,
stage_file_hash_key,
stage_file_row_number,
stage_modified_ts
from cricket.raw.match_raw_tbl;


