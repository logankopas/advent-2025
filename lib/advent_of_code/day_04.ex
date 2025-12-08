defmodule AdventOfCode.Day04 do
  def input_to_2d_array(input) do
    charlists = input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    rows = Enum.count(charlists)
    columns = charlists
      |> Enum.at(1)
      |> Enum.count()

    array = charlists
      |> Enum.map(fn cl -> Enum.with_index(cl) end)
      |> Enum.with_index()
      |> Enum.map(&tuple_to_map/1)
      |> Enum.reduce(&Map.merge/2)

    {array, rows, columns}

  end

  defp tuple_to_map({ls, row}) do
    Map.new(ls, fn {char, col} -> {{row, col}, char} end)
  end

  def display(floor, rows, cols) do
    Enum.each(0..rows-1, fn r -> 
      Enum.each(0..cols-1, fn c ->
        Map.get(floor, {r, c})
          |> (&(IO.write("#{<<&1::utf8>>}"))).()
      end)
      IO.write("\n")
    end)

  end

  def all_coordinates(rows, columns) do
    for row <- 0..rows-1, col <- 0..columns-1, do: {row, col}
  end

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

  def get_neighbours(floor, row, col) do
    n = Map.get(floor, {row - 1, col})
    ne = Map.get(floor, {row - 1, col + 1})
    e = Map.get(floor, {row, col + 1})
    se = Map.get(floor, {row + 1, col + 1})
    s = Map.get(floor, {row + 1, col})
    sw = Map.get(floor, {row + 1, col - 1})
    w = Map.get(floor, {row, col - 1})
    nw = Map.get(floor, {row - 1, col - 1})

    [n, ne, e, se, s ,sw, w, nw]
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
