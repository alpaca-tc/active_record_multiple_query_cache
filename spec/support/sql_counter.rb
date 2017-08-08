class SQLCounter
  class << self
    attr_accessor :ignored_sql, :log, :log_all
    def clear_log; self.log = []; self.log_all = []; end
  end

  clear_log

  self.ignored_sql = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/]

  sqlite3_ignored =    [/^\s*SELECT name\b.*\bFROM sqlite_master/im, /^\s*SELECT sql\b.*\bFROM sqlite_master/im]

  [sqlite3_ignored].each do |db_ignored_sql|
    ignored_sql.concat db_ignored_sql
  end

  attr_reader :ignore

  def initialize(ignore = Regexp.union(self.class.ignored_sql))
    @ignore = ignore
  end

  def call(name, start, finish, message_id, values)
    # in Rails5
    return if values[:cached]

    # in Rails4
    return if 'CACHE' == values[:name]

    sql = values[:sql]
    self.class.log_all << sql
    self.class.log << sql unless ignore.match?(sql)
  end
end

ActiveSupport::Notifications.subscribe("sql.active_record", SQLCounter.new)
