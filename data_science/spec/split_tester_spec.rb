require 'spec_helper.rb'

describe SplitTester do
  let(:data) { [{date: "2014-03-21", cohort: "A", result: 1},
                {date: "2014-03-21", cohort: "A", result: 1},
                {date: "2014-03-20", cohort: "A", result: 0},
                {date: "2014-03-20", cohort: "A", result: 1},
                {date: "2014-03-20", cohort: "B", result: 0},
                {date: "2014-03-20", cohort: "B", result: 1},
                {date: "2014-03-21", cohort: "B", result: 0}] }
  let(:tester) { SplitTester.new(data) }
  
  describe "#new" do
    it "fails when input includes too many tests" do
      data = [{cohort: "A"}, {cohort: "B"}, {cohort: "C"}]
      expect { SplitTester.new data }.to raise_error(WrongNumberOfTestsError, /Wrong number of tests \(3\)/)
    end

    it "fails when input includes too few tests" do
      data = [{cohort: "A"}]
      expect { SplitTester.new data }.to raise_error(WrongNumberOfTestsError, /Wrong number of tests \(1\)/)
    end

    it "identifies correct number of tests" do
      expect(tester.tests.size).to eq 2
    end
  end

  describe "#chi_square" do
    it "returns correct chi**2 value" do
      expect(tester.chi_square).to be_within(FLOAT_DELTA).of(1.21527778)
    end
  end

  describe "#chi_confidence_level" do
    it "returns correct chi confidence level" do
      expect(tester.chi_confidence).to be_within(FLOAT_DELTA).of(0.72970908)
    end
  end
end
