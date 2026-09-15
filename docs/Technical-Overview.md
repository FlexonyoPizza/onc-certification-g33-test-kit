This document provides technical information about the design of this test kit
and is intended to serve multiple purposes:
* To guide individuals who are interested in contributing to this project.
* To assist in the onboarding of new development team members.
* To support the long-term continuity of this project by enabling an
  effective transfer of this software to new stewards.

This document does not provide detailed instructions on how to use
an Inferno test kit, the contents of the (g)(33) Certification Criteria,
basics of the Inferno Framework, or details on how to use Ruby, Docker,
or other tools. Developers are expected to have at least a basic understanding
of all these topics.

Please note that the focus of this document is on features that are specific to
this test kit and it does not provide a detailed explanation of common Inferno
Framework functionality.

## Test Design Principles and features

Prior to making any updates or additions to these tests, developers should
be aware of the general principles that guided development of the existing tests
to ensure a consistent test experience for users. While judgment is required
by the test developer to determine the appropriate level of testing for each
requirement, it is important to provide a consistent approach across the entire
test kit to aid users in understanding the results of the tests.

Tests for this test kit have been designed with the following principles:
* Easy testing: Users should be able to run the tests with minimal input or
  configuration, and tests should complete in a reasonable amount of time.
* Limit extraneous constraints: The tests should not place additional constraints
  on the system under test.
* Reuse existing tests when possible: Reuse tests from test kits that target
  implementation guides that are required within this test kit.

The design of the tests within this test kit reflects these principles:
* Systems do not need to load a specific set of example data; instead, the
  tests allow systems to provide their own data that exhibits all required
  functionality.
* Tests are written to verify the use of all required specifications together
  as described by the certification criterion, instead of requiring systems to
  independently test each.
* Not all requirements provided by the certification criterion or the
  underlying standards can be tested using an automated tool. In these cases,
  the system under test can attest that the requirement is met, or a tester
  can choose to provide a method for visual inspection. Tests are provided
  at the end of the test kit to ensure these are accomplished.

The (g)(33) Test Kit manages this complexity through standard software design
practices and approaches, leveraging the functionality provided by the Ruby
programming language. While this code is intended to be accessible to
developers new to the Ruby language, developers are expected to learn the basics
of Ruby development before attempting to alter these tests. This test kit also
uses RSpec to "unit test" components of these tests, and developers are expected
to learn the basics of RSpec as well.

## Relationship with Other Test Kits

The ONC (g)(33) Certification Criterion requires the implementation of several
FHIR Implementation Guides, while providing guidance on how to support these
test kits to accomplish the specific requirements of the certification
criterion. In order to facilitate testing systems independently of the (g)(33)
Certification requirements, each of these Implementation Guides also has a
stand-alone test kit. The (g)(33) Test Kit then imports tests defined in these
test kits and integrates them into a single cohesive test procedure, while also
further constraining their implementation to meet any (g)(33)-specific
requirements.

The specific test kits that are imported into this test kit include:

1. **[Da Vinci PAS Test Kit](https://github.com/inferno-framework/davinci-pas-test-kit)**:
   All (g)(33) tests are imported directly from the PAS test kit's client suite.
1. **[SMART App Launch Test Kit](https://github.com/inferno-framework/smart-app-launch-test-kit)**:
   The PAS test kit uses SMART Backend Services tests which are in turn imported into (g)(33).

## Test Kit Code Organization

The (g)(33) Test Kit follows general Ruby conventions for applications and
libraries. It is organized into several main directories:

- `.github`: Contains workflows for integrating with GitHub's automated tools
- `config`: Contains configuration files for the test kit, including presets.
- `data`: Contains runtime data for the test kit, such as local database files
- `docs`: Contains documentation for this test kit.
- `execution_scripts`: Contains integrated testing scripts.
- `lib`: Contains the main logic for the test kit, including the test cases and helper functions.
- `lib/onc_certification_g33_test_kit`: Contains the main tests for the test kit
- `spec`: Contains the RSpec test cases for the test kit.
- `tmp`: Temporary files used by the test kit at runtime.

The (g)(33) Test Kit contains a single suite of tests. This suite is defined in
`lib/onc_certification_g33_test_kit/g33_certification_suite.rb` and imports all
necessary tests from the PAS Test Kit.

## Testing Code Changes

This test kit includes "self testing" functionality to provide
confidence that the tests perform as expected. Prior to committing changes to
this test kit, developers should ensure that both RSpec tests and End-to-End
tests pass.

### RSpec Tests

The test kit contains many "unit" tests within the `spec` directory. These
tests are written in RSpec, and can be run with the following command:

```bundle exec rake```

These tests should be run after any changes to the tests, and must pass before
any changes to the tests are merged into the main branch. It is not expected
that the code base achieves 100% test coverage; instead, the team has followed a
common sense approach to testing components that 1) are complicated or 2) are
likely to change.

### End-to-End testing

Besides the unit tests provided within this test kit, after each update
the tests should be validated against a complete client implementation
that is known to be correct. The Da Vinci PAS Server Suite can drive the
(g)(33) suite for a partial end-to-end test, since it can act as a SMART
Backend Services client:

  1. In one tab, create a (g)(33) session, select the client version, and apply
     the "Run Against a SMART Backend Services Client" preset.
  1. In another tab, create a session for the "Da Vinci PAS Server Suite v2.2.1"
     with no preset selected. The preset bundled with that suite authenticates
     using a session-specific URL path, which this suite does not support.
  1. Configure the server suite:
     - FHIR Server Endpoint URL:
       `<inferno-base>/custom/g33_certification/pas_v221/fhir`. Stop at `/fhir`;
       the suite appends `/Subscription` and `/Claim/$submit` itself.
     - OAuth Credentials: Auth Type "Backend Services", the client id from the
       (g)(33) preset, and the token endpoint
       `<inferno-base>/custom/g33_certification/pas_v221/auth/token`. This is the
       only token path this suite serves, and is the same one the SMART discovery
       document advertises. An access token must be provided, since Inferno's
       FHIR client only refreshes an existing token and will not fetch an initial
       one.
     - Request payloads for the group being run, which the PAS Test Kit's own
       server preset provides.
  1. Start the (g)(33) group under test first and leave it on its "User Action
     Required" dialog, then run the corresponding server suite group. The
     simulated payer rejects requests whose client id is not tied to a session
     that is currently waiting.
  1. Review the results: the (g)(33) client tests should all pass.

## FHIR and Terminology Validation

To allow test developers control of terminology validation, the public version of
this test kit relies on a private terminology server.
