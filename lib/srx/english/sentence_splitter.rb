#encoding: utf-8
require 'stringio'
require 'term/ansicolor'
module SRX
  module English
    RULES =
[["(?:['\"„][\\.!?…]['\"”]\\s)|(?:[^\\.]\\s[A-Z]\\.\\s)|(?:\\b(?:St|Gen|Hon|Prof|Dr|Mr|Ms|Mrs|[JS]r|Col|Maj|Brig|Sgt|Capt|Cmnd|Sen|Rev|Rep|Revd)\\.\\s)|(?:\\b(?:St|Gen|Hon|Prof|Dr|Mr|Ms|Mrs|[JS]r|Col|Maj|Brig|Sgt|Capt|Cmnd|Sen|Rev|Rep|Revd)\\.\\s[A-Z]\\.\\s)|(?:\\bApr\\.\\s)|(?:\\bAug\\.\\s)|(?:\\bBros\\.\\s)|(?:\\bCo\\.\\s)|(?:\\bCorp\\.\\s)|(?:\\bDec\\.\\s)|(?:\\bDist\\.\\s)|(?:\\bFeb\\.\\s)|(?:\\bInc\\.\\s)|(?:\\bJan\\.\\s)|(?:\\bJul\\.\\s)|(?:\\bJun\\.\\s)|(?:\\bMar\\.\\s)|(?:\\bNov\\.\\s)|(?:\\bOct\\.\\s)|(?:\\bPh\\.?D\\.\\s)|(?:\\bSept?\\.\\s)|(?:\\b\\p{Lu}\\.\\p{Lu}\\.\\s)|(?:\\b\\p{Lu}\\.\\s\\p{Lu}\\.\\s)|(?:\\bcf\\.\\s)|(?:\\be\\.g\\.\\s)|(?:\\besp\\.\\s)|(?:\\bet\\b\\s\\bal\\.\\s)|(?:\\bvs\\.\\s)|(?:\\p{Ps}[!?]+\\p{Pe} )",
  nil,
  false],
 ["(?:[\\.\\s]\\p{L}{1,2}\\.\\s)", "[\\p{N}\\p{Ll}]", false],
 ["(?:[\\[\\(]*\\.\\.\\.[\\]\\)]* )", "[^\\p{Lu}]", false],
 ["(?:\\b(?:pp|[Vv]iz|i\\.?\\s*e|[Vvol]|[Rr]col|maj|Lt|[Ff]ig|[Ff]igs|[Vv]iz|[Vv]ols|[Aa]pprox|[Ii]ncl|Pres|[Dd]ept|min|max|[Gg]ovt|lb|ft|c\\.?\\s*f|vs)\\.\\s)",
  "[^\\p{Lu}]|I",
  false],
 ["(?:\\b[Ee]tc\\.\\s)", "[^p{Lu}]", false],
 ["(?:[\\.!?…]+\\p{Pe} )|(?:[\\[\\(]*…[\\]\\)]* )", "\\p{Ll}", false],
 ["(?:\\b\\p{L}\\.)", "\\p{L}\\.", false],
 ["(?:\\b\\p{L}\\.\\s)", "\\p{L}\\.\\s", false],
 ["(?:\\b[Ff]igs?\\.\\s)|(?:\\b[nN]o\\.\\s)", "\\p{N}", false],
 ["(?:[\"”']\\s*)", "\\s*\\p{Ll}", false],
 ["(?:[\\.!?…][\\u00BB\\u2019\\u201D\\u203A\"'\\p{Pe}\\u0002]*\\s)|(?:\\r?\\n)",
  nil,
  true],
 ["(?:[\\.!?…]['\"\\u00BB\\u2019\\u201D\\u203A\\p{Pe}\\u0002]*)",
  "\\p{Lu}[^\\p{Lu}]",
  true],
 ["(?:\\s\\p{L}[\\.!?…]\\s)", "\\p{Lu}\\p{Ll}", true]]
    BEFORE_RE = /(?:#{RULES.map{|s,e,v| "(#{s})"}.join("|")})\Z/m
    REGEXPS = RULES.map{|s,e,v| [/(#{s})\Z/m,/\A(#{e})/m,v] }
    FIRST_CHAR = /\A./m


    class SentenceSplitter
      include Enumerable

      attr_accessor :input
      attr_writer :debug

      # The sentence splitter is initialized with the +text+ to split.
      # This might be a String or a IO object.
      def initialize(text=nil)
        if text.is_a?(String)
          @input = StringIO.new(text,"r:utf-8")
        else
          @input = text
        end
      end

      # Iterate over the sentences in the text.
      # If the text is nil, exception is raised.
      def each
        raise "Invalid argument - text is nil" if @input.nil?
        buffer_length = 10
        sentence = ""
        before_buffer = ""
        @input.pos = 0
        after_buffer = buffer_length.times.map{|i| @input.readchar}.join("")
        matched_rule = nil
        while(!@input.eof?) do
          matched_before = BEFORE_RE.match(before_buffer)
          break_detected = false
          if matched_before
            start_index = (matched_before.size - 1).times.find do |index|
              matched_before[index+1]
            end
            if @debug
              puts "#{before_buffer}|#{after_buffer.gsub(/\n/,"\\n")}"
            end
            REGEXPS.each do |before_re,after_re,value|
              # skip the whole match
              if before_re.match(before_buffer) && after_re.match(after_buffer)
                break_detected = true
                color = value ? :red : :green
                if @debug
                  sentence << Term::ANSIColor.send(color,"<#{before_re}:#{after_re}>")
                end
                if value
                  yield sentence
                  sentence = ""
                end
                break
              end
            end
          end
          next_after = @input.readchar
          before_buffer.sub!(FIRST_CHAR,"") if before_buffer.size >= buffer_length
          after_buffer.sub!(FIRST_CHAR,"")
          before_buffer << $&
          sentence << $&
          after_buffer << next_after
        end
        yield sentence + after_buffer unless sentence.empty? || after_buffer.empty?
      end
    end
  end
end
