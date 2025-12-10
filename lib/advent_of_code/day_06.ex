defmodule AdventOfCode.Day06 do
  def do_math(tuple) do
    Tuple.to_list(tuple)
      |> Enum.reduce([], fn x, ls ->
        case x do
          "*" -> Enum.product(ls)
          "+" -> Enum.sum(ls)
          x -> 
            {int, ""} = Integer.parse(x) 
            [int | ls]
        end
      end)
  end

  def part1(args) do
    args
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x) end)
      |> Enum.zip()
      |> Enum.map(&do_math/1)
      |> Enum.sum()

  end

  def all_spaces?(str) do
    str_len = Enum.count(str)
    to_string(str) == String.duplicate(" ", str_len)
  end

  def compute_formula(tuples) do
    [f| _] = tuples
    operand = f
      |> Enum.reverse()
      |> hd()

    agg_fn = case operand do
      ?* -> &Enum.product/1
      ?+ -> &Enum.sum/1
    end

    ints = tuples
      |> Enum.map(fn x ->
        n = to_string(x)
          |> String.trim_leading()
        {i, _} = Integer.parse(n)
        i
      end)

    agg_fn.(ints)

  end

  def do_cephalopod_math([], acc) do
    acc
  end
  def do_cephalopod_math(tuples, acc) do
    {formula, formulas} = Enum.split_while(tuples, &(!all_spaces?(&1)))

    total = formula
      |> compute_formula()

    formulas
      |> Enum.drop_while(&all_spaces?/1)
      |> do_cephalopod_math([total | acc])

  end

  def right_pad_string(str) do
    str <> "          "
  end

  def part2(args) do
    args
      |> String.split("\n", trim: true)
      |> Enum.map(&right_pad_string/1)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> do_cephalopod_math([])
      |> Enum.sum()

  end
end
