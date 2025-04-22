require 'net/http'
require 'json'
require './rollbar_client'

namespace :rollbar do
  desc 'Show item ID by counter (project item ID)'
  task :show_item, [:counter] do |_t, args|
    abort 'Please provide an item project_item_id' unless args[:counter]

    client = RollbarClient.build
    item_id = client.get_item_id_by_counter(args[:counter])
    abort "Item not found with project_item_id: #{args[:counter]}" unless item_id

    item_details = client.get_item_details(item_id)
    pp item_details
  end

  desc 'Delete item by counter (project item ID)'
  task :delete_item, [:counter] do |_t, args|
    abort 'Please provide a project_item_id' unless args[:counter]

    client = RollbarClient.build
    item_id = client.get_item_id_by_counter(args[:counter])
    abort "Item not found with project_item_id: #{args[:counter]}" unless item_id

    puts "Found item with ID: #{item_id}"
    deleted_count = client.delete_all_occurrences_by_item_id(item_id)

    puts "Deleted #{deleted_count} occurrences for item #{item_id}"
  end
end
