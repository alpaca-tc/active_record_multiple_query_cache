# Clear new callback after every spec
RSpec.configure do |config|
  next unless Rails.gem_version >= Gem::Version.new('5.0.0')

  config.before do
    @_new_callbacks = []

    allow(ActiveSupport::Executor).to receive(:set_callback).and_wrap_original do |original_method, *args|
      @_new_callbacks.push(args)
      original_method.call(*args)
    end
  end

  config.after do
    @_new_callbacks.each do |args|
      ActiveSupport::Executor.skip_callback(*args)
    end
  end
end
