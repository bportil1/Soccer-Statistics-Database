-- Query for aggregate team statistics

select club_pers_id as p_id, club_pers_role, concat(club_pers_lname, ", ", club_pers_fname) as player_name,
       (select count('a') from match_inv_pers where club_pers_id = p_id) as matches_played,
       (select count('a') from match_event where event_type = "SUB" and player_id = p_id) as matches_subbed,
       (select sum(match_min_played) from match_inv_pers where club_pers_id = p_id) as mins_played,
       (select count('a') from match_goal where player_id = p_id) as goals,
       (select count('a') from match_card where card_type = 'YELLOW' and player_id = p_id) as yellow_cards,
       (select count('a') from match_card where card_type = 'RED' and player_id = p_id) as red_cards 
from club, club_personnel
where club.club_id = '0003' and club_personnel.club_id = '0003';

-- Query for aggregate player statistics (goals scored)

select club_pers_id as p_id, club_name, concat(club_pers_lname, ", ", club_pers_fname) as player_name,
       (select count('a') from match_goal where player_id = p_id) as goals
from club_personnel, club
where club_personnel.club_id = club.club_id
order by goals desc
limit 30;

-- Query for aggregate player statistics (yellow cards received)

select club_pers_id as p_id, club_name, concat(club_pers_lname, ", ", club_pers_fname) as player_name,
       (select count('a') from match_card where player_id = p_id and card_type = 'YELLOW') as yellow_cards
from club_personnel, club
where club_personnel.club_id = club.club_id
order by yellow_cards desc
limit 30;

-- Query for aggregate player statistics (red cards received)

select club_pers_id as p_id, club_name, concat(club_pers_lname, ", ", club_pers_fname) as player_name,
       (select count('a') from match_card where player_id = p_id and card_type = 'RED') as red_cards
from club_personnel, club
where club_personnel.club_id = club.club_id 
order by red_cards desc
limit 30;

-- Query for aggregate player statistics (minutes played)

select club_pers_id as p_id, club_name, concat(club_pers_lname, ", ", club_pers_fname) as player_name,
       club_pers_role,
       (select sum(match_min_played) from match_inv_pers where club_pers_id = p_id) as mins_played
from club_personnel, club
where club_personnel.club_id = club.club_id
order by mins_played desc
limit 30;


