require_relative "../test_helper"

class TimerTest < Minitest::Test

  def test_we_can_parse_with_flexible_wording
    assert_equal 5.hours, Timer.parse_duration("blah (5h)")
    assert_equal 5.6.hours, Timer.parse_duration("blah (5.6h)")
    assert_equal 5.6.hours, Timer.parse_duration("blah (5.6 h)")
    assert_equal 5.6.hours, Timer.parse_duration("blah (5.6hrs)")
    assert_equal 5.6.hours, Timer.parse_duration("blah (5.6 hours)")
  end

  def test_we_can_parse_different_units
    assert_equal 10.minutes, Timer.parse_duration("blah (10m)")
    assert_equal 200.days, Timer.parse_duration("blah (200d)")
    assert_equal 3.weeks, Timer.parse_duration("blah (3w)")
  end

end
