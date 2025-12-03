defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03
  def input() do
    """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """
  end

  test "part1" do
    result = part1(input())

    assert result == 357
  end

  test "part2" do
    result = part2(input())

    assert result == 3121910778619
  end
end
