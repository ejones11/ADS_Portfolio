if not exists(select * from sys.databases where name='finalproject')
create database finalproject
go
use finalproject
GO
--DOWN
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_shot_assisted_by_player_id')
    alter table shots drop constraint fk_shot_assisted_by_player_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_shot_by_player_id')
    alter table shots drop constraint fk_shot_by_player_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_shots_game_id')
    alter table shots drop constraint fk_shots_game_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_team_state_state_code')
       alter table teams drop constraint fk_team_state_state_code
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_players_player_team_id')
    alter table players drop constraint fk_players_player_team_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_players_grade_classes')
    alter table players drop constraint fk_players_grade_classes
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_players_positions')
    alter table players drop constraint fk_players_positions
drop table if exists state_lookup 
drop table if exists grade_classes
drop table if exists positions 
drop table if exists players
drop table if exists teams 
drop table if exists games 
drop table if exists shots
go
--UP METADATA

create table state_lookup(
    state_code char (2) not null,
    constraint pk_states_lookup_state_code primary key (state_code)
)

create table grade_classes(
    grade_class varchar (20) not null,
    constraint pk_grade_classes_grade_class primary key(grade_class)
)

create table positions(
    position varchar (2) not null,
    constraint pk_positions_postiton primary key (position) 
)
create table players(
    player_id int identity not null,
    player_school_id char (9),
    player_firstname varchar (50) not null,
    player_lastname varchar (50) not null,
    player_height int null,
    player_weight int null,
    player_position varchar (2) null,
    player_gradeclass varchar (20),
    player_team_id int null,
    constraint pk_players_player_id primary key (player_id),
     constraint u_player_id unique (player_school_id,player_team_id)
)

create table teams(
    team_id int identity not null,
    team_name varchar (50) not null,
    team_city varchar (50) null,
    team_state char(2) null,
    constraint pk_teams_team_id primary key (team_id),
    constraint u_teams_team_name unique (team_name)
)
create table games(
    game_id int identity not null,
    game_date date not null,
    game_home_team_id int not null,
    game_visiting_team_id int not null,
    constraint pk_games_game_id primary key (game_id)
)

create table shots (
    shot_id int identity not null,
    shot_by int not null,
    shot_assisted_by int null,
    shot_game_id int not null, 
    shot_distance decimal null,
    shot_quarter int null,
    shot_made tinyint null,
    constraint pk_shots_shot_id primary key (shot_id),
    constraint ck_quarter check (shot_quarter between 1 and 4),
    constraint ck_dummy_shot_made check (shot_made between 0 and 1)
)

alter table players 
    add constraint fk_players_grade_classes foreign key (player_gradeclass) 
    REFERENCES grade_classes(grade_class)
alter table players  
    add constraint fk_players_positions foreign key (player_position) 
    references positions(position)
alter table players  
    add constraint fk_players_player_team_id foreign key (player_team_id) 
    references teams(team_id)

alter table teams
    add constraint fk_team_state_state_code foreign key (team_state)
    references state_lookup(state_code)

alter table shots
    add constraint fk_shots_game_id foreign key (shot_game_id)
    references games(game_id)

alter table shots
    add constraint fk_shot_by_player_id foreign key (shot_by)
    references players(player_id)

alter table shots
    add constraint fk_shot_assisted_by_player_id foreign key (shot_assisted_by)
    references players(player_id)



-- UP DATA
insert into state_lookup (state_code) VALUES
('AL'),('AK'), ('AZ'), ('AR'),  ('CA'),('CO'), ('CT'),('DE'), ('DC'),
     ('FL'), ('GA'), ('HI'),('ID'), ('IL'), ('IN'), ('IA'),  ('KS'), ('KY'),
      ('LA'), ('ME'), ('MD'), ('MA'), ('MI'),('MN'),('MS'),('MO'),('MT'),('NE'),
       ('NV'),('NH'),('NJ'),('NM'), ('NY'), ('NC'), ('ND'), ('OH'), ('OK'),
       ('OR'), ('PA'), ('RI'),('SC'),('SD'),('TN'),('TX'),('UT'),('VT'),
       ('VA'), ('WA'),  ('WV'), ('WI'), ('WY')

