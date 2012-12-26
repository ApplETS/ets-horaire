require_relative "../../app/builders/course_builder"

CourseStruct = Struct.new(:name, :groups)
GroupStruct = Struct.new(:nb, :periods)
PeriodStruct = Struct.new(:weekday, :start_time, :end_time, :type)

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

    describe "when building an elaborate course" do
      let(:course_1_5_struct) { PeriodStruct.new("lun", "20h00", "21h00", "Cours") }
      let(:group_5_struct) { GroupStruct.new(5, [course_1_5_struct]) }
      let(:group_9_struct) { GroupStruct.new(9, []) }
      let(:course_1_12_struct) { PeriodStruct.new("mar", "6h00", "11h00", "TP") }
      let(:course_2_12_struct) { PeriodStruct.new("ven", "13h00", "16h00", "Lab") }
      let(:group_12_struct) { GroupStruct.new(12, [course_1_12_struct, course_2_12_struct]) }
      let(:course_struct) { CourseStruct.new("LOG320", [group_5_struct, group_9_struct, group_12_struct]) }

      let(:course) { CourseBuilder.build course_struct }

      let(:group_5) { course.groups[0] }
      let(:course_1_5) { group_5.periods[0] }
      let(:group_9) { course.groups[1] }
      let(:group_12) { course.groups[2] }
      let(:course_1_12) { group_12.periods[0] }
      let(:course_2_12) { group_12.periods[1] }

      it "should build a course with LOG320 as its name" do
        course.name.should == "LOG320"
      end

      it "should build a course object with a three groups" do
        course.groups.should have_exactly(3).items
      end

      it "should have a group 5" do
        group_5.nb.should == 5
      end

      it "should have one period for group 5" do
        group_5.periods.should have_exactly(1).times
      end

      it "should have group 5 firsts period on monday" do
        course_1_5.weekday.should == "monday"
      end

      it "should have group 5 firsts period start at 20h" do
        course_1_5.start_time.should == "20h00"
      end

      it "should have group 5 firsts period end at 21h" do
        course_1_5.end_time.should == "21h00"
      end

      it "should have a group 9" do
        group_9.nb.should == 9
      end

      it "should have no period for group 9" do
        group_9.periods.should be_empty
      end

      it "should have a group 12" do
        group_12.nb.should == 12
      end

      it "should have two periods for group 12" do
        group_12.periods.should have_exactly(2).times
      end

      it "should have group 12 firsts period on tuesday" do
        course_1_12.weekday.should == "tuesday"
      end

      it "should have group 12 firsts period start at 6h" do
        course_1_12.start_time.should == "6h00"
      end

      it "should have group 12 firsts period end at 11h" do
        course_1_12.end_time.should == "11h00"
      end

      it "should have group 12 second period on friday" do
        course_2_12.weekday.should == "friday"
      end

      it "should have group 12 second period start at 13h" do
        course_2_12.start_time.should == "13h00"
      end

      it "should have group 12 second period end at 16h" do
        course_2_12.end_time.should == "16h00"
      end
    end
  end
  
end