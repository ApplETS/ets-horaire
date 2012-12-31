require_relative "../../app/models/group"
require_relative "../../app/models/period"

describe Group do

  describe "when creating a simple group with no periods" do
    let(:group) { Group.new(3) }

    it "should keep its group number" do
      group.nb.should == 3
    end

    it "should have no periods" do
      group.periods.should be_empty
    end
  end

  describe "when creating a group with specific periods" do
    let(:lecture) { Period::on("monday", "Cours").from("18:00").to("21:00") }
    let(:practical_work) { Period::on("friday", "TP").from("18:00").to("21:00") }
    let(:group) { Group.new(1).with lecture, practical_work }

    it "should return the appropriate periods" do
      group.periods.should =~ [lecture, practical_work]
    end
  end

end