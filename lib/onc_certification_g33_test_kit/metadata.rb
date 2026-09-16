require_relative 'version'

module ONCCertificationG33TestKit
  class Metadata < Inferno::TestKit
    id :onc_certification_g33_test_kit
    title 'ONC Certification (g)(33) Prior Authorization Support API Test Kit'
    description <<~DESCRIPTION
      The ONC Certification (g)(33) Prior Authorization Support API Test Kit is a testing tool
      for Health IT systems seeking to meet the requirements of the prior
      authorization submission criterion § 170.315(g)(33) in the ONC Health IT
      Certification Program.

      **DISCLAIMER**: this test kit is currently a **DRAFT** and not ready for ONC certification purposes.
      <!-- break -->

      ## Status

      The ONC Certification (g)(33) Prior Authorization Support API Test Kit is actively
      developed and updates are released monthly.

      The test kit currently tests requirements for the [prior authorization
      submission criterion §
      170.315(g)(33)](https://healthit.gov/test-method/provider-prior-authorization-api-prior-authorization-support).
      This includes:
      - Client registration and SMART Backend Services authorization
      - Prior authorization submission and inquiry workflows
      - Subscriptions for pended prior authorization requests
      - Must support element coverage
      - Error handling
      - Documentation

      See the test descriptions within the test kit for detail on the specific
      validations performed as part of testing these requirements. These descriptions
      also contain a "View Specification Requirements" link that can be used to see
      the specific requirements verified.

      ## Repository and Resources

      The ONC Certification (g)(33) Prior Authorization Support API Test Kit can be
      [downloaded from its GitHub repository](https://github.com/onc-healthit/onc-certification-g33-test-kit),
      where additional resources and documentation are also available to help users
      get started with the testing process. The
      [Releases](https://github.com/onc-healthit/onc-certification-g33-test-kit/releases)
      page provides information about each new release.

      ## Providing Feedback and Reporting Issues

      We welcome feedback on the tests, including but not limited to the following areas:

      - Validation logic, such as potential bugs, lax checks, and unexpected failures.
      - Requirements coverage, such as requirements that have been missed, tests that
        necessitate features that the IG does not require, or other issues with the
        interpretation of the IG's requirements.
      - User experience, such as confusing or missing information in the test UI.

      Please report any issues with this set of tests in the [issues
      section](https://github.com/onc-healthit/onc-certification-g33-test-kit/issues)
      of the repository.
    DESCRIPTION

    suite_ids [:g33_certification]
    tags ['Da Vinci', 'PAS', 'SMART App Launch']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['Inferno Team']
    repo 'https://github.com/onc-healthit/onc-certification-g33-test-kit'
  end
end
