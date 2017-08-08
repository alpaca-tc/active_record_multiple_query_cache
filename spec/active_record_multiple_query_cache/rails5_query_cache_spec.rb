require 'rails_helper'

RSpec.describe ActiveRecordMultipleQueryCache::Rails5QueryCache do
  next if ActiveRecord.gem_version < Gem::Version.new('5.0.0')

  let(:instance) { described_class.new(active_record_base_class) }
  let(:active_record_base_class) { ActiveRecord::Base }

  describe '#run' do
    subject do
      -> { instance.run }
    end

    after do
      active_record_base_class.connection.disable_query_cache!
    end

    it { is_expected.to change(active_record_base_class.connection, :query_cache_enabled).from(false).to(true) }
  end

  describe '#complete' do
    subject do
      -> { instance.complete([caching_pool, caching_was_enabled]) }
    end

    before do
      active_record_base_class.connection.enable_query_cache!
    end

    after do
      active_record_base_class.connection.disable_query_cache!
    end

    let(:caching_pool) { active_record_base_class.connection_pool }
    let(:caching_was_enabled) { false }

    it 'disables query_cache' do
      is_expected.to change(active_record_base_class.connection, :query_cache_enabled).from(true).to(false)
    end
  end
end
