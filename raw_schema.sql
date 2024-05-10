use role sysadmin;
create or replace schema raw;
use database cricket;

-- creating table inside the raw layer

create or replace table cricket.raw.match_raw_tbl(
meta object not null,
info variant not null,
innings array not null,
stage_file_name text not null,
stage_file_hash_key text not null,
stage_file_row_number int not null,
stage_modified_ts timestamp not null
);

-- copying the staged files into the snowflake 
copy into cricket.raw.match_raw_tbl from (
select 
t.$1:meta::object as meta,
t.$1:info::variant as info,
t.$1:innings:: array as innings,
metadata$filename as stage_file_name,
metadata$file_content_key as stage_file_hash_key,
metadata$file_row_number as stage_file_row_number,
metadata$file_last_modified as stage_modifies_ts
from @cricket.land.my_stg/cricket/json (file_format=>'cricket.land.my_json_format') t);

-- check how many rows are there in raw table
select count(*) from cricket.raw.match_raw_tbl;

