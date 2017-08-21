require 'rails_helper'

RSpec.describe 'QueryCache' do
  if ENV['QUERY_CACHE_ENABLED']
    context 'query cache is enabled' do
      describe 'when executing Item.first and Post.first', type: :request do
        subject do
          -> { get("/queries/#{times}/first") }
        end

        let(:times) { 20 }

        it { is_expected.to be_performed(2) }
        it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
      end

      describe 'when executing Item.all and Post.all', type: :request do
        subject do
          -> { get("/queries/#{times}/all") }
        end

        let(:times) { 20 }

        it { is_expected.to be_performed(2) }
        it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
      end
    end
  else
    context 'query cache is disabled' do
      describe 'when executing Item.first and Post.first', type: :request do
        subject do
          -> { get("/queries/#{times}/first") }
        end

        let(:times) { 20 }

        it { is_expected.to be_performed(40) }
        it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
      end

      describe 'when executing Item.all and Post.all', type: :request do
        subject do
          -> { get("/queries/#{times}/all") }
        end

        let(:times) { 20 }

        it { is_expected.to be_performed(40) }
        it { is_expected.to_not change(Item.connection, :query_cache_enabled).from(false) }
      end
    end
  end
end
