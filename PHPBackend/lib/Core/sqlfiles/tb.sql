
drop database if exists jgiapp_db;

create database if not exists jgiapp_db;
use jgiapp_db;


drop table if exists jgiapp_user_group;
create table if not exists jgiapp_user_group (

	id varchar(10) default 'x' NOT null,
    name varchar(100),
    last_updated datetime,
    primary key(id)
);

insert into jgiapp_user_group (id, name, last_updated)
values ('GOVOFF', 'Government Officials',now());

insert into jgiapp_user_group (id, name, last_updated)
values ('SCITI', 'Scientists',now());

insert into jgiapp_user_group (id, name, last_updated)
values ('GISUSR', 'GIS Users',now());


drop table if exists jgiapp_user;
create table if not exists jgiapp_user (

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
    FOREIGN KEY (group_id) REFERENCES jgiapp_user_group(id)

)ENGINE=INNODB;


alter table jgiapp_user add password varchar(64) after email;

alter table jgiapp_user modify password varchar(255);

create index phone_idx on jgiapp_user (phone_number);

create index email_idx on jgiapp_user (email);

alter table jgiapp_user change stat sign_in_stat enum('SI','SO');

alter table jgiapp_user add status enum('N','A','D') after seed ;



drop table if exists jgiapp_user_img;
create table if not exists jgiapp_user_img (

    id varchar(32) default 'x' NOT null,
    pid smallint(2) default 1 NOT null,
    ptype enum('P', 'I') default 'P' NOT null,
    url text,
    last_updated datetime,
    PRIMARY KEY (id,pid),
    FOREIGN KEY (id) REFERENCES jgiapp_user(id)

)ENGINE=INNODB;



drop table if exists jgiapp_message;
create table if not exists jgiapp_message (

    id varchar(32) default 'x' NOT null,
    uid varchar(32) default 'x' NOT null,
    item_id varchar(32),
    title varchar(128),
    sub_title varchar(255),
    type enum('SM', 'RM','O'),
    last_updated datetime,
    primary key(id)
);


drop table if exists jgiapp_map;
create table if not exists jgiapp_map (

    id varchar(32) default 'x' NOT null,
    uid varchar(32) default 'x' NOT null,
    title varchar(200),
    description text, 
    status enum('N', 'F'),
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (uid) REFERENCES jgiapp_user(id)
);

drop table if exists jgiapp_map_version;
create table if not exists jgiapp_map_version (

    id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    status enum('N', 'F'),
    created_by varchar(32) default 'x' NOT null,
    last_updated datetime,
    primary key(id, version_no),
    FOREIGN KEY (id) REFERENCES jgiapp_map(id),
    FOREIGN KEY (created_by) REFERENCES jgiapp_user(id)
);

alter table jgiapp_map_version add latitude real after status;
alter table jgiapp_map_version add longitude real after latitude;
alter table jgiapp_map_version add level_of_detail smallint(2) after longitude;

alter table jgiapp_map_version add legend_title varchar(128) after longitude;

drop table if exists jgiapp_map_version_item;
create table if not exists jgiapp_map_version_item (

    id varchar(32) default 'x' NOT null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    item_type enum('P','L','PL', 'LB'),
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jgiapp_map_version(id, version_no)
);

alter table jgiapp_map_version_item add created_by varchar(32) after item_type;
alter table jgiapp_map_version_item add FOREIGN KEY (created_by) REFERENCES jgiapp_user(id);

alter table jgiapp_map_version_item modify item_type enum('P','L','PL','LB','F');

alter table jgiapp_map_version_item add color varchar(10) after item_type;


drop table if exists jgiapp_map_version_ipoint;
create table if not exists jgiapp_map_version_ipoint (

    item_id varchar(32) default 'x' NOT null,
    id int(5) default 1 NOT null, 
    x real,
    y real,
    last_updated datetime,
    primary key(item_id,id),
    FOREIGN KEY (item_id) REFERENCES jgiapp_map_version_item(id)
);

alter table jgiapp_map_version_ipoint add wkid int(6) after y;


drop table if exists jgiapp_map_version_note;
create table if not exists jgiapp_map_version_note (

    id varchar(32) default 'x' not null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    uid varchar(32) default 'x' NOT null, 
    title varchar(255),
    note text, 
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jgiapp_map_version(id, version_no),
    FOREIGN KEY (uid) REFERENCES jgiapp_user(id)

);

drop table if exists jgiapp_map_version_sign_log;

create table if not exists jgiapp_map_version_sign_log (

    id varchar(32) default 'x' NOT null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    template_id varchar(64),
    last_updated datetime,
    primary key(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jgiapp_map_version(id, version_no)
   
);

create index sign_log_idx on jgiapp_map_version_sign_log (map_id, version_no, template_id);


drop table if exists jgiapp_map_version_signer;

create table if not exists jgiapp_map_version_signer (

    log_id varchar(32) default 'x' NOT null,
    uid varchar(32) default 'x' not null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    signed enum('Y', 'N') default 'N' NOT null,
    date_signed datetime,
    last_updated datetime,
    primary key(log_id,uid,map_id, version_no),
    FOREIGN KEY (log_id) REFERENCES jgiapp_map_version_sign_log(id),
    FOREIGN KEY (map_id, version_no) REFERENCES jgiapp_map_version(id, version_no),
    FOREIGN KEY (uid) REFERENCES jgiapp_user(id)
);


drop table if exists jgiapp_map_legend_item;

create table if not exists jgiapp_map_legend_item (

    id smallint(2) default 1 NOT null,
    map_id varchar(32) default 'x' NOT null,
    version_no int(6) default 100 NOT null,
    text varchar(128),
    color varchar(10),
    last_updated datetime,
    primary key(id, map_id, version_no),
    FOREIGN KEY (map_id, version_no) REFERENCES jgiapp_map_version(id, version_no)

);