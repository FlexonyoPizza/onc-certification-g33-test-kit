This walkthrough introduces the **Inferno ONC Certification (g)(33)
Standardized API Test Kit** by
demonstrating its use as an automated testing tool for the
[§ 170.315(g)(33) prior authorization submission criterion](https://healthit.gov/test-method/provider-prior-authorization-api-prior-authorization-support)
of the ONC Health IT Certification Program. At the end of this walkthrough,
you will be able to use the test kit to evaluate a Health IT Module for
conformance to the (g)(33) certification criterion.

This test kit evaluates a **Health IT Module**, specifically a provider system
that submits prior authorization requests to a payer. Each step of this
walkthrough describes the kinds of actions that a tester would take within their
Health IT Module when running these tests against it.

During the tests, Inferno will act as a PAS payer server for the Health IT
Module to interact with. Inferno publishes simulated `$submit`, `$inquire`, and
Subscription endpoints, waits for the Health IT Module to invoke them, and then
validates the requests it received and the way the Health IT Module handled
Inferno's responses. Because Inferno is waiting to be called, most scenarios
pause on a 'User Action Required' dialog. Inferno will only associate requests
with your session while one of these dialogs is active. Once it is active the
tester takes actions within the Health IT Module that trigger the relevant
requests and acknowledges within the Inferno UI once all requests have been sent
so that Inferno knows to start evaluating them.

NOTE: If multiple people are running this demonstration at the same time, unexpected results
may occur. If you see strange behavior, pause execution and try again later.

The following steps necessary to complete certification testing are described in more detail below:
*   [Step 1: Create a new (g)(33) Test Session](#step-1-create-a-new-g33-test-session)
*   [Step 2: Configure the Health IT Module Under Test](#step-2-configure-the-health-it-module-under-test)
*   [Step 3: Perform Client Registration Tests](#step-3-perform-client-registration-tests)
*   [Step 4: Perform Subscription Setup Tests](#step-4-perform-subscription-setup-tests)
*   [Step 5: Perform PAS Workflow Tests](#step-5-perform-pas-workflow-tests)
*   [Step 6: Perform Must Support Element Tests](#step-6-perform-must-support-element-tests)
*   [Step 7: Perform Error Handling Tests](#step-7-perform-error-handling-tests)
*   [Step 8: Review Authentication Interactions](#step-8-review-authentication-interactions)
*   [Step 9: Complete Visual Inspection and Attestation](#step-9-complete-visual-inspection-and-attestation)
*   [Step 10: Review Results](#step-10-review-results)

## Step 1: Create a new (g)(33) test session

* Go to <https://inferno.healthit.gov>.
* Click the 'ONC (g)(33) Standardized API Test Kit' button under 'ONC Health
  Certification Program', which is an Inferno test kit developed specifically to
  test the requirements of the (g)(33) criterion in the ONC Health IT
  Certification Program.
* Select which version of the PAS client suite to test against, then click
  'Create Test Session'.

Unlike some other test kits, no client security type is selected. The (g)(33)
criterion requires SMART Backend Services authentication, so it is always used
and the tests that apply to other authentication approaches are not present.

This creates a new test session. The header states which version of the test kit
is being used and which client version was selected.

The tests are organized into seven groups that in sum cover the requirements of the criterion:

1.  **Client Registration** - the Health IT Module registers with Inferno as a SMART
    confidential asymmetric client and is given Inferno's simulated PAS endpoints.
2.  **Subscription Setup** - the Health IT Module creates a Subscription so that it can be
    notified when pended prior authorization requests are updated.
3.  **PAS Workflows** - the Health IT Module participates in complete prior authorization
    interactions, covering approved, denied, pended, updated, and payer-modified requests.
4.  **Must Support Elements** - the Health IT Module demonstrates that it can send and receive
    all PAS-defined profiles and their must support elements.
5.  **Error Handling** - the Health IT Module handles both HTTP-level operation failures and
    business-level processing errors returned within a response bundle.
6.  **Review Authentication Interactions** - Inferno verifies that the token requests made during
    the earlier groups conformed to SMART Backend Services requirements.
7.  **Visual Inspection and Attestation** - the tester confirms the Health IT Module conforms to
    requirements that are currently not verified through automated testing.

The groups are intended to be run in order. Later groups depend on data collected
during earlier ones. In particular, 'Client Registration' records the client id
that ties incoming requests to your session, 'Subscription Setup' creates the
Subscription that the pended workflow notifies against, and 'Review
Authentication Interactions' evaluates the token requests made while running the
earlier groups.

## Step 2: Configure the Health IT Module under test

Inferno simulates a PAS payer server. In order to pass the certification tests,
Health IT Modules will need to be configured to submit prior authorization
requests to Inferno's endpoints and to authenticate using SMART Backend
Services.

Inferno's simulated PAS endpoints:
*   FHIR base URL: `https://inferno.healthit.gov/custom/g33_certification/pas_v221/fhir`
*   Prior authorization submission: `<FHIR base>/Claim/$submit`
*   Prior authorization inquiry: `<FHIR base>/Claim/$inquire`
*   Subscription creation: `<FHIR base>/Subscription`
*   SMART discovery: `<FHIR base>/.well-known/smart-configuration`

The exact URLs for your session are displayed during the 'Client Registration'
group, and are the authoritative values to configure. Note that the PAS version
appears in the path as `pas_v221`, so that later PAS versions can be added to
this same test kit.

## Step 3: Perform Client Registration tests

The 'Client Registration' group records the connection details that the rest of
the tests rely on, so it must be run first. No prior authorization requests are
exchanged during this group.

*   Select '1 Client Registration' and click 'RUN TESTS'.
*   Provide the registration inputs:
    *   **Client Id**: the client id Inferno will expect the Health IT Module to use
        when requesting access tokens. Testers may provide a specific value; if
        none is provided, the Inferno session id is used. This value identifies
        which test session an incoming request belongs to, so the Health IT
        Module must be configured with exactly this value.
    *   **SMART Confidential Asymmetric JSON Web Key Set (JWKS)**: the Health IT
        Module's JWK Set, either as a publicly accessible URL or as raw JSON.
        Inferno uses this to verify the signature on the client assertions the
        Health IT Module sends when requesting tokens.
*   Click 'SUBMIT'.
*   Inferno displays its simulated server details, including the FHIR base URL
    and token endpoint. Configure the Health IT Module to connect to Inferno at
    these endpoints, then click the confirmation link in the dialog.

These values are carried forward and locked in the later groups, so you only
enter them once.

## Step 4: Perform Subscription Setup tests

The (g)(33) criterion requires support for subscriptions so that the Health IT
Module can be notified when a pended prior authorization is updated. This group
verifies that the Health IT Module can create a conformant Subscription and
respond to Inferno's handshake.

*   Select '2 Subscription Setup' and click 'RUN TESTS'.
*   When the 'User Action Required' dialog appears, submit a `POST` containing a
    Subscription resource to the URL shown in the dialog.
*   The Subscription must be conformant to the R4/B Topic-Based Subscription
    profile and to PAS requirements on Subscriptions, including:
    *   a `rest-hook` channel type,
    *   a resolvable `channel.endpoint`,
    *   the PAS-defined subscription topic in `criteria`, and
    *   filter criteria identifying the client's organization.
*   Upon receipt, Inferno sends a handshake notification to the endpoint named in
    the Subscription and continues the test based on the result, so that endpoint
    must be reachable by Inferno.

PAS requires that clients only support subscriptions with
`content=full-resource`, which this group verifies.

## Step 5: Perform PAS Workflow tests

The workflow tests verify that the Health IT Module can participate in complete
end-to-end prior authorization interactions, initiating requests and reacting
appropriately to the responses returned. This group contains five sub-groups:

*   **Approval Workflow** - a request that the payer approves.
*   **Denial Workflow** - a request that the payer denies.
*   **Pended Workflow** - a request the payer pends, with the final decision
    delivered later through a subscription notification.
*   **Claim Updates** - a sequence of four submissions: an initial request, an
    update adding an item, an update modifying and canceling items, and an update
    canceling the entire request.
*   **Payer Modifications** - a request the payer partially authorizes with
    modified items.

Each sub-group follows the same pattern:

*   Select the sub-group and click 'RUN TESTS'.
*   Optionally provide a response bundle for Inferno to return. If the relevant
    response input is populated, it will be returned with current timestamps.
    Otherwise Inferno generates a response from the received Claim.
*   When the 'User Action Required' dialog appears, submit a prior authorization
    request from the Health IT Module to the URL shown.
*   Inferno validates the request bundle and the response bundle it returned, and
    then asks you to attest that the Health IT Module displayed the decision
    appropriately.

The Claim Updates sub-group additionally verifies the PAS-specific rules for
updating a previously submitted Claim, such as including the prior Claim in
`Claim.related.claim`, preserving all previous item and supportingInfo entries,
and flagging canceled and changed entries with the appropriate extensions.

## Step 6: Perform Must Support element tests

During these tests, the Health IT Module shows that it supports all PAS-defined
profiles and the must support elements defined in them, both in the requests it
sends and in the responses it can receive.

*   Select '4 Must Support Elements' and click 'RUN TESTS'.
*   Optionally provide sets of `$submit` and `$inquire` response bundles for
    Inferno to return. Because Inferno's generated responses do not include every
    must support element, providing responses that do is how a Health IT Module
    demonstrates it can receive them.
*   When the 'User Action Required' dialog appears, submit additional `$submit`
    and `$inquire` requests demonstrating coverage of any must support elements
    not already exercised during the workflow tests.

Inferno considers requests made during the PAS Workflows group as well, so only
profiles and elements not already demonstrated there need to be submitted here.

## Step 7: Perform Error Handling tests

The error handling tests verify that the Health IT Module can appropriately
handle prior authorization error responses from the payer. This group contains
two sub-groups:

*   **Operation Failure** - Inferno returns an HTTP error status with an
    `OperationOutcome` rather than a response bundle.
*   **Processing Errors** - Inferno returns a response bundle containing
    business-level error entries.

For each, submit a request when prompted, and then attest that the Health IT
Module handled the error appropriately.

## Step 8: Review Authentication Interactions

This group does not require any new interaction with the Health IT Module.
Inferno verifies that the access token requests made during the earlier groups
conformed to the SMART Backend Services requirements, and that the issued tokens
were used on the prior authorization requests.

*   Select '6 Review Authentication Interactions' and click 'RUN TESTS'.

Because these tests evaluate requests made earlier, at least one of the
preceding groups that exchanges prior authorization requests must have been run
first. If no token requests were made, the tests will skip rather than fail.

## Step 9: Complete Visual Inspection and Attestation

Not every requirement can be verified automatically. This group collects
attestations for the remaining requirements of the criterion.

*   Select '7 Visual Inspection and Attestation'.
*   Each test asks you to confirm that the Health IT Module meets one or more **SHALL** requirements
    by selecting 'Yes' or 'No' in the input with the same name as the test before starting the run.
    You are responsible for confirming that the Health IT Module meets all requirements
    associated with a test before selecting "Yes" on the attestation input with the same name as
    the test. Selecting 'No' fails the test.
*   You may use the accompanying notes field to record supporting details.
    Notes are recorded in the test result.
*   To review the exact requirement text behind a test, open its 'ABOUT' tab and follow the
    'View Specification Requirements' link.

These tests cover areas that are very broad or otherwise difficult to demonstrate
or mechanically verify, such as the expectations a Health IT Module places on
data elements and the ability for providers to review a submission before it is
sent.

## Step 10: Review Results

All tests have now been completed. To print out a copy of the results, click the 'Report' icon in
the menu on the left and then the 'Print' icon within that view. Export this report if you would
like to share the results.