insert into grade_classes(grade_class) VALUES   
('Freshman'),('Sophomore'),('Junior'),('Senior')
insert into positions (position) VALUES
('PG'),('SG'),('SF'),('PF'),('C')

insert into teams (team_name,team_city,team_state) VALUES
('Denver Prep Academy','Denver','CO'),
('Sierra Canyon', 'Los Angeles','CA'),
('Christ the King','Queens','NY'),
('Camden High School','Camden','NJ')
 

insert into players (player_firstname,player_lastname,player_school_id,player_height, player_weight, player_position,player_gradeclass,player_team_id) VALUES
('Emoni','Bates','123456789',80,200, 'SF','Senior',1),
('DJ','Wagner','012345678',74,175,'PG','Junior',1),
('Robert','Dillingham','901234567',73,170,'SG','Senior',1),
('Ron','Holland','890123456',80,200,'PF','Sophomore',1),
('Baye','Fall','789012345',83,217,'C','Junior',1),
('Bronny','James','678910234',75,190,'SG','Senior',2),
('Cameron','Boozer','567890123',80,215,'PF','Freshman',2),
('Simeon','Wilcher','456789012',75,185,'PG','Sophomore',2),
('Nassir','Cunningham','34567891',77,175,'SF','Junior',2),
('John','Bol','234567890',84,210,'C','Senior',2),
('David','Castillo','987654321',73,175,'PG','Junior',3),
('Koa','Peat','876543210',80,215,'SF','Freshman',3),
('Amari','Bailey','865432105',76,185,'SG','Senior',3),
('Dereck','Lively','19876543',85,215,'C','Senior',3),
('Kwame','Evans','213406321', 81,200,'PF','Sophomore',3),
('Sean','Stewart','563545901',80,230,'PF','Senior',4),
('Isaiah','Collier','454577500',74,170,'PG','Junior',4),
('Aaron','Bradshaw','678903456',84,215,'C','Freshman',4),
('Jared','McCain','909872569',74,175,'SG','Sophomore',4),
('Kris','Parker','260757577',78,185,'SF','Senior',4)

insert into games (game_date,game_home_team_id,game_visiting_team_id) values 
('10-14-21',1,2),
('10-16-21',2,1),
('10-14-21',3,4),
('10-14-21',4,3),
('10-18-21',1,3),
('10-21-21',3,1),
('10-18-21',2,4),
('10-21-21',4,2),
('10-23-21',1,4),
('10-25-21',4,1),
('10-23-21',2,3),
('10-25-21',3,2)

