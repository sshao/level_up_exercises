require 'spec_helper.rb'

describe Test do
  let(:empty_data) { [] }
  let(:a_data) { [{date: "2014-03-21", cohort: "A", result: 1},
                  {date: "2014-03-21", cohort: "A", result: 1},
                  {date: "2014-03-20", cohort: "A", result: 0},
                  {date: "2014-03-20", cohort: "A", result: 1}] }
  let(:b_data) { [{date: "2014-03-20", cohort: "B", result: 0},
                  {date: "2014-03-20", cohort: "B", result: 1},
                  {date: "2014-03-21", cohort: "B", result: 0}] }
  let(:empty_test) { Test.new(empty_data, nil) }
  let(:test_a) { Test.new(a_data, "A") }
  let(:test_b) { Test.new(b_data, "B") }

  describe "#new" do
    it "raises an error when dataset is empty" do
      expect{ Test.new(empty_data, nil) }.to raise_error(ZeroDataError)
    end

    it "returns the correct cohort" do
      expect(test_a.cohort).to eq "A"
      expect(test_b.cohort).to eq "B"
    end

    it "returns the correct sample size" do
      expect(test_a.sample_size).to eq 4
      expect(test_b.sample_size).to eq 3
    end

    it "returns the correct number of conversions" do
      expect(test_a.conversions).to eq 3
      expect(test_b.conversions).to eq 1
    end

    it "returns the correct number of nonconversions" do
      expect(test_a.nonconversions).to eq 1
      expect(test_b.nonconversions).to eq 2
    end
  end

  describe "#conversion_rate" do
    it "returns the correct conversion rate" do
      expect(test_a.conversion_rate).to be_within(FLOAT_DELTA).of(0.75)
      expect(test_b.conversion_rate).to be_within(FLOAT_DELTA).of(0.33333)
    end
  end

  describe "#standard_error" do
    it "returns the correct standard error" do
      expect(test_a.standard_error).to be_within(FLOAT_DELTA).of(0.216506351)
      expect(test_b.standard_error).to be_within(FLOAT_DELTA).of(0.272165527)
    end
  end

  describe "#confidence_interval" do
    it "returns the correct confidence interval" do
      expect(test_a.confidence_interval).to be_within(FLOAT_DELTA).of(0.424352448)
      expect(test_b.confidence_interval).to be_within(FLOAT_DELTA).of(0.533444433)
    end
  end

  describe "#conversion_range" do
    it "returns the correct conversion range" do
      range_a = (0.325647552..1.0)
      range_b = (0.0..0.866777766)

      expect(test_a.conversion_range.begin).to be_within(FLOAT_DELTA).of(range_a.begin)
      expect(test_a.conversion_range.end).to be_within(FLOAT_DELTA).of(range_a.end)

      expect(test_b.conversion_range.begin).to be_within(FLOAT_DELTA).of(range_b.begin)
      expect(test_b.conversion_range.end).to be_within(FLOAT_DELTA).of(range_b.end)
    end
  end
end
