defmodule AdventOfCode.Day07 do
  import AdventOfCode.Util2D
  
  def beam_starting_column(map, _rows, columns) do
    Enum.find(0..columns - 1, fn c -> ?S == Map.get(map, {0, c}) end)

  end

  def iterate_beam_levels(_map, rows, _columns, cur_row, _beams, level_counts) when cur_row == rows do
    level_counts
  end

  def iterate_beam_levels(map, rows, columns, cur_row, beams, level_counts) do
    new_beams = Enum.reduce(beams, [], fn b, acc ->
      char = Map.get(map, {cur_row, b})
      if char == ?^ do
        [b - 1, b + 1 | acc]
      else
        [b | acc]
      end

    end)

    split_count = Enum.count(new_beams) - Enum.count(beams)

    new_beams = Enum.uniq(new_beams)

    new_map = Enum.reduce(new_beams, map, fn beam, acc ->
      Map.put(acc, {cur_row, beam}, ?|)
    end)
    iterate_beam_levels(new_map, rows, columns, cur_row + 1, new_beams, [split_count | level_counts])
  end



  def part1(args) do
    {map, rows, columns} = input_to_2d_array(args)


    beam_col = beam_starting_column(map, rows, columns)
    map = Map.put(map, {0, beam_col}, ?|)
    iterate_beam_levels(map, rows, columns, 1, [beam_col], [])
      |> Enum.sum()
  end


  def merge_counts(counts) do
    Enum.reduce(counts, %{}, fn x, acc ->
      Map.merge(x, acc, fn _k, v1, v2 -> v1+v2 end)
    end)
  end

  def iterate_beam_levels_p2(_map, rows, _columns, cur_row, _beams, level_counts) when cur_row == rows do
    level_counts
  end
  def iterate_beam_levels_p2(map, rows, columns, cur_row, beams, level_counts) do
    new_counts = Enum.reduce(beams, [], fn b, acc ->
      char = Map.get(map, {cur_row, b})
      beam_count = Map.get(level_counts, b)
      if char == ?^ do

        [%{b - 1 => beam_count}, %{b + 1 => beam_count} | acc]
      else
        [%{b => beam_count} | acc]
      end

    end)

    level_count = merge_counts(new_counts)

    new_beams = Map.keys(level_count)

    new_map = Enum.reduce(new_beams, map, fn beam, acc ->
      Map.put(acc, {cur_row, beam}, ?|)
    end)

    # new_counts = merged_counts
    iterate_beam_levels_p2(new_map, rows, columns, cur_row + 1, new_beams, level_count)
  end

  def part2(args) do
    {map, rows, columns} = input_to_2d_array(args)


    beam_col = beam_starting_column(map, rows, columns)
    map = Map.put(map, {0, beam_col}, ?|)
    iterate_beam_levels_p2(map, rows, columns, 1, [beam_col], %{beam_col => 1})  # Add 1 for starting universe
      |> Map.values()
      |> Enum.sum()
  end
end
