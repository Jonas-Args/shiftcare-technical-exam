# uncomment to enable debugging using pry https://github.com/pry/pry
# require 'pry'
require_relative 'utilities'
require_relative '../object_loader'

RSpec.describe ObjectLoader do
  let(:output_string) do
    Utilities.simulate_input do
      ObjectLoader.new.run
    end
  end

  describe '#run' do
    it 'breaks the loop when the user types "q"' do
      allow(STDIN).to receive(:gets).and_return("Q\n")

      text = <<~TEXT
        \n--- Data Loader ---
        1. Search data
        2. Show duplicates by email
        3. List data
        Q. Quit
        Enter your choice: You typed: q

        Goodbye!
      TEXT
      expect(output_string).to eq(text)
    end

    context 'when the user types "1"' do
      it 'returns search result' do
        allow(STDIN).to receive(:gets).and_return("1\n", 'full_name=John Doe', "Q\n")

        text = <<~TEXT
          Search results:
          {"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}
        TEXT
        expect(output_string).to include(text)
      end
    end

    context 'when the user types "2"' do
      it 'displays an object with duplicate emails' do
        allow(STDIN).to receive(:gets).and_return("2\n", "Q\n")
        text = <<~TEXT
          Listing duplicates by email...
          {"id"=>2, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"}
          {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}
        TEXT

        expect(output_string).to include(text)
      end
    end

    context 'when the user types "3"' do
      it 'displays a list of loaded objects' do
        allow(STDIN).to receive(:gets).and_return("3\n", "Q\n")
        text = <<~TEXT
          Listing data...
          {"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}
          {"id"=>2, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"}
          {"id"=>3, "full_name"=>"Alex Johnson", "email"=>"alex.johnson@hotmail.com"}
          {"id"=>4, "full_name"=>"Michael Williams", "email"=>"michael.williams@outlook.com"}
          {"id"=>5, "full_name"=>"Emily Brown", "email"=>"emily.brown@aol.com"}
          {"id"=>6, "full_name"=>"William Davis", "email"=>"william.davis@icloud.com"}
          {"id"=>7, "full_name"=>"Olivia Miller", "email"=>"olivia.miller@protonmail.com"}
          {"id"=>8, "full_name"=>"James Wilson", "email"=>"james.wilson@yandex.com"}
          {"id"=>9, "full_name"=>"Ava Taylor", "email"=>"ava.taylor@mail.com"}
          {"id"=>10, "full_name"=>"Michael Brown", "email"=>"michael.brown@inbox.com"}
          {"id"=>11, "full_name"=>"Sophia Garcia", "email"=>"sophia.garcia@zoho.com"}
          {"id"=>12, "full_name"=>"Emma Lopez", "email"=>"emma.lopez@protonmail.ch"}
          {"id"=>13, "full_name"=>"Liam Martinez", "email"=>"liam.martinez@fastmail.fm"}
          {"id"=>14, "full_name"=>"Isabella Rodriguez", "email"=>"isabella.rodriguez@me.com"}
          {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}
        TEXT
        expect(output_string).to include(text)
      end
    end

    context 'when the user types invalid option' do
      it 'returns an error message' do
        allow(STDIN).to receive(:gets).and_return("invalid_option\n", "Q\n")
        expect(output_string).to include('ERROR: Invalid option. Please try again.')
      end
    end
  end

  describe 'private method load_from_file' do
    let(:output_string) do
      Utilities.simulate_input do
        ObjectLoader.new.send(:load_from_file)
      end
    end

    let(:objects) do
      object_loader = ObjectLoader.new
      object_loader.send(:load_from_file)
      object_loader.objects
    end

    context 'with a valid file path relative to object_loader.rb' do
      before do
        allow(STDIN).to receive(:gets).and_return('spec/test_clients.json')
      end

      it 'loads object from the json file' do
        expect(objects).to eq([{ 'email' => 'test@example.com', 'full_name' => 'Test client', 'id' => 1 }])
      end

      it 'displays a success message' do
        expect(output_string).to include('Data loaded successfully!')
      end
    end

    context 'with invalid file path' do
      before do
        allow(STDIN).to receive(:gets).and_return('invalid_file_path')
      end

      it 'returns an error message' do
        expect(output_string).to include('ERROR: No such file or directory @ rb_sysopen - invalid_file_path')
      end

      it 'does not change already loaded objects' do
        expect(objects).to eq(JSON.parse(File.read('clients.json')))
      end
    end
  end
end
