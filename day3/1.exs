defmodule Solution do
  @wires File.read!('in')
  |> String.trim_trailing
  |> String.split("\n")

  defp make_wire(line) do
    line
    |> String.split(",")
    |> Enum.map(fn
      "U" <> distance -> { :up, String.to_integer(distance) }
      "R" <> distance -> { :right, String.to_integer(distance) }
      "D" <> distance -> { :down, String.to_integer(distance) }
      "L" <> distance -> { :left, String.to_integer(distance) }
    end)
  end

  defp trace(wire), do: trace(wire, [{0, 0}]) # Initial case, origin
  defp trace([], points), do: points # Processed all directions
  defp trace([{_dir, 0} | rest_wire], points), do: trace(rest_wire, points) # Continue to next
  defp trace([current | rest_wire], [pos | _] = acc) do
    { dir, distance } = current
    trace([{dir, distance - 1} | rest_wire], [move(dir, pos) | acc])
  end

  defp move(:up, { x, y }), do: { x + 1, y }
  defp move(:right, { x, y}), do: {x, y+1}
  defp move(:down, { x, y}), do: {x-1, y}
  defp move(:left, { x, y}), do: {x, y-1}

  def solve do
    [wire1, wire2] = @wires
                     |> Enum.map(fn line ->
                       line
                       |> make_wire
                       |> trace
                       |> MapSet.new
                     end)

    MapSet.intersection(wire1, wire2)
    |> MapSet.delete({0, 0})
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end
end

Solution.solve |> IO.inspect