insert into shots (shot_by,  shot_assisted_by, shot_game_id, shot_distance , shot_quarter,shot_made) values 
(1,2,1,20,1,1),
(6,10,1,12,1,1),
(5,1,1,3,1,0),
(3,null,1,15,1,1),
(9,8,1,23,1,0),
(1,2,1,24,1,0),
(4,null,1,15,1,1),
(10,8,1,3,1,0),
(1,2,1,21,1,1),
(10,9,1,1,1,1),
(6,8,1,22,2,1),
(2,1,1,20,2,1),
(5,2,1,10,2,0),
(4,null,1,12,2,0),
(9,8,1,21,2,1),
(10,7,1,2,2,1),
(3,null,1,10,2,0),
(9,null,1,13,2,1),
(4,5,1,12,2,1),
(8,10,1,22,2,1),
(3,2,1,21,3,0),
(5,1,1,2,3,1),
(9,null,1,16,3,0),
(6,7,1,21,3,1),
(4,5,1,10,3,1),
(1,2,1,21,3,1),
(9,8,1,21,3,0),
(3,null,1,12,3,0),
(9,8,1,21,3,1),
(4,5,1,15,3,1),
(10,8,1,1,3,0),
(8,10,1,20,4,0),
(9,null,1,1,4,0),
(5,2,1,2,4,1),
(3,5,1,21,4,0),
(10,8,1,1,4,1),
(2,null,1,20,4,1),
(6,8,2,21,1,0),
(10,6,2,2,1,1),
(1,null,2,12,1,1),
(7,10,2,10,1,0),
(3,2,2,23,1,0),
(4,null,2,7,1,1),
(8,6,2,20,1,1),
(6,null,2,13,2,0),
(4,1,2,10,2,1),
(3,2,2,21,2,0),
(9,8,2,20,2,0),
(10,7,2,2,2,1),
(6,null,2,15,2,1),
(1,null,2,14,3,0),
(1,2,2,2,3,1),
(8,6,2,23,3,1),
(5,2,2,3,3,0),
(6,9,2,24,3,0),
(10,7,2,15,3,1),
(3,null,2,17,3,1),
(4,5,2,13,4,0),
(6,null,2,21,4,1),
(1,null,2,23,4,0),
(7,8,2,15,4,0),
(6,9,2,20,4,1),
(2,null,2,15,4,1),
(1,2,2,22,4,0),
(19,17,3,21,1,1),
(13,null,3,12,1,0),
(14,11,3,1,1,0),
(20,null,3,10,1,0),
(17,null,3,1,1,1),
(13,15,3,20,1,0),
(11,null,3,1,1,0),
(16,18,3,10,2,1),
(12,11,3,20,2,1),
(14,11,3,1,2,0),
(17,null,3,10,2,0),
(19,17,3,22,2,0),
(11,14,3,12,2,0),
(12,null,3,17,2,1),
(19,18,3,21,2,1),
(15,13,3,20,3,0),
(12,11,3,21,3,0),
(17,null,3,12,3,1),
(13,null,3,1,3,1),
(20,16,3,23,3,0),
(14,11,3,1,3,0),
(19,null,3,14,3,1),
(12,11,3,21,4,1),
(13,null,3,1,4,0),
(16,18,3,20,4,0),
(20,16,3,1,4,1),
(13,null,3,16,4,1),
(14,11,3,2,4,1),
(13,11,4,22,1,1),
(18,17,4,2,1,0),
(19,null,4,2,1,0),
(13,11,4,24,1,0),
(17,null,4,20,1,1),
(14,11,4,1,1,0),
(13,null,4,12,1,0),
(12,15,4,20,2,0),
(16,18,4,15,2,1),
(20,17,4,21,2,1),
(15,17,4,12,2,1),
(13,11,4,22,2,0),
(13,null,4,1,2,0),
(18,17,4,1,2,1),
(14,11,4,2,2,1),
(20,null,4,12,3,1),
(19,17,4,23,3,0),
(14,11,4,1,3,0),
(17,16,4,2,3,0),
(13,null,4,2,3,1),
(19,null,4,28,3,0),
(14,11,4,5,4,1),
(13,11,4,20,4,1),
(17,null,4,15,4,1),
(20,17,4,20,4,0),
(11,null,4,15,4,0),
(17,null,4,13,4,1),
(14,11,4,1,4,0),
(13,11,5,22,1,1),
(1,2,5,20,1,0),
(5,1,5,1,1,1),
(13,null,5,10,1,0),
(15,11,5,20,1,1),
(14,15,5,1,1,1),
(3,2,5,20,1,1),
(3,2,5,20,1,0),
(15,14,5,15,1,0),
(1,null,5,12,2,1),
(2,1,5,20,2,0),
(4,5,5,10,2,1),
(13,null,5,1,2,1),
(12,11,5,20,2,0),
(3,null,5,10,2,0),
(5,2,5,1,2,0),
(1,2,5,20,2,1),
(2,1,5,20,3,0),
(2,1,5,21,3,1),
(13,null,5,1,3,0),
(3,2,5,20,3,1),
(2,1,5,20,3,1),
(4,1,5,20,3,1),
(15,11,5,20,3,0),
(3,null,5,10,3,1),
(1,2,5,20,4,1),
(4,1,5,15,4,0),
(14,15,5,10,4,1),
(5,2,5,1,4,1),
(1,null,5,13,4,0),
(12,null,5,12,4,1),
(4,2,5,15,4,1),
(1,2,6,20,1,1),
(5,1,6,1,1,0),
(13,11,6,22,1,1),
(13,null,6,10,1,1),
(15,11,6,20,1,0),
(14,15,6,1,1,0),
(3,2,6,20,1,0),
(3,2,6,20,1,1),
(15,14,6,15,1,1),
(1,null,6,12,2,0),
(2,1,6,20,2,1),
(4,5,6,10,2,0),
(13,null,6,1,2,0),
(12,11,6,20,2,1),
(3,null,6,10,2,1),
(5,2,6,1,2,1),
(1,2,6,20,2,0),
(2,1,6,20,3,1),
(2,1,6,21,3,0),
(13,null,6,1,3,1),
(3,2,6,20,3,0),
(2,1,6,20,3,0),
(4,1,6,20,3,0),
(15,11,6,20,3,1),
(3,null,6,10,3,0),
(1,2,6,20,4,0),
(4,1,6,15,4,1),
(14,15,6,10,4,0),
(5,2,6,1,4,0),
(1,null,6,13,4,1),
(12,null,6,12,4,0),
(4,2,6,15,4,0),
(6,8,7,23,1,0),
(19,17,7,23,1,1),
(10,6,7,1,1,1),
(6,9,7,23,1,1),
(16,18,7,15,1,0),
(9,null,7,15,1,0),
(20,null,7,23,1,1),
(19,17,7,21,2,1),
(17,null,7,13,2,0),
(9,8,7,23,2,1),
(6,null,7,13,2,0),
(20,17,7,21,2,1),
(6,7,7,13,2,1),
(19,null,7,15,2,1),
(7,10,7,12,2,1),
(20,17,7,23,3,1),
(6,null,7,13,3,1),
(20,17,7,21,3,0),
(6,9,7,23,3,0),
(16,18,7,15,3,1),
(10,8,7,1,3,1),
(20,17,7,24,3,0),
(6,null,7,15,3,0),
(19,null,7,15,4,0),
(6,9,7,22,4,1),
(20,17,7,20,4,1),
(9,8,7,21,4,0),
(17,null,7,1,4,1),
(6,7,7,23,4,0),
(6,8,8,23,1,1),
(19,17,8,23,1,0),
(10,6,8,1,1,0),
(6,9,8,23,1,0),
(16,18,8,15,1,1),
(9,null,8,15,1,1),
(20,null,8,23,1,0),
(9,null,8,15,1,0),
(20,null,8,23,1,1),
(19,17,8,21,2,0),
(17,null,8,13,2,1),
(9,8,8,23,2,0),
(6,null,8,13,2,1),
(20,17,8,21,2,0),
(6,7,8,13,2,0),
(19,null,8,15,2,0),
(7,10,8,12,2,1),
(20,17,8,23,3,0),
(6,null,8,13,3,0),
(20,17,8,21,3,1),
(6,9,8,23,3,1),
(20,17,8,20,3,1),
(16,18,8,15,3,0),
(10,8,8,1,3,1),
(20,17,8,24,3,0),
(6,null,8,15,3,1),
(19,null,8,15,4,1),
(6,9,8,22,4,1),
(20,17,8,20,4,0),
(9,8,8,21,4,0),
(17,null,8,1,4,0),
(20,17,8,20,4,1),
(6,7,8,23,4,1),
(1,null,9,21,1,1),
(19,17,9,22,1,0),
(4,5,9,15,1,0),
(18,17,9,1,1,1),
(2,null,9,15,1,0),
(20,null,9,12,1,1),
(2,null,9,1,1,1),
(3,2,9,21,2,1),
(19,null,9,15,2,0),
(1,2,9,23,2,0),
(17,18,9,21,2,1),
(1,null,9,15,2,1),
(18,17,9,1,2,1),
(4,5,9,15,2,0),
(20,null,9,15,3,1),
(4,5,9,12,3,1),
(19,17,9,24,3,0),
(2,null,9,1,3,1),
(19,17,9,24,3,1),
(1,2,9,22,3,0),
(20,17,9,30,3,1),
(1,2,9,21,4,0),
(19,null,9,22,4,1),
(2,4,9,15,4,1),
(16,17,9,13,4,0),
(3,4,9,21,4,0),
(18,16,9,1,4,1),
(4,2,9,21,4,1),
(1,null,10,21,1,0),
(19,17,10,22,1,1),
(4,5,10,15,1,1),
(18,17,10,1,1,0),
(2,null,10,15,1,1),
(20,null,10,12,1,0),
(2,null,10,1,1,0),
(3,2,10,21,2,0),
(19,null,10,15,2,1),
(1,2,10,23,2,1),
(17,18,10,21,2,0),
(1,null,10,15,2,0),
(18,17,10,1,2,0),
(4,5,10,15,2,1),
(20,null,10,15,3,0),
(4,5,10,12,3,0),
(19,17,10,24,3,1),
(2,null,10,1,3,0),
(19,17,10,24,3,0),
(1,2,10,22,3,1),
(20,17,10,30,3,0),
(1,2,10,21,4,1),
(19,null,10,22,4,0),
(2,4,10,15,4,0),
(16,17,10,13,4,1),
(3,4,10,21,4,1),
(18,16,10,1,4,0),
(4,2,10,21,4,0),
(19,16,10,21,4,1),
(6,9,11,21,1,1),
(13,11,11,21,1,1),
(9,null,11,12,1,0),
(14,15,11,5,1,1),
(9,10,11,22,1,0),
(13,12,11,17,1,0),
(8,null,11,12,1,1),
(15,14,11,1,2,1),
(9,null,11,1,2,1),
(13,null,11,22,2,1),
(6,8,11,21,2,0),
(13,11,11,22,2,1),
(7,6,11,12,2,0),
(12,null,11,15,2,0),
(12,null,11,1,3,1),
(6,10,11,21,3,1),
(15,null,11,12,3,0),
(9,10,11,21,3,1),
(14,11,11,1,3,1),
(8,6,11,21,3,0),
(13,null,11,1,3,1),
(7,10,11,12,4,1),
(12,11,11,21,4,1),
(9,8,11,5,4,0),
(15,14,11,10,4,0),
(7,null,11,10,4,1),
(13,11,11,23,4,1),
(8,6,11,22,4,1),
(6,9,12,21,1,0),
(13,11,12,21,1,0),
(9,null,12,12,1,1),
(14,15,12,5,1,0),
(9,10,12,22,1,1),
(13,12,12,17,1,1),
(8,null,12,12,1,0),
(15,14,12,1,2,1),
(9,null,12,1,2,0),
(13,null,12,22,2,1),
(6,8,12,21,2,1),
(13,11,12,22,2,0),
(7,6,12,12,2,1),
(12,null,12,15,2,1),
(12,null,12,1,3,0),
(6,10,12,21,3,0),
(15,null,12,12,3,1),
(9,10,12,21,3,0),
(14,11,12,1,3,0),
(8,6,12,21,3,1),
(13,null,12,1,3,0),
(7,10,12,12,4,0),
(12,11,12,21,4,0),
(9,8,12,5,4,1),
(15,14,12,10,4,1),
(7,null,12,10,4,0),
(13,11,12,23,4,1),
(8,6,12,22,4,1)
GO
--PROGRAMMING
DROP PROCEDURE IF EXISTS p_add_team
GO 
CREATE PROCEDURE p_add_team (
    @team_name VARCHAR (50),
    @team_city VARCHAR (50),
    @team_state CHAR (2)

) AS 
BEGIN
    INSERT INTO teams (team_name, team_city,team_state) VALUES (@team_name, @team_city, @team_state)
