use role sysadmin;
create or replace warehouse data_wh;

-- create database 
create or replace database cricket;

--create schemas 
create or replace schema cricket.land;
create or replace schema cricket.raw;
create or replace schema cricket.clean;
create or replace schema cricket.consumption;

show schemas;

use schema land;
-- do file formating for jason

create or replace file format cricket.land.my_json_format
type=json
null_if=('\\n','null','')
strip_outer_array=True
comment='Json File Format with outer strip array true';

-- create internal stage area
create or replace stage cricket.land.my_stg;

list @cricket.land.my_stg;

list @my_stg/cricket/json;

select 
t.$1:meta::variant as meta,
t.$1:info:: variant as info,
t.$1:innings:: variant as innings
from @my_stg/cricket/json/1384412.json.gz (file_format=>'my_json_format') t;


