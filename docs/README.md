The **ONC Certification (g)(33) Standardized API Test Kit** is a testing tool
for Health IT systems seeking to meet the requirements of the ONC [Prior
Authorization Support criterion §
170.315(g)(33)](https://healthit.gov/test-method/provider-prior-authorization-api-prior-authorization-support)
in the ONC Health IT Certification Program. The following documentation provides
information on how to use and contribute to this test kit.

DISCLAIMER: this test kit is currently a draft and not ready for ONC certification purposes.

## Overview

This test kit validates conformance to the following implementation specifications required by the (g)(33) certification criterion:

*   Health Level 7 (HL7®) Fast Healthcare Interoperability Resources (FHIR®) (v4.0.1)
*   Da Vinci Prior Authorization Support (PAS) Implementation Guide (v2.2.1)
*   SMART App Launch, Backend Services (v2.0.0)
*   Subscriptions R5 Backport Implementation Guide (v1.1.0)

## Using this Test Kit

*   [Getting Started](https://github.com/onc-healthit/onc-certification-g33-test-kit#getting-started): Installation instructions for setting up and running this test kit locally.
*   [Test Kit Walkthrough](https://github.com/onc-healthit/onc-certification-g33-test-kit/wiki/Walkthrough): A step-by-step guide to using this test kit, including detailed instructions for each testing scenario.

## Contributing to this Test Kit

Developers contributing to this test kit should be familiar with [authoring
Inferno Framework test suites](https://inferno-framework.github.io/docs/writing-tests/). These tests are largely a subset of the [Da Vinci PAS Test Kit](https://github.com/inferno-framework/davinci-pas-test-kit).
The following guides provide additional information about the design
and implementation of this test kit to aid in contributing to these tests:

*   [Technical Overview](Technical-Overview)
*   [Da Vinci PAS Test Kit Wiki](https://github.com/inferno-framework/davinci-pas-test-kit/wiki): Documentation for the PAS client tests that this test kit imports, including how Inferno simulates a PAS payer server and how its responses can be controlled.
*   [PAS Client Test Instructions](https://github.com/inferno-framework/davinci-pas-test-kit/wiki/Client-Instructions-v2.2.1): How Inferno builds the `$submit` and `$inquire` responses returned to the client under test, and how those responses can be customized.

## Support

For questions or issues with this test kit, please reach out to the Inferno team
on the [#Inferno FHIR Zulip
channel](https://chat.fhir.org/#narrow/stream/179309-inferno).

Report bugs or provide suggestions in [GitHub Issues](https://github.com/onc-healthit/onc-certification-g33-test-kit/issues).
