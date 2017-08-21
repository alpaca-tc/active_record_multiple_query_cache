class SQLCounter
  class << self
    attr_accessor :ignored_sql, :log, :log_all
    def clear_log; self.log = []; self.log_all = []; end
  end

  clear_log

  self.ignored_sql = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/]

  # FIXME: this needs to be refactored so specific database can add their own
  # ignored SQL, or better yet, use a different notification for the queries
  # instead examining the SQL content.
  oracle_ignored     = [/^select .*nextval/i, /^SAVEPOINT/, /^ROLLBACK TO/, /^\s*select .* from all_triggers/im, /^\s*select .* from all_constraints/im, /^\s*select .* from all_tab_cols/im]
  mysql_ignored      = [/^SHOW FULL TABLES/i, /^SHOW FULL FIELDS/, /^SHOW CREATE TABLE /i, /^SHOW VARIABLES /, /^\s*SELECT (?:column_name|table_name)\b.*\bFROM information_schema\.(?:key_column_usage|tables)\b/im]
  postgresql_ignored = [/^\s*select\b.*\bfrom\b.*pg_namespace\b/im, /^\s*select tablename\b.*from pg_tables\b/im, /^\s*select\b.*\battname\b.*\bfrom\b.*\bpg_attribute\b/im, /^SHOW search_path/i]
  sqlite3_ignored =    [/^\s*SELECT name\b.*\bFROM sqlite_master/im, /^\s*SELECT sql\b.*\bFROM sqlite_master/im]

  [oracle_ignored, mysql_ignored, postgresql_ignored, sqlite3_ignored].each do |db_ignored_sql|
    ignored_sql.concat db_ignored_sql
  end

  attr_reader :ignore

  def initialize(ignore = Regexp.union(self.class.ignored_sql))
    @ignore = ignore
  end

  def call(name, start, finish, message_id, values)
    return if values[:cached]

    sql = values[:sql]
    self.class.log_all << sql
    self.class.log << sql unless ignore.match?(sql)
  end
end

ActiveSupport::Notifications.subscribe("sql.active_record", SQLCounter.new)
