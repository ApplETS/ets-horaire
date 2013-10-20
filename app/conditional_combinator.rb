# -*- encoding : utf-8 -*-

class ConditionalCombinator
  class << self
    def find_combinations(values, set_size, &block)
      combinations = loop_through(values, 0, values.size - set_size, [], &block)
      combinations.keep_if { |combination| combination.size == set_size }
    end

    private

    def loop_through(values, from_index, to_index, combination_stack, &block)
      if end_of_possibility_stack?(to_index, values)
        add_to_possibilities(values[from_index..to_index], combination_stack, &block)
      else
        continue_through_possibilities(values, from_index, to_index, combination_stack, &block)
      end
    end

    def end_of_possibility_stack?(to_index, values)
      to_index == values.size - 1
    end

    def add_to_possibilities(values, combination_stack, &block)
      values.collect { |value| add_if_yield(combination_stack, value, &block) }
    end

    def continue_through_possibilities(values, from_index, to_index, combination_stack, &block)
      combination_stack = values[from_index..to_index].each_with_index.collect do |value, index|
        combination_stack_duplicate = add_if_yield(combination_stack, value, &block)
        loop_through(values, from_index + index + 1, to_index + 1, combination_stack_duplicate, &block)
      end
      combination_stack.flatten(1)
    end

    def add_if_yield(combination_stack, value, &block)
      combination_stack_duplicate = combination_stack.dup
      combination_stack_duplicate << value if yield(combination_stack_duplicate, value)
      combination_stack_duplicate
    end
  end
end
