require 'json'

# Read JSON data from a file and return parsed content
# @param [String] file_name - The name of the JSON file to read
# @return [Array<Hash>] - Parsed JSON data as an array of hashes
def read_json(file_name)
  JSON.parse(File.read(file_name), symbolize_names: true)
rescue StandardError => e
  puts "Error reading #{file_name}: #{e.message}"
  []
end

# Process users by company, applying top-ups and sorting the data
# @param [Array<Hash>] users - The array of user data
# @param [Array<Hash>] companies - The array of company data
# @return [Array<Hash>] - Processed results containing companies and users
def process_users(users, companies)
  company_map = companies.each_with_object({}) { |company, hash| hash[company[:id]] = company }
  results = []

  company_map.each do |company_id, company|
    # Select active users belonging to the current company
    active_users = users.select { |user| user[:active_status] && user[:company_id] == company_id }
    next if active_users.empty?

    # Group users by email status
    users_emailed = []
    users_not_emailed = []
    total_top_up = 0

    active_users.each do |user|
      previous_tokens = user[:tokens] || 0
      top_up_amount = company[:top_up] || 0
      new_tokens = previous_tokens + top_up_amount
      total_top_up += top_up_amount

      user_info = {
        last_name: user[:last_name],
        first_name: user[:first_name],
        email: user[:email],
        previous_tokens: previous_tokens,
        new_tokens: new_tokens
      }

      if user[:email_status] && company[:email_status]
        users_emailed << user_info
      else
        users_not_emailed << user_info
      end
    end

    # Sort users alphabetically by last name
    users_emailed.sort_by! { |user| user[:last_name] }
    users_not_emailed.sort_by! { |user| user[:last_name] }

    results << {
      company_id: company_id,
      company_name: company[:name],
      users_emailed: users_emailed,
      users_not_emailed: users_not_emailed,
      total_top_up: total_top_up
    }
  end

  # Sort results by company ID
  results.sort_by { |result| result[:company_id] }
end

# Write the processed output to a text file
# @param [Array<Hash>] results - The processed results to write
# @param [String] file_name - The name of the output file
def write_output(results, file_name)
  File.open(file_name, 'w') do |file|
    results.each do |result|
      file.puts "Company Id: #{result[:company_id]}"
      file.puts "Company Name: #{result[:company_name]}"
      file.puts "Users Emailed:"

      result[:users_emailed].each do |user|
        file.puts "\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}"
        file.puts "\t  Previous Token Balance: #{user[:previous_tokens]}"
        file.puts "\t  New Token Balance: #{user[:new_tokens]}"
      end

      file.puts "Users Not Emailed:"

      result[:users_not_emailed].each do |user|
        file.puts "\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}"
        file.puts "\t  Previous Token Balance: #{user[:previous_tokens]}"
        file.puts "\t  New Token Balance: #{user[:new_tokens]}"
      end

      file.puts "Total amount of top-ups for #{result[:company_name]}: #{result[:total_top_up]}"
      file.puts
    end
  end
  puts "Output written to #{file_name}."
end

# Main program execution
def main
  users = read_json('users.json')
  companies = read_json('companies.json')

  # Check for valid data structures
  unless users.is_a?(Array) && companies.is_a?(Array)
    puts "Error: Invalid data structure in input files."
    exit
  end

  output = process_users(users, companies)
  write_output(output, 'output.txt')
end

main