END
GO

DROP PROCEDURE IF EXISTS p_add_player
GO 
CREATE PROCEDURE p_add_player(
    @player_school_id char,
    @player_firstname varchar(50),
    @player_lastname varchar(50),
    @player_height int,
    @player_weight int,
    @player_position varchar(2),
    @player_gradeclass varchar(20),
    @player_team_id int

) AS 
BEGIN
    INSERT INTO players (player_firstname,player_lastname,player_school_id,player_height, player_weight, player_position,player_gradeclass,player_team_id) 
                VALUES (@player_firstname,@player_lastname,@player_school_id,@player_height, @player_weight, @player_position,@player_gradeclass,@player_team_id)
END
GO

DROP PROCEDURE IF EXISTS p_add_game
GO 
CREATE PROCEDURE p_add_game(
    @game_date date,
    @game_home_team_id int,
    @game_visiting_team_id int
) AS 
BEGIN
    INSERT INTO games (game_date,game_home_team_id,game_visiting_team_id) 
                VALUES (@game_date, @game_home_team_id, @game_visiting_team_id)
END
GO

DROP PROCEDURE IF EXISTS p_add_shot
GO 
CREATE PROCEDURE p_add_shot(
    @shot_by int,
    @shot_assisted_by int,
    @shot_game_id int, 
    @shot_distance decimal,
    @shot_quarter int,
    @shot_made tinyint
) AS 
BEGIN
    INSERT into shots (shot_by,  shot_assisted_by, shot_game_id, shot_distance, shot_quarter,shot_made)
                VALUES (@shot_by, @shot_assisted_by, @shot_game_id, @shot_distance, @shot_quarter, @shot_made)
