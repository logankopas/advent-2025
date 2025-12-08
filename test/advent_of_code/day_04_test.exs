defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  def input() do
    """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
  end

  test "part1" do
    result = part1(input())

    assert result == 13
  end

  test "part2" do
    result = part2(input())

    assert result == 43
  end
end
