Feature: word splitter
  Scenario: splitting a sentence
    Given a sentence 'My home is my castle.'
    When the sentence is split
    Then the following segments should be detected
      | segment | type  | start | end |
      #-------------------------------#
      | My      | word  | 0     | 1   |
      | ' '     | other | 2     | 2   |
      | home    | word  | 3     | 6   |
      | ' '     | other | 7     | 7   |
      | is      | word  | 8     | 9   |
      | ' '     | other | 10    | 10  |
      | my      | word  | 11    | 12  |
      | ' '     | other | 13    | 13  |
      | castle  | word  | 14    | 19  |
      | .       | punct | 20    | 20  |
