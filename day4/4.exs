defmodule Solution do
  @password_range 307237..769058

  defp six_digits?(candidate) do
    length(candidate) == 6
  end

  defp matching_adjacent_digits?(candidate) do
    candidate
    |> Enum.chunk_by(&(&1))
    |> Enum.map(&length/1)
    |> Enum.any?(&(&1 == 2))
  end

  defp increasing?(candidate) do
    [ _head | tail ] = candidate 

    Enum.zip(candidate, tail)
    |> Enum.all?(fn { d1, d2 } -> d1 <= d2 end)
  end

  def valid_password?(candidate) do
    conditions = [
      &six_digits?/1,
      &matching_adjacent_digits?/1,
      &increasing?/1
    ]

    Enum.all?(conditions, &(&1.(candidate)))
  end

  def solve do
    @password_range
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&(valid_password?(&1)))
    |> Enum.count
  end
end

test_cases = [
  { true, 112233 },
  { false, 123444 },
  { false, 124445 },
  { true, 111122 }
]

test_cases
|> Enum.each(fn { expected, test } ->
  actual = test
           |> Integer.digits
           |> Solution.valid_password?

  case expected == actual do
    false -> 
      IO.puts("FAIL!")
      IO.inspect(actual, label: 'actual')
      IO.inspect(expected, label: 'expected')
      IO.inspect(test, label: 'input')
    _ -> IO.puts("PASS")
  end
  IO.puts('===========')
end)
Solution.solve |> IO.inspect
