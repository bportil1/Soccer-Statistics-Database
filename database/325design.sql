drop table club cascade constraints;
create table club
(club_id                char(4),
 club_name              varchar2(25),
 club_status            varchar(8) check(club_status in ('ACTIVE', 'INACTIVE')),
 primary key            (club_id)
);

drop table club_personnel cascade constraints;  
create table club_personnel
(club_pers_lname	varchar2(20),
 club_pers_fname 	varchar2(20),
 club_pers_id 		char(6),
 club_pers_nationality  varchar2(20),
 club_pers_role		varchar2(15),
 club_pers_age		decimal(2),
 club_pers_status	varchar2(8) check(club_pers_status in('ACTIVE', 'INACTIVE')),
 club_id		char(4),
 primary key		(club_pers_id),
 foreign key		(club_id) references club
);


drop table matches cascade constraints;  
create table matches
(match_home_team	char(4) not null,
 match_visiting_team	char(4) not null,
 match_ht_goals		decimal(2),
 match_vt_goals		decimal(2),
 match_date		date,
 match_id		char(6),
 comp_id		char(4),
 season_id		char(6),
 primary key		(match_id),
 foreign key		(comp_id) references competition,
 foreign key		(season_id) references season,
 foreign key		(match_home_team) references club(club_id),
 foreign key		(match_visiting_team) references club(club_id)
);

drop table match_inv_pers;  
create table match_inv_pers
(club_pers_id		char(6),
 match_id		char(6),
 match_inv_role		varchar2(10) check(match_inv_role in('COACH', 'STARTER', 'SUB')),
 match_min_played	decimal(5,2),
 primary key		(match_id, club_pers_id),
 foreign key		(club_pers_id) references club_personnel,
 foreign key		(match_id) references matches
);


drop table match_event cascade constraints;  
create table match_event
(match_id		char(6),
 player_id		char(6),
 event_type		char(4) check(event_type in('CARD', 'GOAL', 'SUB')), 
 event_time		decimal(3),
 ev_id			char(8),
 primary key		(ev_id),
 foreign key		(match_id, player_id) references match_inv_pers(match_id, club_pers_id)
);

drop table match_card;  
create table match_card
(match_id		char(6),
 player_id		char(6),
 card_type		varchar(6) check(card_type in ('YELLOW', 'RED')),
 ev_id 			char(8),
 primary key		(ev_id), 
 foreign key		(ev_id) references match_event
);

drop table match_goal;  
create table match_goal
(match_id		char(6),
 goal_type		varchar(7) check(goal_type in ('GOAL', 'OWN GOAL')),		
 player_id		char(6),		
 ev_id			char(8),
 primary key		(ev_id), 
 foreign key		(ev_id) references match_event
);

drop table match_sub;  
create table match_sub
(match_id		char(6),	
 player_in		char(6),
 player_out		char(6),
 ev_id			char(8),
 primary key		(ev_id), 
 foreign key		(ev_id) references match_event
);

drop table competition cascade constraints;  
create table competition
(comp_id		char(4),
 comp_country_name	varchar(25),	
 comp_name		varchar(25),
 is_group		char(1),
 is_knockout		char(1),
 comp_tier		decimal(1),
 primary key		(comp_id)
);

drop table comp_type_group;
create table comp_type_group
(comp_id		char(4),
 group_name		char(1),
 primary key		(comp_id, group_name),
 foreign key		(comp_id) references competition
);

drop table comp_type_knockout;
create table comp_type_knockout
(comp_id		char(4),
 ko_round		varchar(12),
 primary key		(comp_id, ko_round),
 foreign key		(comp_id) references competition
);

drop table season cascade constraints;
create table season
(season_id		char(6),
 season_yr 		char(4) not null,
 comp_id		char(4),
 primary key		(season_id)
);

