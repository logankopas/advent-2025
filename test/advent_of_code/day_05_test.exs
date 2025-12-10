defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  def input() do
    """
    3-3
    10-14
    16-20
    10-20
    12-18
    3-5

    1
    5
    8
    11
    17
    32
    """
  end

  test "part1" do
    result = part1(input())

    assert result == 3
  end

  test "part2" do
    result = part2(input())

    assert result == 14
  end
end
