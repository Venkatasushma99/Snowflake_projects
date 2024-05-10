create or replace transient table cricket.clean.delivery_clean_tbl as
select 
m.info:match_type_number::number as match_number,
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
w.value:player_out::text as player_out,
m.stage_file_name,
m.stage_file_hash_key,
m.stage_file_row_number,
m.stage_modified_ts
from cricket.raw.match_raw_tbl m,
lateral flatten (input=>m.innings) i,
lateral flatten (input=>i.value:overs) o,
lateral flatten (input=>o.value:deliveries) d,
lateral flatten (input=>d.value:extras,outer=>True) e,
lateral flatten (input=>d.value:wickets,outer=>True) w;


select  * from cricket.clean.delivery_clean_tbl where match_number=null;

desc table cricket.clean.delivery_clean_tbl;

alter table cricket.clean.delivery_clean_tbl
modify column match_number set not null;

alter table cricket.clean.delivery_clean_tbl
modify column team_name set not null;

alter table cricket.clean.delivery_clean_tbl
modify column batter set not null;

alter table cricket.clean.delivery_clean_tbl
modify column bowler set not null;

alter table cricket.clean.delivery_clean_tbl
modify column non_striker set not null;

alter table cricket.clean.delivery_clean_tbl
modify column over set not null;

alter table cricket.clean.delivery_clean_tbl
add constraint fk_delv_match_num foreign key (match_number)
references cricket.clean.match_detail_clean (match_type_number);


