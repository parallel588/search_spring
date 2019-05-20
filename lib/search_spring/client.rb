require_relative 'errors'
module SearchSpring
  API_ENDPOINT = 'https://api.searchspring.net'.freeze

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
      conn.post do |req|
        req.url 'api/index/upsert.json'
        req.headers['Content-Type'] = 'application/json'
        req.body = MultiJson.dump(
          feedId: feed_id,
          records: products
        )
      end
    end

    def update(feed_id:, products: [])
      conn.post do |req|
        req.url 'api/index/update.json'
        req.headers['Content-Type'] = 'application/json'
        req.body = MultiJson.dump(
          feedId: feed_id,
          records: products
        )
      end
    end

    def delete(feed_id:, product_ids: [])
      conn.post do |req|
        req.url 'api/index/delete.json'
        req.headers['Content-Type'] = 'application/json'
        req.body = MultiJson.dump(
          feedId: feed_id,
          records: product_ids
        )
      end
    end

    private

    def connection(options = {})
      Faraday.new(default_req_options.merge(options)) do |f|
        f.request  :url_encoded
        f.headers['Accept'] = 'application/json'
        f.request  :basic_auth, site_id, secret_key
        f.response :logger
        f.use Errors::RequestError
        f.adapter :excon
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
