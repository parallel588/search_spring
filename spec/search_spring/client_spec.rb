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

  describe "actions" do
    before do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post(
          '/api/index/upsert.json',
          MultiJson.dump(feedId: '1234', records:[{ id: 1, title: 'test prod' }])
        ) { |env| [200, {}, 'ok'] }

        stub.post(
          '/api/index/update.json',
          MultiJson.dump(feedId: '1234', records: [{ id: 1, title: 'test prod' }])
        ) { |env| [200, {}, 'ok'] }

        stub.post(
          '/api/index/delete.json',
          MultiJson.dump(feedId: '1234', records: [1])
        ) { |env| [200, {}, 'ok'] }
      end
      test = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      allow(Faraday).to receive(:new).and_return(test)
    end

    it '#upsert' do
      res = client.upsert(
        feed_id: feed_id, products: [{ id: 1, title: 'test prod' }]
      )
      expect(res.body).to eq('ok')
    end

    it '#update' do
      res = client.update(
        feed_id: feed_id, products: [{ id: 1, title: 'test prod' }]
      )
      expect(res.body).to eq('ok')
    end

    it '#delete' do
      res = client.delete(feed_id: feed_id, product_ids: [1])
      expect(res.body).to eq('ok')
    end
  end
end
