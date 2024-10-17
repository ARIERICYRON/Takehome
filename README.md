git@github.com:ARIERICYRON/Takehome.git

# JSON Processing Challenge

This Ruby script processes JSON files containing users and companies, generating an output file with token top-ups for active users associated with companies. The goal of this challenge is to read user and company data, apply business logic for token management, and generate a structured output.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Error Handling](#error-handling)
- [Code Structure](#code-structure)
- [Functions](#functions)
- [Contributions](#contributions)

## Requirements

- Ruby 2.x or higher
- JSON files: `users.json`, `companies.json`

## Installation

1. **Clone the repository**:
   ```bash
   git clone git@github.com:ARIERICYRON/Takehome.git
   cd Takehome

## Usage
1. Run the script in the command line:
ruby challenge.rb
2. The script will read the input files, process the data, and create an output file named output.txt.
## Output
The output will be written to output.txt, formatted as follows:
Company Id: 1
Company Name: Example Corp
Users Emailed:
    Doe, John, john.doe@example.com
      Previous Token Balance: 5
      New Token Balance: 10
Users Not Emailed:
    Smith, Jane, jane.smith@example.com
      Previous Token Balance: 3
      New Token Balance: 8
Total amount of top-ups for Example Corp: 5
## Error Handling
The script includes robust error handling for various scenarios, including:

File Not Found: If users.json or companies.json is missing, an error message will be displayed.
Invalid JSON Format: If the JSON files are malformed, the script will alert you to the issue.
Incorrect Data Structures: The script checks if the parsed JSON data is in the expected format (arrays of hashes).

## Code Structure
The code is organized into several methods to improve readability and reusability:

read_json: Reads and parses a JSON file, returning an array of hashes.
process_users: Processes user data to apply top-ups and categorize users based on email status.
write_output: Writes the processed results to an output text file.

## Error Handling Details
Each method contains specific error handling to manage potential issues gracefully, providing informative messages without crashing the program.
The main execution method validates the data structure of input files before processing.

## Functions
read_json(file_name)
Description: Reads and parses a JSON file.
Parameters:
file_name: The name of the JSON file to read.
Returns: An array of hashes representing the parsed JSON data.
process_users(users, companies)
Description: Processes the users and companies data to determine token top-ups and categorizes users based on email status.
Parameters:
users: An array of user data.
companies: An array of company data.
Returns: An array of hashes containing processed results.
write_output(results, file_name)
Description: Writes the processed results to a text file.
Parameters:
results: The processed results to write.
file_name: The name of the output file.

## Contributions
Contributions are welcome! Feel free to submit issues or pull requests. When contributing, please ensure your code follows the Ruby style guidelines and includes appropriate test cases if applicable.
