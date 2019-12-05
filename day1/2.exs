defmodule Solution do
  defp parse_file(body) do
    body
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate_fuel(module_mass) do
    div(module_mass, 3) - 2
  end

  defp fuel_for_fuel_mass(fuel_mass) do
    fuel_for_fuel = calculate_fuel(fuel_mass)
    case fuel_for_fuel do
      x when x > 0 -> fuel_for_fuel + fuel_for_fuel_mass(fuel_for_fuel)
      _ -> 0
    end
  end

  def solve(file_body) do
    fuel_for_modules = file_body
                       |> parse_file
                       |> Enum.map(&calculate_fuel/1)

    fuel_for_fuel = fuel_for_modules
                    |> Enum.map(&fuel_for_fuel_mass/1)

    total = fuel_for_modules ++ fuel_for_fuel
            |> Enum.reduce(&+/2)

    IO.inspect total
  end
end

case File.read('in') do
  { :ok, body } -> Solution.solve(body)
  _ -> raise('something failed :(')
end
