require_relative "../../app/builders/course_builder"

CourseStruct = Struct.new(:name, :groups) if !defined?(CourseStruct)

describe CourseBuilder do

  describe "when building a course from a struct" do
    describe "when passing a simple course struct with no group" do
      let(:course_struct) { CourseStruct.new("LOG640", []) }
      let(:course) { CourseBuilder.build(course_struct) }

      it "should match the course struct name" do
        course.name.should == "LOG640"
      end

      it "should build a course object with no group" do
        course.groups.should be_empty
      end
    end

    describe "when passing a course with a single group" do
      let(:group_struct) { mock(Object) }
      let(:group) { mock(Object) }
      let(:course_struct) { CourseStruct.new("LOG320", [group_struct]) }

      before(:each) do
        GroupBuilder.stub!(:build).and_return group
        @course = CourseBuilder.build(course_struct)
      end

      it "should invoke the group builder once" do
        GroupBuilder.should_receive(:build).once.with(group_struct)
        CourseBuilder.build(course_struct)
      end

      it "should build a course object with a single group" do
        @course.groups.size.should == 1
      end

      it "should be the appropriate group" do
        @course.groups[0].should == group
      end
    end
  end
  
end