# Shiftcare Technical Exam
This is a minimalist command-line application using Ruby. 
This application allows user to load clients.json file and be able to perform two commands:

1. Search through all clients and return those with names partially matching a given
search query
2. Find out if there are any clients with the same email in the dataset, and show those
duplicates if any are found.

## Prerequisites
- Ensure you have Ruby installed in your terminal. You can check by running:
  ```sh
  ruby -v
  ```
  If Ruby is not installed, download it from [ruby-lang.org](https://www.ruby-lang.org/) or use a package manager like `rbenv` or `rvm`.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Jonas-Args/shiftcare-technical-exam.git
   ```
2. Navigate to the project directory:
   ```sh
   cd shiftcare-technical-exam
   ```

## Running the Application
To start the application, run:
```sh
ruby object_loader.rb
```

## Usage
- Follow the prompts in the terminal to interact with the application.
- Enter the required input as instructed.
## Features
- Available options include
  1. 1 Search objects
     - Allows user to search objects using ```key=value```
     - Search query can be a combinition of multiple keys ```key1=value1&key2=value2```
     - Search results are partial by default and can be toggled using ```partial=false``` query
     - Search results are case insensitive
     - Sample search query ```full_name=john&email=john.doe@gmail.com&partial=false or full_name=john```
  2. 2 Show duplicates by email
  3. 3 List objects
  - Show list of objects to aid the user in validating the result of search and show duplicates functionality
  1. Q. Quit
     - Quit the application
## Testing
### Prerequisites
- This application relies on rspec gem for unit testing
- Ensure you have rspec installed. You can check by running:
  ```sh
  rspec -v
  ```
  If rspec is not installed, you can run ```gem install rspec``` to install the gem globally
- Read more from their github repository https://github.com/rspec/rspec-rails
### Running Tests
Execute the following command to run spec files.
```sh
rspec spec
```
## Debugging
### Prerequisites
- This application relies on pry gem for debugging
- Ensure you have pry installed. You can check by running:
  ```sh
  pry -v
  ```
  If pry is not installed, you can run ```gem install pry``` to install the gem globally
- Uncomment ```require 'pry'``` or add ```require 'pry'``` to any file that you wish to debug
- Read more from their github repository https://github.com/pry/pry


