require 'faraday'

class RollbarClient
  HOST = 'https://api.rollbar.com'

  class << self
    # Build new client with ENV['ROLLBAR_TOKEN']
    def build
      new(ENV['ROLLBAR_TOKEN'])
    end
  end

  def initialize(token)
    @token = token
    @connection = Faraday.new(url: HOST) do |conn|
      conn.request :url_encoded
      conn.response :json
      conn.response :raise_error
      conn.use RollbarApiErrorMiddleware
      conn.headers['X-Rollbar-Access-Token'] = token
    end
  end

  def get_items(query)
    @connection.get('/api/1/items', query).body['result']['items']
  end

  def get_occurrences_by_item_id(item_id)
    @connection.get("/api/1/item/#{item_id}/instances").body['result']['instances']
  end

  def delete_occurrence(occurrence_id)
    result = @connection.delete("/api/1/instance/#{occurrence_id}").body

    result['message']
  end

  def delete_all_occurrences_by_item_id(item_id)
    count = 0
    while (occurrences = get_occurrences_by_item_id(item_id)).any?
      occurrences.each { |occ| delete_occurrence(occ['id']) }
      count += occurrences.count
    end
    count
  end

  def get_item_id_by_counter(counter)
    response = @connection.get("/api/1/item_by_counter/#{counter}").body
    response['result']['itemId']
  end

  def get_item_details(item_id)
    response = @connection.get("/api/1/item/#{item_id}").body
    response['result']
  end

  class RollbarApiErrorMiddleware < Faraday::Middleware
    def on_request(env)
      # do something with the request
      # env[:request_headers].merge!(...)
    end

    def on_complete(env)
      response = env.response
      body = response.body

      return unless body.is_a?(Hash) && body['err'] == 1

      raise RollbarApiError, body['message'] || 'Unknown Rollbar API error'
    end
  end

  class RollbarApiError < StandardError; end
end
