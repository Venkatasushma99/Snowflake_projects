use role sysadmin;
use warehouse data_wh;
use database cricket;
use schema clean;
-- version1
-- lets extrcat the elements from innigs array
select info:match_type_number:: number as match_number,
innings
from cricket.raw.match_raw_tbl
where match_number=4672;

--version2
select 
m.info:match_type_number as match_number,
--i.*
i.value:team :: text as team_name
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i
where match_number=4672;

--version3
select 
m.info:match_type_number as match_number,
--i.*
i.value:team :: text as team_name,
--o.*
d.*
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i,
lateral flatten (input=>i.value:overs) o,
lateral flatten (input=>o.value:deliveries) d
where match_number=4672;

--version4
select 
m.info:match_type_number as match_number,
i.value:team :: text as team_name,
o.value:over:: int as over,
d.value:batter:: text as batter,
d.value:bowler::text as bowler,
d.value:non_striker::text as non_striker,
d.value:runs.batter::text as runs,
d.value:runs.extras::text as extras,
d.value:runs.total::text as total,
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i,
lateral flatten (input=>i.value:overs) o,
lateral flatten (input=>o.value:deliveries) d
where match_number=4672;


--version5
select 
m.info:match_type_number as match_number,
i.value:team :: text as team_name,
o.value:over:: int+1 as over,
d.value:batter:: text as batter,
d.value:bowler::text as bowler,
d.value:non_striker::text as non_striker,
d.value:runs.batter::text as runs,
d.value:runs.extras::text as extras,
d.value:runs.total::text as total,
e.key::text as extra_type,
e.value::number as extra_runs
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i,
lateral flatten (input=>i.value:overs) o,
lateral flatten (input=>o.value:deliveries) d,
lateral flatten (input=>d.value:extras,outer=>True) e
where match_number=4672;

--version 5 include wiket

select 
m.info:match_type_number as match_number,
i.value:team :: text as team_name,
o.value:over:: int+1 as over,
d.value:batter:: text as batter,
d.value:bowler::text as bowler,
d.value:non_striker::text as non_striker,
d.value:runs.batter::text as runs,
d.value:runs.extras::text as extras,
d.value:runs.total::text as total,
e.key::text as extra_type,
e.value::number as extra_runs,
w.value:fielders ::variant as fielder_name,
w.value:kind::text as player_out_kind,
w.value:player_out::text as player_out
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i,
lateral flatten (input=>i.value:overs) o,
lateral flatten (input=>o.value:deliveries) d,
lateral flatten (input=>d.value:extras,outer=>True) e,
lateral flatten (input=>d.value:wickets) w
where match_number=4672;