END
GO

DROP PROCEDURE IF EXISTS p_transfer_player
GO 
CREATE PROCEDURE p_transfer_player(
    @player_id INT,
    @player_school_id int
) AS 
BEGIN
   UPDATE players SET player_school_id = @player_school_id WHERE player_id = @player_id
END
GO

DROP VIEW IF EXISTS v_player_stats 
GO

CREATE VIEW v_player_stats AS

WITH shot_stats AS (
    
    SELECT 
        shot_by,
        COUNT(*) shots_taken,
        sum(iif(shot_made = 1,1,0)) as shots_made,
        sum(iif(shot_made = 1 AND shot_distance > 19.75,1,0)) as three_pointers,
        sum(iif(shot_made = 1 AND shot_distance <= 19.75,1,0)) as two_pointers,
        sum(iif(shot_made = 0 AND shot_distance > 19.75,1,0)) as three_pointers_missed,
        sum(iif(shot_made = 0 AND shot_distance <= 19.75,1,0)) as two_pointers_missed
    FROM shots
    GROUP BY shot_by),

    assists AS (
        SELECT
            shot_assisted_by
            ,count(shot_assisted_by) AS assists
        FROM shots
        GROUP BY (shot_assisted_by)
    )

SELECT 
    player_id,
    player_firstname,
    player_lastname,
    player_position,
    iif(assists IS NULL, 0, assists) as assists,
    shots_taken,
    shots_made,
    three_pointers,
    two_pointers,
    (two_pointers*2) + (three_pointers*3) as total_points,
    three_pointers_missed,
    two_pointers_missed,
    iif(shots_taken > 0, CAST(CAST(shots_made AS FLOAT)/shots_taken as DECIMAL(3,2)),0) as shot_pct,
    iif(shots_made > 0, CAST(CAST(three_pointers AS FLOAT)/shots_made as DECIMAL(3,2)),0) as three_pointer_pct,
    iif(shots_made > 0, CAST(CAST(two_pointers AS FLOAT)/shots_made as DECIMAL(3,2)),0) as two_pointer_pct
