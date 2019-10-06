require 'sqlite3'

class Database
  attr_reader :db

  # create db if not exist
  def initialize
    @db = SQLite3::Database.open('./data/data.db')
    @db.execute('CREATE TABLE IF NOT EXISTS posts(slug TEXT)')
    @db.execute('CREATE TABLE IF NOT EXISTS post_comments(slug TEXT)')
    @db.execute('CREATE TABLE IF NOT EXISTS topic_comments(slug TEXT)')
  end

  # check exist record in db
  def in_db?(type, slug)
    @db.execute("SELECT * FROM #{type} WHERE slug = '#{slug}'").any?
  end

  # write record in db
  def write_to_db(type, params = {})
    @db.execute("INSERT INTO #{type} (#{params.keys.join(', ')})" \
                "VALUES (#{('?, ' * params.size)[0...-2]})", params.values.to_a)
  end

  # close db
  def close
    @db.close
  end
end
