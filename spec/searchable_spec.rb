# uncomment to enable debugging using pry https://github.com/pry/pry
# require 'pry'
require_relative 'utilities'
require_relative '../searchable'

RSpec.describe 'Searchable' do
  class SearchableClass
    include ::Searchable

    def obj_keys
      %w[name email]
    end
  end

  let(:objects) do
    [{ 'name' => 'John', 'email' => 'john@example.com' },
     { 'name' => 'John Again', 'email' => 'johnagain@example.com' }]
  end
  let(:output_string) do
    Utilities.simulate_input do
      SearchableClass.new.search(objects)
    end
  end

  let(:output_objects) do
    SearchableClass.new.search(objects)
  end

  describe '#search' do
    before do
      allow(STDIN).to receive(:gets).and_return("name=John\n")
    end

    context 'with objects to search' do
      it 'displays search instruction' do
        text = <<~TEXT
          You can search using the following format:
          Available keys are: name, email
          key=value&partial=true(default)|false
          Example full_name=john&email=john.doe@gmail.com&partial=false or full_name=john
        TEXT
        expect(output_string).to include(text)
      end

      it 'returns matched array of object' do
        allow(STDIN).to receive(:gets).and_return("name=Again\n")
        expect(output_objects).to eq([{ 'name' => 'John Again', 'email' => 'johnagain@example.com' }])
      end

      context 'with valid search string' do
        it 'returns partial results by default' do
          allow(STDIN).to receive(:gets).and_return("name=John\n")
          expect(output_objects).to eq(objects)
        end

        it 'returns exact result using partial=false' do
          allow(STDIN).to receive(:gets).and_return("name=John&partial=false\n")

          expect(output_objects).to eq([{ 'name' => 'John', 'email' => 'john@example.com' }])
        end
      end

      context 'with invalid search string' do
        it 'returns an empty array of object' do
          allow(STDIN).to receive(:gets).and_return("invalid_search\n")
          expect(output_objects).to eq([])
        end

        it 'returns an error message for invalid key' do
          allow(STDIN).to receive(:gets).and_return("first_name=John Doe\n")
          expect(output_string).to include('ERROR: Invalid search key found! Available keys are: name, email')
        end

        it 'returns an error message for invalid search query' do
          allow(STDIN).to receive(:gets).and_return("John Doe\n")
          expect(output_string).to include('ERROR: Invalid search query! Please provide a valid search query.')
        end
      end
    end

    context 'with no objects to search' do
      let(:objects) { [] }
      it 'returns an empty array of object' do
        expect(output_objects).to eq([])
      end

      it 'displays an error' do
        expect(output_string).to include('ERROR: No objects to search!')
      end
    end

    context 'with unimplemented obj_keys method' do
      class UnimplementedObjKeys
        include ::Searchable
      end

      let(:output_string) do
        Utilities.simulate_input do
          UnimplementedObjKeys.new.search(objects)
        end
      end

      it 'returns an error message' do
        expect(output_string).to include('ERROR: Please implement obj_keys method in your class!')
      end
    end
  end
end
