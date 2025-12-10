defmodule AdventOfCode.Day05 do
  def ranges_to_list(fresh_ranges) do
    fresh_ranges
      |> Enum.reduce([], fn x, ls ->
        [low_str, high_str] = String.split(x, "-")
        {low, _} = Integer.parse(low_str)
        {high, _} = Integer.parse(high_str)

        if low > high do
          raise "woops"
        end
        [{low, high} | ls]
        end)
  end

  def inventory_strs_to_int_list(strs) do
    strs 
      |> Enum.map(fn x ->
        if x != "" do
          {i, _} = Integer.parse(x)
          i
        else
          nil
        end
      end)
      |> Enum.filter(& !is_nil(&1))
  end

  def is_fresh?(product, fresh_set) do
    fresh_set
      |> Enum.any?(fn {l, h} -> product >= l and product <= h end)
  end

  def part1(args) do
    {fresh_ids, inventory_ids} = args 
      |> String.split("\n")
      |> Enum.split_while(fn x -> x != "" end)

    fresh_set = ranges_to_list(fresh_ids)

    inventory = inventory_strs_to_int_list(inventory_ids)

    inventory
      |> Enum.filter(fn x -> is_fresh?(x, fresh_set) end)
      |> Enum.count()
  end

  def combine_ranges(ranges) do
    starting_list = ranges

    combined_range_list = ranges
      |> Enum.reduce(ranges, fn iter, acc ->
          Enum.flat_map(acc, fn comparison ->
            {l1, h1} = iter
            {l2, h2} = comparison
            
            super_range = case {l1, l2, h1, h2} do
              # Fully disjointed case
              {l1, l2, h1, h2} when h1 < l2 or l1 > h2 -> [{l2, h2}]

              # Any overlap at all case
              _ -> [{min(l1, l2), max(h1, h2)}] 
            end
            super_range

          end)
          

        end)
      |> Enum.uniq()

    if Enum.sort(starting_list) == Enum.sort(combined_range_list) do
      combined_range_list
    else
      combine_ranges(combined_range_list)
    end

  end

  def part2(args) do
    {fresh_ids, _} = args 
      |> String.split("\n")
      |> Enum.split_while(fn x -> x != "" end)

    ranges_to_list(fresh_ids)
      |> combine_ranges()
      |> Enum.reduce(0, fn {low, high}, acc -> acc + (high - low) + 1 end)
  end
end
