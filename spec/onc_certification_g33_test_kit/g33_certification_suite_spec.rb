RSpec.describe ONCCertificationG33TestKit::G33CertificationSuite do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('g33_certification') }

  def all_runnables(runnable = suite, collected = [])
    collected << runnable
    runnable.all_children.each { |child| all_runnables(child, collected) }
    collected
  end

  def imported_pas_tests
    all_runnables.select do |runnable|
      runnable < Inferno::Test && runnable.include?(DaVinciPASTestKit::DaVinciPASV221::URLs)
    end
  end

  # The PAS IG version lives in a path prefix rather than in the suite id, so that a later version
  # can be added to this same suite as another prefixed set of endpoints.
  describe 'suite identity' do
    it 'uses a version neutral suite id' do
      expect(suite.id).to eq('g33_certification')
      expect(ONCCertificationG33TestKit::G33ClientURLs::SUITE_ID).to eq(suite.id)
    end

    it 'is the id the test kit registers' do
      expect(ONCCertificationG33TestKit::Metadata.suite_ids).to include(suite.id.to_sym)
    end

    # The imported tests build their own urls, so they have to agree with where the endpoints are
    # actually registered.
    it 'builds test urls that match the prefix the endpoints are registered under' do
      expect(ONCCertificationG33TestKit::G33PASImport.base_url).to eq(
        "#{Inferno::Application['base_url']}/custom/#{suite.id}" \
        "#{ONCCertificationG33TestKit::G33Options::PAS_V221_PREFIX}"
      )
    end

    it 'serves the PAS endpoints under the version prefix' do
      paths = Inferno.routes.select { |route| route[:suite]&.id == suite.id }.map { |route| route[:path] }
      prefix = ONCCertificationG33TestKit::G33Options::PAS_V221_PREFIX

      expect(paths).to_not be_empty
      expect(paths.select { |path| path.start_with?(prefix) }).to_not be_empty
      expect(paths).to include("#{prefix}#{DaVinciPASTestKit::SUBMIT_PATH}")
      expect(paths).to include("#{prefix}#{DaVinciPASTestKit::INQUIRE_PATH}")
    end
  end

  describe 'backend services authentication' do
    it 'keeps the SMART registration test and drops the other client type variants' do
      titles = all_runnables.map(&:title)

      expect(titles).to include('PAS client registers with Inferno as a SMART confidential asymmetric client')
      expect(titles).to_not include('PAS client invokes the registration endpoint to register as a UDAP client')
    end

    it 'imports the SMART authentication review group' do
      expect(all_runnables.map(&:id)).to include(a_string_including('auth_smart'))
    end

    it 'removes the session_url_path input used only by the other authentication option' do
      with_input = all_runnables.select { |runnable| runnable.inputs.include?(:session_url_path) }

      expect(with_input.map(&:id)).to be_empty
    end
  end

  describe 'optional exclusion' do
    it 'excludes every optional runnable, not just direct children of the imported groups' do
      optional = all_runnables.reject { |runnable| runnable == suite }.select(&:optional?)

      expect(optional.map(&:id)).to be_empty
    end
  end

  describe 'PAS url rewriting' do
    let(:pas_base_url) { ONCCertificationG33TestKit::G33PASImport.pas_base_url }
    let(:base_url) { ONCCertificationG33TestKit::G33PASImport.base_url }

    it 'resolves run time urls against this suite rather than the PAS client suite' do
      base_urls = imported_pas_tests.map { |test| test.new.base_url }.uniq

      expect(imported_pas_tests).to_not be_empty
      expect(base_urls).to eq([base_url])
    end

    it 'rewrites PAS urls baked into descriptions and input instructions' do
      stale = all_runnables.select do |runnable|
        [runnable.description, runnable.input_instructions].any? { |text| text.to_s.include?(pas_base_url) }
      end

      expect(stale.map(&:id)).to be_empty
    end

    it 'rewrites PAS urls baked into input descriptions' do
      stale = all_runnables.select do |runnable|
        runnable.config.inputs.each_value.any? { |input| input.description.to_s.include?(pas_base_url) }
      end

      expect(stale.map(&:id)).to be_empty
    end
  end

  describe 'endpoint IG version' do
    it 'reports v2.2.1 rather than falling back to the earlier IG version' do
      expect(ONCCertificationG33TestKit::G33ClaimEndpoint.allocate.ig_version).to eq('v2.2.1')
    end
  end
end
