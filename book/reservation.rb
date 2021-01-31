require 'rubygems'
require 'dbi'

dbh = DBI.connect( 'DBI:SQLite3:event.db' )

dbh.do("drop table if exists reservations")
puts "テーブル'reservations'を削除"

dbh.do("create table reservations (
  id              int       primary key          not null,
  name           verchar(50)        not null,
  book_event_id   int,
  foreign key(book_event_id) references book_event(id));")
puts "テーブル'reservations'を作成"

dbh.disconnect
