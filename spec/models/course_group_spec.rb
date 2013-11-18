# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CourseGroup do

  describe "when creating a group" do
    let(:periods) { [double(Period), double(Period)] }
    let(:group) { CourseGroup.new("LOG640", periods, 2) }

    specify { group.course_name.should eq("LOG640") }
    specify { group.nb.should eq(2) }
    specify { group.periods.should eq(periods) }
  end

  describe "when checking for conflicting periods" do
    describe "when comparing two groups that have no conflicting periods" do
      describe "when the groups have course names that differ" do
        let(:lecture_1) { double(Period) }
        let(:lecture_2) { double(Period) }
        let(:group_1) { CourseGroup.new("LOG320", [lecture_1], 1)  }
        let(:group_2) { CourseGroup.new("LOG330", [lecture_2], 2) }

        before(:each) do
          lecture_1.stub(:conflicts?).with(lecture_2).and_return false
          lecture_2.stub(:conflicts?).with(lecture_1).and_return false
        end

        specify do
          group_1.conflicts?(group_2).should be_false
          group_2.conflicts?(group_1).should be_false
        end
      end

      describe "when the groups have the same course names" do
        let(:group_1) { CourseGroup.new("LOG640", [], 1)  }
        let(:group_2) { CourseGroup.new("LOG640", [], 2) }

        specify do
          group_1.conflicts?(group_2).should be_true
          group_2.conflicts?(group_1).should be_true
        end
      end
    end

    describe "when comparing two groups that have conflicting periods" do
      let(:lecture_1) { double(Period) }
      let(:lecture_2) { double(Period) }
      let(:group_1) { CourseGroup.new("LOG550", [lecture_1], 1)  }
      let(:group_2) { CourseGroup.new("GIA400", [lecture_2], 2) }

      before(:each) do
        lecture_1.stub(:conflicts?).with(lecture_2).and_return true
        lecture_2.stub(:conflicts?).with(lecture_1).and_return true
      end

      specify do
        group_1.conflicts?(group_2).should be_true
        group_2.conflicts?(group_1).should be_true
      end
    end
  end
end
