require 'davinci_pas_test_kit/client/pas_client_options'

module ONCCertificationG33TestKit
  module G33Options
    PAS_V221 = '2.2.1'.freeze
    PAS_V221_COMPACT = "v#{PAS_V221.delete('.')}".freeze              # v221
    PAS_V221_DOTTED = "v#{PAS_V221}".freeze                           # v2.2.1
    PAS_V221_PREFIX = "/pas_#{PAS_V221_COMPACT}".freeze               # /pas_v221
    PAS_V221_IG_PACKAGE = "hl7.fhir.us.davinci-pas##{PAS_V221}".freeze

    PAS_VERSION_2_2_1 = 'pas_v221'.freeze # For selecting the PAS client version in the suite options

    # Tags the groups imported from the PAS v2.2.1 client suite, so the :pas_version suite option
    # selects between versions once a second one is added alongside them.
    PAS_V221_REQUIREMENT = { pas_version: PAS_VERSION_2_2_1 }.freeze

    CLIENT_TYPE = DaVinciPASTestKit::PASClientOptions::SMART_BACKEND_SERVICES_CONFIDENTIAL_ASYMMETRIC

    US_CORE_3 = 'us_core_3'.freeze
    US_CORE_4 = 'us_core_4'.freeze
    US_CORE_5 = 'us_core_5'.freeze
    US_CORE_6 = 'us_core_6'.freeze
    US_CORE_7 = 'us_core_7'.freeze

    US_CORE_VERSION_NUMBERS = {
      US_CORE_3 => '3.1.1',
      US_CORE_4 => '4.0.0',
      US_CORE_5 => '5.0.1',
      US_CORE_6 => '6.1.0',
      US_CORE_7 => '7.0.0'
    }.freeze

    US_CORE_3_REQUIREMENT = { us_core_version: US_CORE_3 }.freeze
    US_CORE_4_REQUIREMENT = { us_core_version: US_CORE_4 }.freeze
    US_CORE_5_REQUIREMENT = { us_core_version: US_CORE_5 }.freeze
    US_CORE_6_REQUIREMENT = { us_core_version: US_CORE_6 }.freeze
    US_CORE_7_REQUIREMENT = { us_core_version: US_CORE_7 }.freeze

    US_CORE_IG_PACKAGE = "hl7.fhir.us.core##{US_CORE_VERSION_NUMBERS[US_CORE_6]}".freeze

    def us_core_version
      suite_options[:us_core_version]
    end
  end
end
