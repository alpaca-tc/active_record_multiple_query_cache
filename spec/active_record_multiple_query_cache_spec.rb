require 'rails_helper'

RSpec.describe ActiveRecordMultipleQueryCache do
  it 'has a version number' do
    expect(ActiveRecordMultipleQueryCache::VERSION).not_to be nil
  end

  # Do not insert callback or middleware in the test
  # skip '#install_query_cache' do
  #   subject { described_class.install_query_cache(Item) }
  #   it { expect { subject }.to_not raise_error }
  # end
end
