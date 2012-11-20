class ConditionalCombinator

  def self.find_combinations(values, set_size, &block)
    loop_through(values, 0, values.size - set_size, [], &block).delete_if { |combination| combination.size != set_size }
  end

  private

  def self.loop_through(values, from_index, to_index, combination_stack, &block)
    if end_of_possibility_stack?(to_index, values)
      add_to_possibilities(values[from_index..to_index], combination_stack, &block)
    else
      continue_through_possibilities(values, from_index, to_index, combination_stack, &block)
    end
  end

  def self.end_of_possibility_stack?(to_index, values)
    to_index == values.size - 1
  end

  def self.add_to_possibilities(values, combination_stack)
    combinations = values.collect { |value| combination_stack.dup << value if yield(combination_stack, value) }
    combinations.delete_if { |combination| combination.nil? }
  end

  def self.continue_through_possibilities(values, from_index, to_index, combination_stack, &block)
    values[from_index..to_index].each_with_index.collect do |value, index|
      combination_stack_duplicate = combination_stack.dup
      combination_stack_duplicate << value if yield(combination_stack, value)
      loop_through(values, from_index + index + 1, to_index + 1, combination_stack_duplicate, &block)
    end.flatten(1)
  end

end