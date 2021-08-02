create database if not exists jdiapp_db;
use jdiapp_db;

grant all on jdiapp_db.* to 'jdi_dbusr'@'localhost' identified by '21hat53G377A#43!';

drop table if exists jdiapp_user;
create table if not exists jdiapp_user (

	id varchar(32) default 'x' NOT null,
	first_name VARCHAR(100) default 'x' NOT NULL,
    last_name VARCHAR(100) default 'x' NOT NULL,
    account_type enum('B', 'P','O') default 'P' NOT NULL,
    dob datetime,
	email varchar(255),
	phone_number varchar(255),
    country_code varchar(5) default 'MY' NOT NULL,
	seed smallint(3),
	stat enum('SI', 'SO') default 'SO' NOT null,
	last_stat_time datetime,
    PRIMARY KEY (id)

)ENGINE=INNODB;

create index phone_idx on jdiapp_user (phone_number);

create index email_idx on jdiapp_user (email);

alter table jdiapp_user add last_updated datetime;

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
