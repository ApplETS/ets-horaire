# -*- encoding : utf-8 -*-
RSpec::Matchers.define :match_arrays do |*expected_arrays|
  match do |actual_arrays|
    expected_arrays_duplicate = expected_arrays.dup
    actual_arrays_duplicate = actual_arrays.dup

    actual_arrays.each do |actual_values|
      expected_arrays_duplicate.delete_if { |expected_values| arrays_match?(actual_values, expected_values) }
    end

    expected_arrays.each do |expected_values|
      actual_arrays_duplicate.delete_if { |actual_values| arrays_match?(actual_values, expected_values) }
    end

    array_sizes_match?(expected_arrays, actual_arrays) && expected_arrays_duplicate.size == 0 && actual_arrays_duplicate.size == 0
  end
end

private

def arrays_match?(first_array, second_array)
  array_sizes_match?(first_array, second_array) && (first_array - second_array).size == 0
end

def array_sizes_match?(first_array, second_array)
  first_array.size == second_array.size
end
