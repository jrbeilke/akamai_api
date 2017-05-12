Feature: akamai_api ccu arl invalidate
  In order to remove ARLs
  As a CLI user

  @vcr
  Scenario: invalid credentials
    When I run `akamai_api ccu arl invalidate http://www.foo.bar/t.txt -u foo -p bar`
    Then the output should contain:
      """
      Your login credentials are invalid.
      """

  @vcr
  Scenario: invalid item
    When I run `akamai_api ccu arl invalidate http://www.foo.bar/t.txt`
    Then the output should contain:
      """
      Error 403: 'unauthorized arl' (http://www.foo.com/bar.txt)
      """
    And the output should contain:
      """
      Described by: https://api.ccu.akamai.com/ccu/v2/errors/unauthorized-arl
      """

  @vcr
  Scenario: single item
    When I run `akamai_api ccu arl invalidate http://www.foo.bar/t.txt`
    Then the output should contain:
      """
      Purge request successfully submitted:
      """
    And the output should contain:
      """
      * Result: 201 - Request accepted.
      """
    And the output should contain:
      """
      * Purge ID: 12345678-1234-1234-1234-123456789012 | Support ID: 12345678901234567890-123456789
      """

  @vcr
  Scenario: multiple items
    When I run `akamai_api ccu arl invalidate http://www.foo.bar/t.txt http://www.foo.com/baz.txt`
    Then the output should contain:
      """
      Purge request successfully submitted:
      """
    And the output should contain:
      """
      * Result: 201 - Request accepted.
      """
    And the output should contain:
      """
      * Purge ID: 12345678-1234-1234-1234-123456789012 | Support ID: 12345678901234567890-123456789
      """
