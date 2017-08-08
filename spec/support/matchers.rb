class BePerformed < RSpec::Matchers::BuiltIn::Be
  def initialize(expected)
    @expected = expected
  end

  def matches?(event_proc)
    SQLCounter.clear_log

    event_proc.call
    @actual_queries = SQLCounter.log_all
    @actual_size = @actual_queries.size
    @actual_size == expected
  end

  def failure_message
    "expected #{expected} queries but is now #{@actual_size} queries\n" + queries
  end

  def failure_message_when_negated
    "expected #{expected} queries not to have changed but is now #{@actual_size} queries\n" + queries
  end

  def queries
    (@actual_queries || []).join("\n")
  end

  def supports_block_expectations?
    true
  end
end

Module.new do
  def be_performed(*args)
    BePerformed.new(*args)
  end

  RSpec.configure do |config|
    config.include(self)
  end
end
