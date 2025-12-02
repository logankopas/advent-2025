defmodule AdventOfCode.Day02 do
  def is_duplicated?(str) when is_bitstring(str) do
    length = String.length(str)
    if Integer.mod(length, 2) == 1 do
      false
    else 
      half = String.slice(str, 0, div(length, 2))
      half <> half == str
    end
  end
  def is_duplicated?(int) when is_integer(int) do
    Integer.to_string(int) |> is_duplicated?()
  end


  def str_to_range(str) do
    [ first_ , last_ ] = String.split(str, "-", parts: 2)

    {first, ""} = Integer.parse(first_)
    {last, _} = Integer.parse(last_)  # allow newline


    first..last
  end

  def get_duplicates_in_range(range) do

    Enum.filter(range, &is_duplicated?/1)
  end

  def is_multiduplicated?(int) when is_integer(int) do
    Integer.to_string(int) |> is_multiduplicated?()
  end
  def is_multiduplicated?(str) when is_bitstring(str) do
    length = String.length(str)
    if length == 1 do
      false
    else
      half_length = div(length, 2)
      substrings = Enum.map(1..half_length, &(String.slice(str, 0, &1)) )
      substrings
        |> Enum.map(&(string_made_of_groups?(&1, str)))
        |> Enum.any?()
    end
  end

  def string_made_of_groups?(group, str) do
    String.replace(str, group, "") == ""
  end

  def get_multiduplicates_in_range(range) do
    Enum.filter(range, &is_multiduplicated?/1) 
  end


  def part1(args) do

    str_ranges = args 
      |> String.split(",")

    ranges = Enum.map(str_ranges, &str_to_range/1)

    invalid_products = Enum.flat_map(ranges, &get_duplicates_in_range/1)
    Enum.sum(invalid_products)

  end

  def part2(args) do
    str_ranges = args 
      |> String.split(",")

    ranges = Enum.map(str_ranges, &str_to_range/1)

    invalid_products = Enum.flat_map(ranges, &get_multiduplicates_in_range/1)
    Enum.sum(invalid_products)
  end
end
