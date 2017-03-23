class Calculator
  def calculate(first_operand, operator, second_operand)
    if [:+, :-, :*, :/].include?(operator = operator.to_sym)
      first_operand, second_operand =
        [first_operand, second_operand].map { |number| Float(number) }

      operator.to_proc.call(first_operand, second_operand)
    else
      raise "Only +, -, * and / operators are available."
    end
  rescue ArgumentError
    raise "Operands must be numbers."
  end
end
