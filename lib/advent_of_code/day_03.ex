defmodule AdventOfCode.Day03 do
    def digit_string_to_integer_list(digit_string) do
    digit_string
    |> String.to_charlist()
    |> Enum.map(fn char_code -> char_code - ?0 end)
  end

  def get_joltage_digit(_, 0, acc) do
    acc
  end
  def get_joltage_digit(bank_l, digits_left, acc) do
    sub_list = bank_l
      |> Enum.drop(-1 * (digits_left - 1))

    max_el = Enum.max(sub_list)
    max_idx = Enum.find_index(bank_l, fn x -> x == max_el end)
    new_l = Enum.slice(bank_l, (max_idx + 1)..-1//1)
    get_joltage_digit(new_l, digits_left-1, acc * 10 + max_el)
  end

  def joltage_for_bank(bank) do
    bank_l = bank 
      |>digit_string_to_integer_list()
    head_l = bank_l
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
    max_el = Enum.max(head_l)

    max_idx = Enum.find_index(bank_l, fn x -> x == max_el end)
    second_l = Enum.slice(bank_l, (max_idx+1)..-1//1)

    max_el_2 = Enum.max(second_l)

    (max_el * 10) + max_el_2


  end

  def part1(args) do
    bank = args
      |> String.split("\n", trim: true)
      |> Enum.map(&digit_string_to_integer_list/1)

    Enum.map(bank, fn x -> get_joltage_digit(x, 2, 0) end)
      |> Enum.sum()
  end

  def part2(args) do
    bank = args
      |> String.split("\n", trim: true)
      |> Enum.map(&digit_string_to_integer_list/1)

    Enum.map(bank, fn x -> get_joltage_digit(x, 12, 0) end)
      |> Enum.sum()
  end
end
