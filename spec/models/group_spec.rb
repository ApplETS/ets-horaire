# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Group do
  describe "when creating a group with specific periods" do
    let(:lecture) { double(Period) }
    let(:practical_work) { double(Period) }
    let(:group) { Group.new(3, [lecture, practical_work]) }

    specify { group.nb.should eq(3) }
    specify { group.periods.should =~ [lecture, practical_work] }
  end
end
