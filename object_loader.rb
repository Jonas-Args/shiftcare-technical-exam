#!/usr/bin/env ruby

require_relative 'searchable'
require 'json'
# uncomment to enable debugging using pry https://github.com/pry/pry
# require 'pry'

class ObjectLoader
  include Searchable
  attr_reader :objects

  def initialize
    file = File.read('clients.json')
    @objects = JSON.parse(file)
  end

  def run
    loop do
      display_menu
      choice = $stdin.gets.chomp.downcase
      puts "You typed: #{choice}"
      select_choice(choice)
      break if choice == 'q'
    end
  end

  private

  def display_menu
    puts "\n--- Data Loader ---"
    puts '1. Search data'
    puts '2. Show duplicates by email'
    puts '3. List data'
    puts 'Q. Quit'
    print 'Enter your choice: '
  end

  def select_choice(choice)
    puts ''
    case choice
    when '1'
      results = search(@objects)
      puts 'Search results:'
      results.any? ? display_objects(results) : puts('No results found!')
    when '2'
      list_duplicates
    when '3'
      list_objects
    when 'q'
      puts 'Goodbye!'
    else
      puts 'ERROR: Invalid option. Please try again.'
    end
  end

  def load_from_file
    print 'Please enter the json file path to load: '
    filepath = $stdin.gets.chomp
    file = File.read(filepath)
    @objects = JSON.parse(file)
    puts 'Data loaded successfully!'
  rescue StandardError => e
    puts "ERROR: #{e.message}"
  end

  def list_duplicates
    return puts 'ERROR: No loaded data!' if @objects.empty?

    duplicates = @objects.group_by { |object| object['email'] }.select { |_k, v| v.size > 1 }
    puts 'Listing duplicates by email...'
    display_objects(duplicates.values.flatten)
  end

  def list_objects
    return puts 'ERROR: No loaded data!' if @objects.empty?

    puts 'Listing data...'
    display_objects(@objects)
  end

  def obj_keys
    @objects[0].keys
  end

  def display_objects(objects)
    objects.each do |object|
      puts object
    end
  end
end

if __FILE__ == $0
  app = ObjectLoader.new
  app.run
end
