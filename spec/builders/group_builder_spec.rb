require_relative "../../app/builders/group_builder"

GroupStruct = Struct.new(:nb, :periods)

describe GroupBuilder do

  describe "when building a group with no periods" do
    let(:group_struct) { GroupStruct.new 6, [] }
    let(:group) { GroupBuilder.build group_struct }

    it "should match the group struct number" do
      group.nb.should == 6
    end

    it "should have no periods" do
      group.periods.should be_empty
    end
  end

  describe "when building a group with one period" do
    let(:period_struct) { mock(Object) }
    let(:period) { mock(Object) }
    let(:group_struct) { GroupStruct.new 12, [period_struct] }

    before(:each) do
      PeriodBuilder.stub!(:build).and_return period
      @group = GroupBuilder.build group_struct
    end

    it "should invoke the period builder once" do
      PeriodBuilder.should_receive(:build).once.with(period_struct).and_return period
      GroupBuilder.build group_struct
    end

    it "should have one period" do
      @group.periods.size.should == 1
    end

    it "should be the appropriate period" do
      @group.periods[0].should == period
    end
  end

end