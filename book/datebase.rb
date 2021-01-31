require 'rubygems'
require 'dbi'

dbh = DBI.connect( 'DBI:SQLite3:event.db' )

dbh.do("drop table if exists book_events")
puts "テーブル'book_events'を削除"

dbh.do("create table book_events (
  id              int                 not null,
  title           verchar(100)        not null,
  content         text                not null,
  place           varchar(100)        not null,
  event_date      datetime            not null,
  primary         key(id));")
puts "テーブル'book_events'を作成"

# dbh.do("drop table if exists reservations")
# puts "テーブル'reservations'を削除"

# dbh.do("create table reservations (
#   id              int       primary key          not null,
#   name           verchar(50)        not null,
#   book_event_id   int,
#   foreign key(book_event_id) references book_event(id));")
# puts "テーブル'reservations'を作成"

dbh.disconnect