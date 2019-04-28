RSpec.describe ShVars do
  subject { |e| described_class.parse(vars) }

  File.read('spec/fixtures/vars.txt').split("\n").each do |line|
    describe line do
      let(:vars) { line }
      it { expect { subject }.to_not raise_error }
    end
  end
end
