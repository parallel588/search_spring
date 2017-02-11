require 'spec_helper'

RSpec.describe SearchSpring::Client do
  let(:feed_id) { '1234' }
  let(:client) { SearchSpring::Client.new('test_site_id', 'test_site_key') }

  describe '#initialize' do
    context 'when site_id is empty' do
      it 'should raise exception' do
        expect { SearchSpring::Client.new(nil, '') }
          .to raise_error(SearchSpring::Errors::AuthenticationError,
                          'No Site ID provided.')
      end
    end

    context 'when secret_key is empty' do
      it 'should raise exception' do
        expect { SearchSpring::Client.new('test', nil) }
          .to raise_error(SearchSpring::Errors::AuthenticationError,
                          'No Secret Key provided.')
      end
    end
  end

  it '#upsert' do
    expect(client.conn)
      .to receive(:post).with('api/index/upsert.json',
                              feedId: '1234',
                              records: [{ id: 1, title: 'test prod' }])
    client.upsert(feed_id: feed_id, products: [{ id: 1, title: 'test prod' }])
  end

  it '#update' do
    expect(client.conn)
      .to receive(:post).with('api/index/update.json',
                              feedId: '1234',
                              records: [{ id: 1, title: 'test prod' }])
    client.update(feed_id: feed_id, products: [{ id: 1, title: 'test prod' }])
  end

  it '#delete' do
    expect(client.conn)
      .to receive(:post).with('api/index/delete.json',
                              feedId: '1234', records: [1])
    client.delete(feed_id: feed_id, product_ids: [1])
  end
end
