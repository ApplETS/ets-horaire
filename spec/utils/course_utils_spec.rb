require_relative "../../app/utils/course_utils"
require_relative "../../app/models/course"

CourseStruct = Struct.new(:name, :groups)

describe CourseUtils do

  describe "when deleting course duplicates" do
    let(:course_1) { Course.new("LOG640") }
    let(:course_2) { Course.new("LOG550") }
    let(:course_3) { Course.new("LOG320") }
    let(:course_4) { Course.new("LOG640") }
    let(:course_5) { Course.new("GIA400") }
    let(:courses) { [course_1, course_2, course_3, course_4, course_5] }
    let(:cleaned_courses) { CourseUtils.cleanup courses }

    it "should delete course duplicates by name" do
      cleaned_courses.should =~ [course_1, course_2, course_3, course_5]
    end
  end

end