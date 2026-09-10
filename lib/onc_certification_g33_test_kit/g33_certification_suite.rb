require_relative 'metadata'
require_relative 'g33_options'
require_relative 'empty_g33_group'

module ONCCertificationG33TestKit
  class G33CertificationSuite < Inferno::TestSuite
    title 'ONC Certification (g)(33) Standardized API'
    short_title '(g)(33) Standardized API'
    id :g33_certification
    description <<~DESCRIPTION
      The ONC Certification (g)(33) Standardized API Test Suite verifies the
      conformance of Health IT systems to the requirements of the § 170.315(g)(33)
      criterion in the ONC Certification Program.

      This suite is an initial scaffold and currently contains only a placeholder
      group. Real test content will be added in future releases.
    DESCRIPTION

    links [
      {
        label: 'Report Issue',
        url: 'https://github.com/onc-healthit/onc-certification-g33-test-kit/issues/'
      },
      {
        label: 'Open Source',
        url: 'https://github.com/onc-healthit/onc-certification-g33-test-kit/'
      },
      {
        label: 'Download',
        url: 'https://github.com/onc-healthit/onc-certification-g33-test-kit/releases'
      }
    ]

    suite_option :us_core_version,
                 title: 'US Core Version',
                 list_options: [
                   { label: 'US Core 6.1.0 / USCDI v3', value: G33Options::US_CORE_6 },
                   { label: 'US Core 7.0.0 / USCDI v4', value: G33Options::US_CORE_7 }
                 ]

    # All FHIR validation requests will use this FHIR validator
    fhir_resource_validator do
      exclude_message do |message|
        message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/)
      end
    end

    group from: :empty_g33_group
  end
end
