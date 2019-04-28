require 'strscan'
require 'forwardable'

module ShVars
  class String
    class << self
      def unquote_pair(str)
        str = new(str).unquote
        new(str).pair
      end
    end

    KEY   = %r([^\s=]+)
    WORD  = %r((\\.|(?!\s|"|'|`|\${|\$\().))
    SPACE = %r(\s+)
    EQUAL = %r(=)
    OPEN  = %r(\$\(|\$\{)
    CLOSE = { '$(' => %r(\)), '${' => %r(\}) }

    extend Forwardable

    def_delegators :str, :check, :eos?, :peek, :pos, :scan, :skip, :string
    attr_reader :str

    def initialize(str)
      @str = StringScanner.new(str.to_s.strip)
    end

    def parse
      pairs = [pair]
      pairs << pair while space
      pairs.tap { err('end of string') unless eos? }
    end

    def pair
      double_quoted_pair || unquoted_pair || empty_pair
    end

    def double_quoted_pair
      return unless var = double_quoted
      self.class.unquote_pair(var)
    end

    def unquoted_pair
      return unless key = scan(KEY)
      return [key, ''] unless scan(EQUAL)
      parts, part = [], nil
      parts << part while part = value
      [key, parts.join]
    end

    def empty_pair
      key = word
      pair = [key, ''] if key
      pair
    end

    def values
      parts, part = [], nil
      parts << part while part = value || space
      parts.join if parts.any?
    end

    def value
      parens { values } || quoted || word
    end

    def open
      @open ||= []
    end

    def parens
      return unless paren = scan(OPEN)

      open << paren
      str = yield
      open.pop

      close = CLOSE[paren] if paren
      close = scan(close)  if close
      [paren, str, close].join
    end

    def quoted
      double_quoted || single_quoted("'") || single_quoted("`")
    end

    def word
      chars, char = [], nil
      chars << char while !quote? && char = scan(WORD)
      chars.join if chars.any?
    end

    def space
      scan(SPACE)
    end

    def single_quoted(char)
      pattern = /#{char}/
      return unless quote = scan(pattern)
      quotes << quote
      str = scan(/[^#{char}]*/) # how about nested double quoted strs in here
      quote = quotes.pop
      err(quote) unless scan(pattern) == quote
      [quote, str, quote].join
    end

    def double_quoted
      pattern = /^#{'\\' * level * 4}"/
      return unless quote = scan(pattern)
      quotes << quote

      parts, part = [], nil
      parts << part while part = scan_quote(quote)
      parts << values
      parts << part while part = scan_quote(quote)

      quotes.pop
      err(quote) unless scan(pattern) == quote
      [quote, *parts, quote].join
    end

    def scan_quote(quote)
      str = scan(/[^#{quote}\\]+/)
      str ||= scan(/#{'\\' * level * 2}#{quote}/)
      str
    end

    def unquote
      pattern = /^#{'\\' * level * 4}"/
      return unless quote = scan(pattern)
      quotes << quote

      parts, part = [], nil
      parts << part while part = scan_unquote(quote)
      parts << unquote
      parts << part while part = scan_unquote(quote)

      quote = quotes.pop
      err(quote) unless scan(pattern) == quote
      unquote = level == 0 ? '' : %(#{'\\' * (level)}")
      [unquote, *parts, unquote].join
    end

    def scan_unquote(quote)
      str = scan(/[^#{quote}\\]+/)
      return str if str
      str = scan(/#{'\\' * level * 2}#{quote}/)
      ['\\' * (level - 1), quote].join if str
    end

    def space?
      peek(1) =~ SPACE
    end

    def paren?
      open.any? && peek(open.last.size) == open.last
    end

    def quote?
      quotes.any? && peek(quotes.last.size) == quotes.last
    end

    def level
      quotes.size
    end

    def quotes
      @quotes ||= []
    end

    def err(char)
      raise ParseError, "expected #{char} at position #{pos} in: #{string.inspect}"
    end
  end
end
