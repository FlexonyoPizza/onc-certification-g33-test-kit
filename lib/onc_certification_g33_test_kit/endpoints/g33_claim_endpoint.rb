require 'davinci_pas_test_kit/client/endpoints/claim_endpoint'
require_relative '../g33_options'

module ONCCertificationG33TestKit
  class G33ClaimEndpoint < DaVinciPASTestKit::ClaimEndpoint
    def ig_version
      G33Options::PAS_V221_DOTTED
    end
  end
end
