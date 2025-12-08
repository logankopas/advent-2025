defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  def input() do
    """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
  end

  test "part1" do
    input = nil
    result = part1(input)

    assert result == 3
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
