
drop database if exists jdiapp_db;

create database if not exists jdiapp_db;
use jdiapp_db;

grant all on jdiapp_db.* to 'jdi_dbusr'@'localhost' identified by '21hat53G377A#43!';

drop table if exists jdiapp_user_group;
create table if not exists jdiapp_user_group (

	id varchar(10) default 'x' NOT null,
    name varchar(100),
    last_updated datetime,
    primary key(id)
);

insert into jdiapp_user_group (id, name, last_updated)
values ('GOVOFF', 'Government Officials',now());

insert into jdiapp_user_group (id, name, last_updated)
values ('SCITI', 'Scientists',now());

insert into jdiapp_user_group (id, name, last_updated)
values ('GISUSR', 'GIS Users',now());


drop table if exists jdiapp_user;
create table if not exists jdiapp_user (

	id varchar(32) default 'x' NOT null,
	first_name VARCHAR(100) default 'x' NOT NULL,
    last_name VARCHAR(100) default 'x' NOT NULL,
    group_id varchar(10),
    dob datetime,
	email varchar(255),
	phone_number varchar(255),
    country_code varchar(5) default 'MY' NOT NULL,
	seed smallint(3),
	stat enum('SI', 'SO') default 'SO' NOT null,
	last_stat_time datetime,
    last_updated datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (group_id) REFERENCES jdiapp_user_group(id)

)ENGINE=INNODB;


alter table jdiapp_user add password varchar(64) after email;

alter table jdiapp_user modify password varchar(255);

create index phone_idx on jdiapp_user (phone_number);

create index email_idx on jdiapp_user (email);

alter table jdiapp_user change stat sign_in_stat enum('SI','SO');

alter table jdiapp_user add status enum('N','A','D') after seed ;



drop table if exists jdiapp_user_img;
create table if not exists jdiapp_user_img (

    id varchar(32) default 'x' NOT null,
    pid smallint(2) default 1 NOT null,
    ptype enum('P', 'I') default 'P' NOT null,
    url text,
    last_updated datetime,
    PRIMARY KEY (id,pid),
    FOREIGN KEY (id) REFERENCES jdiapp_user(id)

)ENGINE=INNODB;



drop table if exists jdiapp_message;
create table if not exists jdiapp_message (

    id varchar(32) default 'x' NOT null,
    uid varchar(32) default 'x' NOT null,
    item_id varchar(32),
    title varchar(128),
    sub_title varchar(255),
    type enum('SM', 'RM','O'),
    last_updated datetime,
    primary key(id)
);


drop table if exists jdiapp_map;
create table if not exists jdiapp_map (

    id varchar(32) default 'x' NOT null,
    uid varchar(32) default 'x' NOT null,
    title varchar(200),
    description text, 
    status enum('N', 'F'),
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (uid) REFERENCES jdiapp_user(id)
);

drop table if exists jdiapp_map_version;
create table if not exists jdiapp_map_version (

    id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    status enum('N', 'F'),
    created_by varchar(32) default 'x' NOT null,
    last_updated datetime,
    primary key(id, version_no),
    FOREIGN KEY (id) REFERENCES jdiapp_map(id),
    FOREIGN KEY (created_by) REFERENCES jdiapp_user(id)
);

alter table jdiapp_map_version add latitude real after status;
alter table jdiapp_map_version add longitude real after latitude;
alter table jdiapp_map_version add level_of_detail smallint(2) after longitude;

drop table if exists jdiapp_map_version_item;
create table if not exists jdiapp_map_version_item (

    id varchar(32) default 'x' NOT null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    item_type enum('P','L','PL', 'LB'),
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jdiapp_map_version(id, version_no)
);

alter table jdiapp_map_version_item add created_by varchar(32) after item_type;
alter table jdiapp_map_version_item add FOREIGN KEY (created_by) REFERENCES jdiapp_user(id);

alter table jdiapp_map_version_item modify item_type enum('P','L','PL','LB','F');

alter table jdiapp_map_version_item add color varchar(10) after item_type;


drop table if exists jdiapp_map_version_ipoint;
create table if not exists jdiapp_map_version_ipoint (

    item_id varchar(32) default 'x' NOT null,
    id int(5) default 1 NOT null, 
    latitude real,
    longitude real,
    last_updated datetime,
    primary key(item_id,id),
    FOREIGN KEY (item_id) REFERENCES jdiapp_map_version_item(id)
);


drop table if exists jdiapp_map_version_note;
create table if not exists jdiapp_map_version_note (

    id varchar(32) default 'x' not null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    uid varchar(32) default 'x' NOT null, 
    title varchar(255),
    note text, 
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jdiapp_map_version(id, version_no),
    FOREIGN KEY (uid) REFERENCES jdiapp_user(id)

);
