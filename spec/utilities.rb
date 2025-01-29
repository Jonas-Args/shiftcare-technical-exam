# Description: This file contains utility methods that are used in the RSpec tests.
class Utilities
  def self.simulate_input
    output = StringIO.new
    $stdout = output
    yield
    $stdout = STDOUT
    output.string
  end
end
