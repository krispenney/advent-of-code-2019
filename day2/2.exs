defmodule Solution do
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

  defp setup_program(program, noun, verb) do
    program = List.replace_at(program, 1, noun)
    program = List.replace_at(program, 2, verb)

    { execute(program, 0), noun, verb }
  end

  def solve(program) do
    program_results = for noun <- 0..99, verb <- 0..99, do: setup_program(program, noun, verb)
    # IO.inspect(program_results)
    
    [ { _memory, noun, verb } ] = Enum.filter(program_results, fn { result, _noun, _verb } -> Enum.at(result, 0) == 19690720 end)
    (100 * noun) + verb
  end
end

File.read!('in') 
|> String.trim_trailing
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> Solution.solve
|> IO.inspect
