defmodule AdventOfCode.Util2D do
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

end
