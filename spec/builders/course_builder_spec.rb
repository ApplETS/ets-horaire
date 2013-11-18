# -*- encoding : utf-8 -*-

require 'spec_helper'

describe CourseBuilder do
  CourseStruct = Struct.new(:name, :groups)

  describe :build do
    context 'when passing in a course struct' do
      let(:course_name) { 'LOG120' }
      let(:a_group_struct) {double(Struct) }
      let(:another_group_struct) {double(Struct) }
      let(:struct_group) { [a_group_struct, another_group_struct] }
      let(:course_struct) { CourseStruct.new(course_name, struct_group) }

      let(:a_group) { double(Group) }
      let(:another_group) { double(Group) }
      let(:group) { [a_group, another_group] }
      let(:course) { double(Course) }

      before(:each) do
        GroupBuilder.stub(:build).once.with(a_group_struct).and_return a_group
        GroupBuilder.stub(:build).once.with(another_group_struct).and_return another_group
        Course.stub(:new).once.with(course_name, group).and_return course
      end

      specify { CourseBuilder.build(course_struct).should eq(course) }
    end
  end
end
