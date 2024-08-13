-- home table

drop view home_table;
create view home_table(club_name, GF, GA, HW, HD, HL) as
select club_name, sum(matches.match_ht_goals) "GF", sum(matches.match_vt_goals) "GA", count(case when match_ht_goals > match_vt_goals then 1 end) "HW"
        ,count(case when match_ht_goals = match_vt_goals then 1 end) "HD", count(case when match_ht_goals < match_vt_goals then 1 end) "HL"
from matches, club
where matches.match_home_team = club.club_id
group by club_name;

drop view home_table_sum;
create view home_table_sum(club_name, W, D, L, GF, GA, GD, PTS) as
select club_name, home_table.HW "W", home_table.HD "D", home_table.HL "L", home_table.GF "GF", home_table.GA "GA", (home_table.GF - home_table.GA) "GD", (3 * home_table.HW) + (1 * home_table.HD)  "PTS"
from home_table
order by (3 * home_table.HW) + (1 * home_table.HD) desc, (home_table.GF - home_table.GA) desc;

select * from home_table_sum;

--  visiting table
drop view away_table;
create view away_table(club_name, GF, GA, AW, AD, AL) as
select club_name, sum(match_vt_goals) "GF", sum(match_ht_goals) "GA", count(case when match_vt_goals > match_ht_goals then 1 end) "AW"
,count(case when match_vt_goals = match_ht_goals then 1 end) "AD", count(case when match_vt_goals < match_ht_goals then 1 end) "AL"
from matches, club
where matches.match_visiting_team = club.club_id
group by club_name;

drop view away_table_sum;
create view away_table_sum(club_name, W, D, L, GF, GA, GD, PTS) as
select club_name, away_table.AW "W", away_table.AD "D", away_table.AL "L", away_table.GF "GF", away_table.GA "GA", (away_table.GF - away_table.GA) "GD", (3 * away_table.AW) + (1 * away_table.AD) "PTS"
from away_table
order by (3 * away_table.AW) + (1 * away_table.AD) desc, (away_table.GF - away_table.GA) desc;  

select * from away_table_sum;

drop view total_table;
-- compute sum label "TOTAL" of GF on REPORT
-- compute sum label "TOTAL" of GA on REPORT
create view total_table(club_name, W, D, L, GF, GA, GD, PTS) as
select home_table.club_name, HW + AW, HD + AD, HL + AL, home_table.GF + away_table.GF "GF", home_table.GA + away_table.GA "GA", (home_table.GF + away_table.GF) - (home_table.GA + away_table.GA) "GD", (3 * home_table.HW + 3 * away_table.AW ) + (1 * home_table.HD + 1 * away_table.AD) "PTS"
from home_table, away_table
where home_table.club_name = away_table.club_name
order by  (3 * home_table.HW + 3 * away_table.AW ) + (1 * home_table.HD + 1 * away_table.AD) desc, (home_table.GF + away_table.GF) - (home_table.GA + away_table.GA) desc;

select * from total_table;
