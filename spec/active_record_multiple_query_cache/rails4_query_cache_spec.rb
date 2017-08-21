require 'spec_helper'

RSpec.describe ActiveRecordMultipleQueryCache::Rails4QueryCache do
  next if ActiveRecord.gem_version >= Gem::Version.new('5.0.0')

  let(:instance) { described_class.new(active_record_base_class).new(app) }

  let(:app) do
    -> (_) { [200, {}, [active_record_base_class.connection.query_cache_enabled]] }
  end

  let(:active_record_base_class) { ActiveRecord::Base }

  describe '#call' do
    subject do
      _, _, body = instance.call({})
      body.map(&:to_s).join
    end

    before do
      active_record_base_class.connection.disable_query_cache!
    end

    context 'when app is fine' do
      it { is_expected.to eq('true') }
    end

    context 'when app raises error' do
      let(:app) do
        -> (_) { raise('error') }
      end

      it 'restores state of query_cache' do
        expect { subject }.to raise_error(StandardError)
        expect(active_record_base_class.connection.query_cache_enabled).to be false
      end
    end
  end
end
