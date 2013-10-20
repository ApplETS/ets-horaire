# -*- encoding : utf-8 -*-
require_relative "../../app/models/period"
require_relative "../../app/models/course"
require_relative "../../app/models/group"

describe Course do

  describe "when creating a course with no group" do
    let(:course) { Course.new("LOG640") }

    it "should retain its name" do
      course.name.should == "LOG640"
    end

    it "should have no groups" do
      course.groups.should be_empty
    end
  end

  describe "when specifying groups in the course" do

    describe "when providing unique group numbers" do
      let(:group_1) { Group.new(1) }
      let(:group_2) { Group.new(2) }
      let(:course) { Course.new("LOG640").with(group_1, group_2) }

      it "should retain the groups" do
        course.groups.should =~ [group_1, group_2]
      end
    end

    describe "when providing duplicate group numbers" do
      let(:group_1) { Group.new(1) }
      let(:group_1_duplicate) { Group.new(1) }

      it "should throw an exception" do
        expect { Course.new("LOG640").with(group_1, group_1_duplicate) }.to raise_error
      end
    end

  end

end
