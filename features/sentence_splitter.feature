Feature: sentence splitter
  Scenario: splitting text
    Given a text
      """
      It [really!] works.
      """
    When the text is split
    Then the following sentences should be detected
      | sentence            |
      #-------------------- #
      | It [really!] works. |

    Given a text
      """
      This is e.g. Mr. Smith, who talks slowly... And this is another sentence.
      """
    When the text is split
    Then the following sentences should be detected
      | sentence                                    |
      #---------------------------------------------#
      | This is e.g. Mr. Smith, who talks slowly... |
      | And this is another sentence.               |

    Given a text
      """
      Leave me alone!, he yelled. I am in the U.S. Army. Charles (Ind.) said he.
      """
    When the text is split
    Then the following sentences should be detected
      | sentence                    |
      #-----------------------------#
      | Leave me alone!, he yelled. |
      | I am in the U.S. Army.      |
      | Charles (Ind.) said he.     |
