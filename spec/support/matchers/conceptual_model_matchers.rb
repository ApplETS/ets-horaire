# -*- encoding : utf-8 -*-
RSpec::Matchers.define :conceptually_include do |*expected_groups|
  match do |schedules|
    schedules.one? do |actual_groups|
      groups_conceptually_match? expected_groups, actual_groups
    end
  end
end

private

def groups_conceptually_match?(expected_groups, actual_groups)
  actual_groups.all? do |actual_group|
    expected_groups.one? do |expected_group|
      group_conceptually_matches?(expected_group, actual_group)
    end
  end
end

def group_conceptually_matches?(expected_group, actual_group)
  expected_group.nb == actual_group.nb &&
  expected_group.periods.size == actual_group.periods.size &&
  periods_conceptually_match?(expected_group, actual_group)
end

def periods_conceptually_match?(expected_group, actual_group)
  actual_group.periods.all? do |actual_period|
    expected_group.periods.one? do |expected_period|
      period_conceptually_matches?(expected_period, actual_period)
    end
  end
end

def period_conceptually_matches?(expected_period, actual_period)
  expected_period.weekday == actual_period.weekday &&
  expected_period.type == actual_period.type &&
  expected_period.start_time == actual_period.start_time &&
  expected_period.end_time == actual_period.end_time
end
