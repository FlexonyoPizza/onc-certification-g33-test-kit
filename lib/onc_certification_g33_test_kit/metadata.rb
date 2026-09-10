require_relative 'version'

module ONCCertificationG33TestKit
  class Metadata < Inferno::TestKit
    id :onc_certification_g33_test_kit
    title 'ONC Certification (g)(33) Standardized API Test Kit'
    description <<~DESCRIPTION
      The ONC Certification (g)(33) Standardized API Test Kit is a testing tool for
      Health IT systems seeking to meet the requirements of the § 170.315(g)(33)
      criterion in the ONC Certification Program.

      <!-- break -->

      <!-- TODO: Replace this placeholder description with the official
      § 170.315(g)(33) criterion title, description, and test procedure link once
      confirmed. -->

      ## Running the Certification Tests

      Certification against § 170.315(g)(33) is demonstrated by running the **ONC
      Certification (g)(33) Standardized API** suite, listed below. It verifies
      conformance to [version 2.2.1](https://hl7.org/fhir/us/davinci-pas/2.2.1) of the
      Da Vinci Prior Authorization Support (PAS) Implementation Guide using the client
      tests from the
      [Da Vinci PAS Test Kit](https://github.com/inferno-framework/davinci-pas-test-kit).

      Authentication uses SMART Backend Services. Select the suite and click#{' '}
      'Create Test Session' to begin.

      ## Status

      This test kit is a **DRAFT** and is under active development. Future versions may
      verify additional requirements and may change how existing requirements are
      tested.
    DESCRIPTION

    suite_ids [:g33_certification]
    tags ['Da Vinci PAS', 'SMART App Launch']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['Inferno Team']
    repo 'https://github.com/onc-healthit/onc-certification-g33-test-kit'
  end
end
