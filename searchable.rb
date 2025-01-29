module Searchable

  class ValidError < StandardError; end

  def search(objects)
    raise ValidError, 'No data to search!' if objects.empty?

    puts 'You can search using the following format:'
    puts "Available keys are: #{obj_keys.join(', ')}"
    puts 'key=value&partial=true(default)|false'
    puts 'Example full_name=john&email=john.doe@gmail.com&partial=false or full_name=john'
    print 'Enter search query: '
    @search_string = $stdin.gets.chomp

    validate_search_string

    objects.select do |object|
      object_search_hash.all? do |key, value|
        partial_results? ? object[key].downcase.include?(value.downcase) : object[key].downcase == value.downcase
      end
    end
  rescue ValidError => e
    puts "ERROR: #{e.message}"
    []
  end

  private

  def partial_results?
    search_hash['partial'] != 'false'
  end

  def validate_search_string
    valid_keys = object_search_hash.keys.all? { |key| obj_keys.include?(key) }

    raise ValidError, "Invalid search key found! Available keys are: #{obj_keys.join(', ')}" unless valid_keys
  end

  def search_hash
    raise ValidError, 'Invalid search query! Please provide a valid search query.' if @search_string.empty?

    @search_string.split('&').map { |query| query.split('=') }.to_h
  rescue StandardError => _e
    raise ValidError, 'Invalid search query! Please provide a valid search query.'
  end

  def object_search_hash
    search_hash.except('partial')
  end

  def obj_keys
    raise ValidError, 'Please implement obj_keys method in your class!'
  end
end
