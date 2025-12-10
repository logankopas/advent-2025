defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  def input() do
    """
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +
    """
  end

  test "part1" do
    result = part1(input())

    assert result == 4277556
  end

  test "part2" do
    result = part2(input())

    assert result == 3263827
  end
end
