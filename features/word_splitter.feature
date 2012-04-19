Feature: word splitter
  Scenario: splitting a sentence
    Given a sentence 'My home is my castle.'
    When the sentence is split
    Then the following segments should be detected
      | segment | type  |
      #-----------------#
      | My      | word  |
      | ' '     | other |
      | home    | word  |
      | ' '     | other |
      | is      | word  |
      | ' '     | other |
      | my      | word  |
      | ' '     | other |
      | castle  | word  |
      | .       | punct |
