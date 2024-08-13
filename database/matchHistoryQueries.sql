-- Query for complete list of matches

select distinct (select club_name from club where match_home_team = club_id) as home_team, 
       (select club_name from club where match_visiting_team = club_id) as visiting_team,
       match_ht_goals, match_vt_goals, match_id
from matches, club
where (match_home_team = '0001' or match_visiting_team = '0001')
order by match_id asc;

-- Query for players in selected match

select matches.match_id, club.club_name, club_personnel.club_pers_lname, club_personnel.club_pers_role, match_inv_pers.match_inv_role, match_inv_pers.match_min_played
from matches, match_inv_pers, club_personnel, club
where matches.match_id = match_inv_pers.match_id and match_inv_pers.club_pers_id = club_personnel.club_pers_id and club_personnel.club_id = club.club_id and matches.match_id = '000322'
order by club_name, match_inv_role, 
	 case when club_pers_role = 'GOALKEEPER' then 0
	      when club_pers_role = 'DEFENDER'  then 1
              when club_pers_role = 'MIDFIELDER'  then 2
              when club_pers_role = 'FORWARD'  then 3
	 end;

--  Query for all goal instances in a match

select matches.match_id, club_name, club_pers_lname, goal_type, event_time, match_event.ev_id
from matches, match_inv_pers, club_personnel, club, match_event, match_goal
where matches.match_id = match_inv_pers.match_id and
 match_inv_pers.club_pers_id = club_personnel.club_pers_id and club_personnel.club_id = club.club_id
and matches.match_id = match_event.match_id and club_personnel.club_pers_id = match_event.player_id
and match_event.ev_id = match_goal.ev_id and match_event.player_id = match_goal.player_id
and matches.match_id = '000361'
order by event_time;

-- Query for all substitution instances in a match

select distinct match_event.match_id, event_time, 
       (select club_name from club where club_id = 
		(select club_id from club_personnel where match_event.player_id = club_personnel.club_pers_id)) as club,
       (select club_pers_lname from club_personnel where player_in = club_pers_id) as player_subbed_in,
       (select club_pers_lname from club_personnel where player_out = club_pers_id) as player_subbed_out,
	match_event.ev_id
from  club_personnel, match_event, match_sub, club
where  match_event.ev_id = match_sub.ev_id 
and match_event.match_id = '000361'
order by event_time;

-- Query for all disciplinary instances in a match

select  matches.match_id, club_name, club_pers_lname, card_type, event_time, match_event.ev_id
from matches, match_inv_pers, club_personnel, club, match_event, match_card
where matches.match_id = match_inv_pers.match_id and
 match_inv_pers.club_pers_id = club_personnel.club_pers_id and club_personnel.club_id = club.club_id 
and matches.match_id = match_event.match_id and club_personnel.club_pers_id = match_event.player_id 
and match_event.ev_id = match_card.ev_id and match_event.player_id = match_card.player_id 
and matches.match_id = '000361'
order by event_time;

-- Query for all events from a selected match

select match_id, event_type, event_time, ev_id
from match_event 
where match_id = '000361'
order by event_time;
