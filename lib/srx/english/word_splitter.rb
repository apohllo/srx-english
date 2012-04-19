# encoding: utf-8

module SRX
  module English
    class WordSplitter
      include Enumerable

      attr_accessor :sentence
      SPLIT_RULES = {
        :word => "\\p{Alpha}\\p{Word}*",
        :number => "\\p{Digit}+(?:[:., _/-]\\p{Digit}+)*",
        :punct => "\\p{Punct}",
        :graph => "\\p{Graph}",
        :other => "[^\\p{Word}\\p{Graph}]+"
      }

      SPLIT_RE = /#{SPLIT_RULES.values.map{|v| "(#{v})"}.join("|")}/m

      # The initializer accepts a +sentence+, which might be a
      # Sentence instance or a String instance.
      #
      # The splitter might be initialized without the sentence,
      # but should be set using the accessor before first call to
      # +each+ method.
      def initialize(sentence=nil)
        @sentence = sentence
      end

      # This method iterates over the words in the sentence.
      # It yields the string representation of the word and
      # its type, which is one of:
      # * +:word+ - a regular word (including words containing numbers, like A4)
      # * +:number+ - a number (including number with spaces, dashes, slashes, etc.)
      # * +:punct+ - single punctuation character (comma, semicolon, full stop, etc.)
      # * +:graph+ - any single graphical (visible) character
      # * +:other+ - anything which is not covered by the above types (non-visible
      #   characters in particular)
      def each
        raise "Invalid argument - sentence is nil" if @sentence.nil?
        @sentence.scan(SPLIT_RE) do |word,number,punct,graph,other|
          if !word.nil?
            yield word, :word
          elsif !number.nil?
            yield number, :number
          elsif !punct.nil?
            yield punct, :punct
          elsif !graph.nil?
            yield graph, :graph
          else
            yield other, :other
          end
        end
      end
    end
  end
end

