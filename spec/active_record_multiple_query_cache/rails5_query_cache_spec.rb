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

    let(:caching_pool) { active_record_base_class.connection_pool }
    let(:caching_was_enabled) { false }

    it 'disables query_cache' do
      is_expected.to change(active_record_base_class.connection, :query_cache_enabled).from(true).to(false)
    end
  end

  def enable_query_cache
    ActiveRecordMultipleQueryCache.install_query_cache(Item)
    ActiveRecordMultipleQueryCache.install_query_cache(Post)
  end

  describe 'when executing Item.first and Post.first', type: :request do
    subject do
      -> { get("/queries/#{times}/first") }
    end

    let(:times) { 20 }

    context 'query_cache is disabled' do
      it { is_expected.to be_performed(40) }
      it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
    end

    context 'query_cache is enabled' do
      before do
        enable_query_cache
      end

      it { is_expected.to be_performed(2) }
      it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
    end
  end

  describe 'when executing Item.all and Post.all', type: :request do
    subject do
      -> { get("/queries/#{times}/all") }
    end

    let(:times) { 20 }

    context 'query_cache is disabled' do
      it { is_expected.to be_performed(40) }
      it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
    end

    context 'query_cache is enabled' do
      before do
        enable_query_cache
      end

      it { is_expected.to be_performed(2) }
      it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
    end
  end
end
