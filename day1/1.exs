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

  def solve(file_body) do
    result = file_body
    |> parse_file
    |> Enum.map(&calculate_fuel/1)
    |> Enum.reduce(&+/2)

    IO.inspect result
  end
end

case File.read('in') do
  { :ok, body } -> Solution.solve(body)
  _ -> raise('something failed :(')
end
