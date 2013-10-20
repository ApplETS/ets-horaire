# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "support/matchers/combination_matchers" do

  describe "when checking for valid combinations" do
    it "should pass" do
      [1, 2 ,3].combination(2).to_a.should match_arrays([2, 1], [3, 1], [2, 3])
      [1, 2 ,3].combination(2).to_a.should match_arrays([1, 2], [3, 1], [2, 3])
      [1, 2 ,3].combination(2).to_a.should match_arrays([2, 3], [1, 2], [3, 1])

      [1, 2, 3, 4].combination(2).to_a.should match_arrays([4, 1], [1, 2], [1, 3], [2, 3], [2, 4], [3, 4])
      [1, 2, 3, 4, 4].combination(2).to_a.should match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3, 4], [4, 4])

      [1, 2, 3, 4].combination(3).to_a.should match_arrays([1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4])
      [1, 2, 3, 4].combination(3).to_a.should match_arrays([1, 2, 4], [1, 2, 3], [1, 3, 4], [2, 3, 4])

      [1, 2, 3, 4].combination(4).to_a.should match_arrays([1, 2, 3, 4])
      [1, 2, 3, 4].combination(4).to_a.should match_arrays([1, 2, 4, 3])
    end
  end

  describe "when checking for invalid combinations" do
    it "should fail" do
      [1, 2, 3].combination(2).to_a.should_not match_arrays([2, 1], [3, 1], [2, 3], [2, 3])

      [1, 2, 3, 4, 4].combination(2).to_a.should_not match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3], [4, 4])
      [1, 2, 3, 4, 4].combination(2).to_a.should_not match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [], [4, 4])

      [1, 2, 3, 4].combination(3).to_a.should_not match_arrays([1, 2, 4], [1, 2, 3], [1, 3, 4])
      [1, 2, 3, 4].combination(3).to_a.should_not match_arrays([1, 2, 4], [1, 2, 3], [1, 3, 4, 4])
      [1, 2, 3, 4].combination(3).to_a.should_not match_arrays([1, 2, 3], [1, 2, 4], [5, 3, 4], [2, 3, 4])

      [1, 2, 3, 4].combination(4).to_a.should_not match_arrays([1, 2, 3, 4, 4])

      [[1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3], [4, 4]].should_not match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3, 4], [4, 4])
      [[1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [], [4, 4]].should_not match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3, 4], [4, 4])
    end
  end

end
