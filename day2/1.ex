defmodule Solution do
  defp arg(memory, offset) do
    addr = Enum.at(memory, offset)
    Enum.at(memory, addr)
  end

  defp transition(memory, pc, operator) do
    List.replace_at(
      memory,
      Enum.at(memory, pc+3),
      operator.(arg(memory, pc+1), arg(memory, pc+2))
    )
  end

  defp execute(memory, pc) do
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

  def solve(program) do
    execute(program, 0)
  end
end

File.read!('test-2') 
|> String.trim_trailing
|> String.split(',')
|> Enum.map(&String.to_integer/1)
|> Solution.solve
|> IO.inspect