FROM players
LEFT JOIN teams ON player_team_id = teams.team_id
LEFT JOIN shot_stats on shot_by = player_id
LEFT JOIN assists on shot_assisted_by = player_id

GO

DROP VIEW IF EXISTS v_team_wins
GO

CREATE VIEW v_team_wins AS

WITH points AS (
    
    select shot_game_id,
    team_id,
        sum(iif(shot_made = 1 AND shot_distance > 19.75,1,0))*3 as three_pointers,
        sum(iif(shot_made = 1 AND shot_distance <= 19.75,1,0))*2 as two_pointers,
    team_name
from shots
left join players on shot_by = player_id
left join teams on player_team_id = team_id
group by shot_game_id,team_id,team_name)

SELECT 
    games.game_date,
    games.game_id,
    points_home.team_name as 'home team',
    points_away.team_name as 'visiting team',
    sum(points_home.three_pointers + points_home.two_pointers) OVER (PARTITION by games.game_id) as home_points,
    sum(points_away.three_pointers + points_away.two_pointers) OVER (PARTITION by games.game_id) as away_points
FROM games
LEFT JOIN points points_home on points_home.team_id = games.game_home_team_id and points_home.shot_game_id = games.game_id
LEFT JOIN points points_away on points_away.team_id = games.game_visiting_team_id and points_away.shot_game_id = games.game_id
GO
drop view if exists v_player_rankings 
go
create view v_player_rankings as 
select * from v_player_stats
UNPIVOT (value for stat in (total_points,assists, shots_taken,
shots_made,
    three_pointers,
    two_pointers,
    three_pointers_missed,
    two_pointers_missed)) as up
GO
drop function if exists f_rankings 
go
create function f_rankings(
     @stat varchar(50)
) returns table as 
return 
select top 10 player_id, player_firstname + ' '+ player_lastname as player,stat,sum(value) as totals 
from v_player_rankings 
where stat=@stat
group by player_id,player_firstname + ' '+ player_lastname ,stat
order by totals desc
go
--Verify
/*select * from v_player_stats
select * from v_team_wins
select * from dbo.f_rankings('total_points')*/




