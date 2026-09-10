# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe ONCCertificationG33TestKit::EmptyG33Group do
  let(:suite_id) { 'g33_certification' }
  let(:group) { suite.groups.first }

  describe 'Empty G33 Test' do
    let(:test) { group.tests.first }

    it 'passes' do
      result = run(test)
      expect(result.result).to eq('pass'), result.result_message
    end
  end
end
