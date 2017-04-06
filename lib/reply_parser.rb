class ReplyParser
  SIG_REGEX = /(\u2014|--|__|-\\w)|(^Sent from my (\w+\s*){1,3})/
  QUOTE_HDR_REGEX = /^:etorw.*nO/
  MULTI_QUOTE_HDR = /(?!On.*On\s.+?wrote:)(On\s(.+?)wrote:)/
  QUOTED_REGEX = /(>+)/

  def initialize(email)
    @email = email
  end

  def self.parse(email)
    self.new(email).reply
  end

  def reply
    fix_multiline_quote_headers(@email)
      .lines
      .map { |line| line.chomp }
      .take_while { |line| not signature?(line) }
      .reject { |line| header? line }
      .reject { |line| quote? line }
      .reject(&:empty?)
      .reverse
      .drop_while { |line| line == "\n" }
      .reverse
      .join
  end

  private

    def header?(line)
      QUOTE_HDR_REGEX =~ line || MULTI_QUOTE_HDR.match(line)
    end

    def quote?(line)
      QUOTED_REGEX =~ line
    end

    def signature?(line)
      SIG_REGEX =~ line
    end

    def fix_multiline_quote_headers(email)
      pattern = /(?!On.*On\s.+?wrote:)(On\s(.+?)wrote:)/m
      email.gsub(pattern) { |match| match.gsub("\n", "") }
    end
end
