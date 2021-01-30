# イベントの登録画面の作成
# 手順
# イベントタイトル、イベントの内容、イベントの場所、日時(datetime)を入力
# 上記をdbに保存
# 一覧画面で表示をする

# sqlite3は日付を文字列として格納している

require 'rubygems'
require 'dbi'
require 'date'

class BookEvent
  def initialize( title, content, place, event_date )
    @title = title
    @content = content
    @place = place
    @event_date = event_date
  end

  attr_accessor :title, :content, :place, :event_date

  def to_s
    "#{@title}, #{@content}, #{@place}, #{@event_date}"
  end

  def toFormattedString( sep = "\n" )
    "書籍名: #{@title}#{sep}著者名: #{@content}#{sep}場所: #{@place}#{sep}
    日時: #{@event_date}#{sep}"
  end
end

# どのdb呼び出すか操作
class BookEventManager
  def initialize(sqlile_name)
    @db_name = sqlile_name
    @dbh = DBI.connect( "DBI:SQLite3:#{@db_name}" )
  end

  def initBookEvents
    puts "\n0. 蔵書データベースの初期化"
    print "初期化しますか？（Y/yなら削除を実行します）："
    yesno = gets.chomp.upcase
    if /^Y$/ =~ yesno
      @dbh.do("drop table if exists book_events")
    end
    @dbh.do("create table book_events (
      id              int                 not null,
      title           verchar(100)        not null,
      content         text                not null,
      place           varchar(100)        not null,
      event_date      datetime            not null,
      primary         key(id));")
    puts "データベースを初期化しました。"
  end

def addBookEvent
  puts "\n1. イベントデータの登録"
  print "イベントデータを登録します。"

  book_event = BookEvent.new( "", "", 0, Date.new )
  print "\n"
  print "キー："
  key = gets.chomp
  print "イベント名："
  book_event.title = gets.chomp
  print "内容："
  book_event.content = gets.chomp
  print "場所："
  book_event.place = gets.chomp
  print "日時(年)："
  year = gets.chomp.to_i
  print "日時(月)："
  month = gets.chomp.to_i
  print "日時(日)："
  day = gets.chomp.to_i
  book_event.event_date = Date.new( year, month, day )

  @dbh.do("insert into book_events values (
          '#{key}',
          '#{book_event.title}',
          '#{book_event.content}',
          '#{book_event.place}',
          '#{book_event.event_date}'
          );")
          puts "\n登録しました。"
end

def listAllBookEvents
  item_name = {'id' => "キー", 'title' => "イベント名", 'content' => "内容",
    'place' => "場所", 'event_date' => "日時"}
  
  puts "\n2. イベントデータの表示"
  print "イベントデータを表示します。"

  puts "\n------------------------------"

  sth = @dbh.execute("select * from book_events")

  counts = 0
  sth.each do |row|
    row.each_with_name do |val, name|
      puts "#{item_name[name]}: #{val.to_s}"
    end
    puts "---------------------------------"
    counts = counts + 1
  end

  sth.finish

  puts "\n#{counts}件表示しました。"
end

  def run
   while true
      print "
      0. イベントデータベースの初期化
      1. イベントデータの登録
      2. イベントデータの表示
      9. 終了
      番号を選んでください(0,1,2,9):"

      num = gets.chomp
      case
      when '0' == num
        initBookEvents
      when '1' == num
        addBookEvent
      when '2' == num
        listAllBookEvents
      when '9' == num
        @dbh.disconnect
        puts "\n終了しました。"
        break;
      else
      end
    end
  end

end
# アプリケーション操作

book_info_manager = BookEventManager.new("book_event_sqlite.db")
book_info_manager.run