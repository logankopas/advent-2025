defmodule AdventOfCode.Day04 do
  import AdventOfCode.Util2D

  def is_paper?(el) do
    el == ?@
  end

  def paper_with_neighbours_count(floor, row, col) do
    {{row, col}, Map.get(floor, {row, col})}
    if not is_paper?(Map.get(floor, {row, col})) do
      nil
    else
      get_neighbours(floor, row, col)
        |> Enum.filter(&is_paper?/1)
        |> Enum.count()
    end
  end

  def part1(args) do
    {floor, rows, columns} = input_to_2d_array(args)

    # display(floor, rows, columns)
    
    Enum.map(all_coordinates(rows, columns), fn {r, c} -> paper_with_neighbours_count(floor, r, c) end) 
    |> Enum.count(fn x -> x < 4 end)
  end

  def remove_rolls(floor, rows, columns) do
    starting_floor = floor
    
    new_map = all_coordinates(rows, columns)
      |> Enum.reduce(floor, fn {r, c}, map ->
        if is_paper?(Map.get(floor, {r, c})) and paper_with_neighbours_count(floor, r, c) < 4 do
          Map.put(map, {r, c}, ?.)
        else
          map
        end
      end)

    if new_map == starting_floor do
      new_map
    else
      remove_rolls(new_map, rows, columns)
    end
  end

  def count_papers(floor, rows, columns) do
    all_coordinates(rows, columns)
      |> Enum.filter(fn coords -> is_paper?(Map.get(floor, coords)) end)
      |> Enum.count()
  end

  def part2(args) do
    {floor, rows, columns} = input_to_2d_array(args)
    
    starting_count = count_papers(floor, rows, columns)
    # IO.puts("")
    # IO.puts("Count: #{starting_count}")
    # display(floor, rows, columns)
    # IO.puts("")

    new_map = remove_rolls(floor, rows, columns)
    new_count = count_papers(new_map, rows, columns)
    # IO.puts("Count: #{new_count}")
    # display(new_map, rows, columns)

    starting_count - new_count

  end
end
