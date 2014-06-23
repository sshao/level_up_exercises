require 'spec_helper'

describe DataLoader do
  describe "#new" do
    it "returns the correct format" do
      loader = DataLoader.new :json
      expect(loader.format).to eq :json
    end
    
    it "raises an error if format is not an accepted format" do
      expect { DataLoader.new :txt }.to raise_error(InvalidFormatError, /Cannot read .txt. Accepted formats are/)
    end
  end

  describe "#read" do
    let(:data) { DataLoader.new(:json).read("spec/fixtures/test_data.json") }

    it "reads all data in file" do
      expect(data.size).to eql 7
    end

    it "reads correct data" do
      first_hash = {date: "2014-03-20", cohort: "B", result: 0}
      last_hash = {date: "2014-03-20", cohort: "A", result: 1}

      expect(data).to include first_hash
      expect(data).to include last_hash
    end
  end
end
