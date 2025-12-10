defmodule AdventOfCode.Day08 do

  def parse_int(str) do
    {int, _} = Integer.parse(str)
    int
  end

  def str_to_tuple(str) do
    str
      |> String.split(",")
      |> Enum.map(&parse_int/1)
      |> List.to_tuple()
  end

  def euclidian_distance(j1, j2) do
    ( (elem(j1, 0) - elem(j2, 0))**2 + (elem(j1, 1) - elem(j2, 1))**2 + (elem(j1, 2) - elem(j2, 2))**2 ) ** 0.5
  end

  def compute_adjacency_matrix(junctions) do
    junctions
      |> Enum.reduce(Map.new(), fn j1, mat ->

        j1_adjacencies = junctions
          |> Enum.reduce(Map.new(), fn j2, inner_mat ->
          if j1 == j2 do
            inner_mat
          else
            if Map.has_key?(mat, {j2, j1}) do
              inner_mat
            else
              Map.put(inner_mat, {j1, j2}, euclidian_distance(j1, j2))
            end
          end

        end)

        Map.merge(mat, j1_adjacencies)
      end)
  end

  def join_circuits(j1, j2, circuit_list) do
    circuit_1 = Map.fetch!(circuit_list, j1)
    circuit_2 = Map.fetch!(circuit_list, j2)


    if circuit_1 == circuit_2 do
      circuit_list
    else
      circuit_list
        |> Map.keys()
        |> Enum.reduce(circuit_list, fn k, circuits ->
          if Map.fetch!(circuits, k) == circuit_2 do
            Map.put(circuits, k, circuit_1)
          else
            circuits
          end
        end)
    end
  end

  def part1(args) do
    n_boxes = args
      |> String.split("\n", trim: true)
      |> Enum.count()
    connections_to_make = if n_boxes == 20 do 10 else 1000 end

    junction_boxes = args
      |> String.split("\n", trim: true)
      |> Enum.map(&str_to_tuple/1)

    adjacency_matrix = junction_boxes
      |> compute_adjacency_matrix()
      |> Enum.to_list()
      |> Enum.sort_by(&(elem(&1, 1)), :asc)

    nodes_to_join = adjacency_matrix
      |> Enum.take(connections_to_make)

    circuit_list = junction_boxes
      |> Enum.with_index()
      |> Map.new()

    joined_circuits = nodes_to_join
      |> Enum.reduce(circuit_list, fn {{j1, j2}, _distance}, circuits ->
        join_circuits(j1, j2, circuits)
      end)

    joined_circuits
      |> Map.values()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.product()
  end

  def single_circuit?(circuit_map) do

    1 == circuit_map
      |> Map.values()
      |> Enum.uniq()
      |> Enum.count()
  end

  def join_circuits_until_connected(junction_list, circuit_list) do
    junction_list
      |> Enum.reduce_while(circuit_list, fn {{j1, j2}, _distance}, circuits ->
        circuit_1 = Map.fetch!(circuits, j1)
        circuit_2 = Map.fetch!(circuits, j2)


        new_circuit_list = if circuit_1 == circuit_2 do
          circuits
        else 
          update_circuits(circuits, circuit_1, circuit_2)
        end
        
        if single_circuit?(new_circuit_list) do
          {:halt, {j1, j2}}
        else
          {:cont, new_circuit_list}
        end
      end)

  end

  def update_circuits(circuit_list, from, to) do
    circuit_list
      |> Map.keys()
      |> Enum.reduce(circuit_list, fn k, circuits ->
        if Map.fetch!(circuits, k) == from do
          Map.put(circuits, k, to)
        else
          circuits
        end
      end)
  end

  def part2(args) do
    junction_boxes = args
      |> String.split("\n", trim: true)
      |> Enum.map(&str_to_tuple/1)

    adjacency_matrix = junction_boxes
      |> compute_adjacency_matrix()
      |> Enum.to_list()
      |> Enum.sort_by(&(elem(&1, 1)), :asc)

    nodes_to_join = adjacency_matrix

    circuit_list = junction_boxes
      |> Enum.with_index()
      |> Map.new()

    {{x1, _, _}, {x2, _, _}} = join_circuits_until_connected(nodes_to_join, circuit_list)

    x1 * x2


  end
end
