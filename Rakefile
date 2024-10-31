require 'net/http'
require 'json'
require './rollbar_client'

namespace :rollbar do
  desc 'Delete occurrences for searched items'
  task :delete_items, [:user_id] do
    token = ENV['ROLLBAR_TOKEN']
    user_id = :user_id
    client = RollbarClient.new(token)
    items = client.get_items({ environment: 'development', framework: 'browser-js', assigned_user: user_id })
    items.each do |item|
      next unless item['assigned_user_id'] == user_id

      puts "Delete item? #{item['id']}: #{item['title']} (user: #{item['assigned_user_id']})"
      occurrences = client.get_occurrences_by_item_id item['id']
      occurrences.each do |occurrence|
        client.delete_occurrence occurrence['id']
      end
    end
  end
end
