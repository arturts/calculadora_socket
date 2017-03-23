class Parser
  class << self
    INFIX_BINARY_OP_REGEX = /\A(\d+)\s*([\+\-\*\/])\s*(\d+)\Z/.freeze

    def parse(message)
      if match = INFIX_BINARY_OP_REGEX.match(message)
        match.captures
      else
        raise "Couldn't understand \"#{message}\"."
      end
    end
  end
end
