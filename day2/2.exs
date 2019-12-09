defmodule Solution do
  @input File.read!('in') 
  |> String.trim_trailing
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

  defp arg(memory, offset) do
    addr = Enum.at(memory, offset)
    Enum.at(memory, addr)
  end

  defp transition(memory, pc, operator) do
    {
      List.replace_at(
        memory,
        Enum.at(memory, pc+3),
        operator.(arg(memory, pc+1), arg(memory, pc+2))
      ),
      pc+4
    }
  end

  defp execute(memory, pc) when pc >= 0 do
    # IO.inspect(pc)
    { next_memory, next_pc } = case Enum.at(memory, pc) do
      1 -> transition(memory, pc, &+/2)
      2 -> transition(memory, pc, &*/2)
      99 -> { memory, -1 }
    end

    execute(next_memory, next_pc)
  end

  defp execute(memory, -1) do
    memory
  end

  def solve do
    { _memory, noun, verb } =
      for noun <- 0..99, verb <- 0..99 do
        memory = @input
                 |> List.replace_at(1, noun)
                 |> List.replace_at(2, verb)
                 |> execute(0)
        { memory, noun, verb }
      end
      |> Enum.find(fn { memory, _n, _v } ->
        (memory |> hd) == 19690720
      end)

    (100 * noun) + verb
  end
end

Solution.solve |> IO.inspect
