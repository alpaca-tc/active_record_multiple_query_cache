class BePerformed < RSpec::Matchers::BuiltIn::Be
  def initialize(expected)
    @expected = expected
  end

  def matches?(event_proc)
    SQLCounter.clear_log

    event_proc.call
    @actual_size = SQLCounter.log_all.size
    @actual_size == expected
  end

  def failure_message
    "expected #{expected} queries but is now #{@actual_size} queries"
  end

  def failure_message_when_negated
    "expected #{expected} queries not to have changed but is now #{@actual_size} queries"
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
