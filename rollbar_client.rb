class RollbarClient
    HOST = 'https://api.rollbar.com'

  def initialize(token)
    @token = token
  end

  def get_items query
    uri = URI.parse(HOST + '/api/1/items')
    params = {access_token: @token}.merge(query)
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    JSON.parse(response)['result']['items']
  end

  def get_occurrences_by_item_id(item_id)
    uri = URI.parse(HOST + "/api/1/item/#{item_id}/instances")
    params = {access_token: @token}
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    JSON.parse(response)['result']['instances']
  end

  def delete_occurrence(occurrence_id)
    uri = URI.parse(HOST+"/api/1/instance/#{occurrence_id}")
    params = {access_token: @token}
    uri.query = URI.encode_www_form(params)
    puts "DELETE #{uri.path}?#{uri.query}"
    result = JSON.parse(Net::HTTP.new(uri.host).delete("#{uri.path}?#{uri.query}").body)
    if result['err'] == 1
      raise result['message']
    end
  end

  def delete_all_occurrences_by_item_id(item_id)
    count = 0
    while occurrences = get_occurrences_by_item_id(item_id).presence
      occurrences.each {|occ| delete_occurrence(occ['id']) }
      count += occurrences.count
    end
    puts "#{count} occurrences have been deleted."
  end
end
