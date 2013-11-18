# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Course do
  describe "when creating a course with no group" do
    let(:course) { Course.new("LOG640", []) }

    specify { course.name.should eq("LOG640") }
    specify { course.groups.should be_empty }
  end

  describe "when specifying groups in the course" do
    describe "when providing unique group numbers" do
      let(:group_1) { double("GroupStruct", nb: 1) }
      let(:group_2) { double("GroupStruct", nb: 2) }
      let(:course) { Course.new("LOG640", [group_1, group_2]) }

      specify { course.groups.should =~ [group_1, group_2] }
    end

    describe "when providing duplicate group numbers" do
      let(:group_1) { double("GroupStruct", nb: 1) }
      let(:group_1_duplicate) { double("GroupStruct", nb: 1) }

      specify do
        expect { Course.new("LOG640", [group_1, group_1_duplicate]) }.to raise_error "All of the group numbers must be unique."
      end
    end
  end
end
