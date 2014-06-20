require_relative 'data_loader'
require_relative 'split_tester'

loader = DataLoader.new :json
data = loader.read("source_data.json")
tester = SplitTester.new(data)

tester.tests.each do |test|
  puts "Cohort:\t#{test.cohort}"
  puts "Sample Size:\t#{test.sample_size}"
  puts "Conversions:\t#{test.conversions}"
  puts "95%% confident of %.2f%% conversion rate +/- %.2f%% (range: [%.2f%%, %.2f%%])"\
    % [test.conversion_rate * 100, test.confidence_interval * 100,
       test.conversion_range.begin * 100, test.conversion_range.end * 100]
  puts ""
end

puts "%.2f%% confident that above results are significant"\
  % (tester.calculate_chi_confidence * 100)

