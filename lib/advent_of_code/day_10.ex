defmodule AdventOfCode.Day10 do
  def solve_problem(problem_str) do
    problem_str_l = problem_str
      |> String.split()
    
    light_target = problem_str_l
      |> hd() 
      |> String.to_charlist()
      |> Enum.drop(1)
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.reverse()

    num_lights = light_target
      |> Enum.count()

    starting_lights = "." 
      |> String.duplicate(num_lights)
      |> String.to_charlist()


    {button_schematics_str, _} = problem_str_l
      |> Enum.split_with(fn str -> String.first(str) == "(" end)
    button_schematics = button_schematics_str
      |> Enum.map(fn x -> 
          x
            |> String.replace(["(", ")"], "")
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
        end)

    Enum.reduce_while(1..1000, nil, fn x, _ -> 
      best = recursive_search(light_target, button_schematics, x, starting_lights, 1)
      if is_nil(best) do
        {:cont, nil}
      else
        {:halt, best}
      end
    end)
  end

  def recursive_search(light_target, _button_schematics, max_level, current_lights, level) 
    when light_target == current_lights do
    level - 1
  end
  def recursive_search(_light_target, _button_schematics, max_level, _current_lights, level)
    when level > max_level do
    nil
  end
  def recursive_search(light_target, button_schematics, max_level, current_lights, level) do
    button_schematics
      |> Enum.map(fn button -> 
          new_lights = press_button(current_lights, button)
          recursive_search(light_target, button_schematics, max_level, new_lights, level + 1)
        end)
      |> List.flatten()
      |> Enum.min()
  end

  def press_button(current_lights, button) do
    button
      |> Enum.reduce(current_lights, fn ix, acc -> 
          new_light = if Enum.at(acc, ix) == ?. do ?# else ?. end
          List.replace_at(acc, ix, new_light) 
        end)
  end


  def part1(args) do
    problems = args
      |> String.split("\n", trim: true)
      |> Enum.map(&solve_problem/1)
      |> Enum.sum()
  end

  def solve_problem_p2(problem_str) do
    IO.puts("")
    problem_str_l = problem_str
      |> String.split()
      |> IO.inspect()
    
    joltage_target = problem_str_l
      |> Enum.reverse()
      |> hd()
      |> String.replace(["{", "}"], "")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect(label: "Joltage target")

    num_lights = joltage_target
      |> Enum.count()


    starting_joltage = 0
      |> List.duplicate(num_lights)
      |> IO.inspect(label: "Starting Joltage")


    {button_schematics_str, _} = problem_str_l
      |> Enum.split_with(fn str -> String.first(str) == "(" end)
    button_schematics = button_schematics_str
      |> Enum.map(fn x -> 
          x
            |> String.replace(["(", ")"], "")
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
        end)
      |> IO.inspect(label: "Button Schematics")
    num_buttons = button_schematics_str
      |> Enum.count()

    button_coefficients = button_schematics
      |> Enum.map(fn button -> 
          zeros = List.duplicate(0, num_lights)
          button |>
            Enum.reduce(zeros, fn b, acc -> List.replace_at(acc, b, 1) end)
        end)
      |> IO.inspect(label: "Button coefficients")
    
    pattern_costs = get_pattern_costs(button_coefficients)

      |> IO.inspect(label: "Pattern costs")

  end

  def get_pattern_costs(coefs) do
    num_buttons = coefs
      |> Enum.count()
    num_lights = coefs
      |> hd()
      |> Enum.count()

    0..(num_buttons + 1)
      |> Enum.flat_map()
  end



  def part2(args) do
    problems = args
      |> String.split("\n", trim: true)
      |> Enum.take(1)
      |> Enum.map(&solve_problem_p2/1)
      |> Enum.sum()
  end
end
