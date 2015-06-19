CREATE DATABASE guestbook;
CREATE TABLE book
(
name text,
email varchar(254),
comment text,
time text,
addr inet,
ts timestamp with time zone
);