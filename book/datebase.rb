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

dbh.disconnect