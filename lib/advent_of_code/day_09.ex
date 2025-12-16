defmodule AdventOfCode.Day09 do
  def part1(args) do
    tiles = args
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        x
          |> String.split(",") 
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
      end)

    tiles
      |> Enum.map(fn tile ->
          Enum.map(tiles, fn other_tile ->
            {x1, y1} = tile
            {x2, y2} = other_tile
            abs(x2-x1+1) * abs(y2-y1+1)
          end)
          |> Enum.max()
        end)
      |> Enum.max()
  end

  def crosses_edge?(v, edge) do
    # raycasting at 45 degrees
    edge
    {{start_row, start_col}, {end_row, end_col}} = edge 
    {v_row, v_col} = v

    # ray formula is y = x + v_b
    v_b = v_col - v_row

    if start_row == end_row do
      # line formula: x = start_row
      y_point = start_row + v_b
      x_point = y_point - v_b

      (y_point >= min(start_col, end_col) && y_point <= max(start_col, end_col)
        && ! (x_point == start_row && y_point == start_col)  # only direct intersections of the 2nd edge-vertex count
        && x_point <= v_row && y_point <= v_col  # ray only goes in one direction
      )

    else
      # line formula: y = start_col
      x_point = start_col - v_b
      y_point = x_point + v_b

      (x_point >= min(start_row, end_row) && x_point <= max(start_row, end_row) 
        && ! (x_point == start_row && y_point == start_col)  # only direct intersections of the 2nd edge-vertex count
        && x_point <= v_row && y_point <= v_col  # ray only goes in one direction
      )

    end
  end

  def crosses_edge_count(vertex, edges) do
    edges
      |> Enum.map(fn edge -> crosses_edge?(vertex, edge) end)
      |> Enum.count(fn e -> e end)
  end

  def point_on_edge?(v, edge) do
    {v_x, v_y} = v
    {{ex1, ey1}, {ex2, ey2}} = edge
    
    (
      v_x >= min(ex1, ex2) &&  v_x <= max(ex1, ex2)
      &&
      v_y >= min(ey1, ey2) && v_y <= max(ey1, ey2)
    )
  end

  def inside?(vertex, edges, vertices) do
    (
      Enum.member?(vertices, vertex) or
      Enum.any?(edges, fn e -> point_on_edge?(vertex, e) end) or
      rem(crosses_edge_count(vertex, edges), 2) != 0
    )
  end


  def edge_is_unbroken?(rect_edge, edges) do
    {{start_row, start_col}, {end_row, end_col}} = rect_edge
    if start_row == end_row do
      # vertical (x/y) case
      # rect edge is x = start_row
      edges 
        |> Enum.all?(fn edge -> 
          {{edge_x1, edge_y1}, {edge_x2, edge_y2}} = edge
          if edge_x1 == edge_x2 do
            # vertical edges will never overlap with vertical edges
            true
          else
            # edge formula is y = edge_y
            x_point = start_row
            y_point = edge_y1

            (
              (y_point <= min(start_col, end_col) || y_point >= max(start_col, end_col))  # intersection outside of rect edge
              || (x_point <= min(edge_x1, edge_x2) || (x_point >= max(edge_x1, edge_x2)))
            )

          end

        end)
    else
      # horizontal (x/y) case
      # rect edge is y = start_col
      edges 
        |> Enum.all?(fn edge -> 
          {{edge_x1, edge_y1}, {edge_x2, edge_y2}} = edge
          if edge_y1 == edge_y2 do
            # horizontal edges will never overlap with horizontal edges
            true
          else
            # edge formula is x = edge_x
            y_point = start_col
            x_point = edge_x1

            (
              (x_point <= min(start_row, end_row) || x_point >= max(start_row, end_col))  # intersection outside of rect edge
              || (y_point <= min(edge_y1, edge_y2) || (y_point >= max(edge_y1, edge_y2)))
            )

          end

        end)
    end

  end


  def part2(args) do
    tiles = args
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        x
          |> String.split(",") 
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
      end)
    edges = tiles
      |> Enum.with_index(fn el, ix -> {ix, el} end)
      |> Enum.map(fn {ix, v} ->
          {v, Enum.at(tiles, ix - 1)}
        end)


    tiles
      |> Enum.map(fn tile ->
          Enum.map(tiles, fn other_tile ->
            {x1, y1} = tile
            {x2, y2} = other_tile
            vertices = [{x1, y1}, {x2, y1}, {x1, y2}, {x2, y2}]
            rect_edges = [
              {{x1, max(y1, y2) - 0.1}, {x2, max(y1, y2) - 0.1}},  # top (x/y) edge
              {{x1, min(y1, y2) + 0.1}, {x2, min(y1, y2) + 0.1}},  # bottom (x/y) edge
              {{min(x1, x2) + 0.1, y1}, {min(x1, x2) + 0.1, y2}},  # left (x/y) edge
              {{max(x1, x2) - 0.1, y1}, {max(x1, x2) - 0.1, y2}},  # right (x/y) edge
            ]
            if (
              Enum.all?(vertices, fn v -> inside?(v, edges, tiles) end)
              && Enum.all?(rect_edges, fn e -> edge_is_unbroken?(e, edges) end) 
            ) do
              (abs(x2-x1)+1) * (abs(y2-y1)+1)
            else
              0
            end
          end)
          |> Enum.max()
        end)
      |> Enum.max()

  end
end
