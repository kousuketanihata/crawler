create database mail_news;
create table mail_news.user(
    id int not null auto_increment primary key,
    name text,
    email text,
    create_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);
create table mail_news.content(
    id int not null auto_increment primary key,
    url text UNIQUE,
    title text,
    html text,
    content text,
    create_at TIMESTAMP,
    updated_at TIMESTAMP
);