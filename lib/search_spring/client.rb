require_relative 'errors'
module SearchSpring
  API_ENDPOINT = 'https://api.searchspring.net'.freeze

  #
  #
  class Client
    attr_reader :site_id, :conn, :secret_key

    def initialize(site_id, secret_key, req_options = {})
      @site_id = site_id
      @secret_key = secret_key
      raise Errors::AuthenticationError, 'No Site ID provided.' unless @site_id
      unless @secret_key
        raise Errors::AuthenticationError, 'No Secret Key provided.'
      end

      @conn = connection(req_options)
    end

    def upsert(feed_id:, products: [])
      conn.post(
        'api/index/upsert.json',
        feedId: feed_id,
        records: products
      )
    end

    def update(feed_id:, products: [])
      conn.post(
        'api/index/update.json',
        feedId: feed_id,
        records: products
      )
    end

    def delete(feed_id:, product_ids: [])
      conn.post(
        'api/index/delete.json',
        feedId: feed_id,
        records: product_ids
      )
    end

    private

    def connection(options = {})
      Faraday.new(default_req_options.merge(options)) do |f|
        f.headers['Accept'] = 'application/json'
        f.request  :json
        f.request  :basic_auth, site_id, secret_key
        f.response :logger
        f.adapter :excon
        f.use Errors::RequestError
      end
    end

    def default_req_options
      {
        url: API_ENDPOINT,
        ssl: {
          ca_path: SearchSpring::DEFAULT_CA_BUNDLE_PATH,
          ca_file: File.join(
            SearchSpring::DEFAULT_CA_BUNDLE_PATH, 'ca-certificates.crt'
          )
        }
      }
    end
  end
end
