defmodule AdventOfCode.Day01 do
  def move_dial("L" <> count, current) do
    {int, ""} = Integer.parse(count)

    result = Integer.mod(current - int, 100)
    {result, result}
  end

  def move_dial("R" <> count, current) do
    {int, ""} = Integer.parse(count)

    result = Integer.mod(current + int, 100)
    {result, result}
  end


  def part1(args) do
    {results, _} = args 
      |> String.split()
      |> Enum.map_reduce(50, &move_dial/2)

    Enum.count(results, &(&1 == 0))

  end


  def move_dial_and_count("L" <> count, acc) do
    {int, ""} = Integer.parse(count)

    adjustment = if acc == 0, do: -1, else: 0

    stop = acc - int
    
    passes = stop - 100
      |> div(100)
      |> abs

    {passes + adjustment, Integer.mod(stop, 100)}

  end

  def move_dial_and_count("R" <> count, acc) do
    {int, ""} = Integer.parse(count)

    stop = acc + int
    
    passes = stop
      |> div(100)
      |> abs

    {passes, Integer.mod(stop, 100)}
  end

  def part2(args) do

    {results_list, _} = args 
      |> String.split()
      |> Enum.map_reduce(50, &move_dial_and_count/2)

    Enum.sum(results_list)

  end
end
