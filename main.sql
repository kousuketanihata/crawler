create database mail;
create table mail.user(
    id int not null auto_increment primary key,
    name text,
    email text,
    create_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);
create table mail.mails(
    id int not null auto_increment primary key,
    url text,
    title text,
    content text,
    created_at DATETIME,
    updated_at DATETIME
);

