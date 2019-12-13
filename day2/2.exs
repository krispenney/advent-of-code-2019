defmodule Intcode do
  defstruct memory: [], pc: 0, terminated: false

  @add 1
  @mult 2
  @exit 99

  def new(memory) do
    %Intcode { memory: memory }
  end

  def read(%Intcode{ memory: memory, pc: pc }, offset \\ 0) do
    Enum.at(memory, pc + offset)
  end

  def result(intcode) do
    intcode.memory |> hd
  end

  def execute(intcode = %Intcode{ memory: memory, terminated: false }) do
    next_intcode = case Intcode.read(intcode) do
      @add ->
        arg1 = intcode |> Intcode.read(1)
        arg2 = intcode |> Intcode.read(2)
        output_addr = intcode |> Intcode.read(3)

        memory = List.replace_at(
          memory,
          output_addr,
          Enum.at(memory, arg1) + Enum.at(memory, arg2)
        )

        %Intcode{intcode | memory: memory, pc: intcode.pc + 4 }
      @mult -> 
        arg1 = intcode |> Intcode.read(1)
        arg2 = intcode |> Intcode.read(2)
        output_addr = intcode |> Intcode.read(3)

        memory = List.replace_at(
          memory,
          output_addr,
          Enum.at(memory, arg1) * Enum.at(memory, arg2)
        )

        %Intcode{intcode | memory: memory, pc: intcode.pc + 4 }
      @exit -> 
        %Intcode{intcode | terminated: true}
    end

    execute(next_intcode)
  end

  def execute(intcode = %Intcode{ terminated: true }) do
    intcode
  end
end

defmodule Solution do
  def solve(input) do
    { _memory, noun, verb } =
      for noun <- 0..99, verb <- 0..99 do
        result = input
                 |> List.replace_at(1, noun)
                 |> List.replace_at(2, verb)
                 |> Intcode.new
                 |> Intcode.execute
                 |> Intcode.result
        { result, noun, verb }
      end
      |> Enum.find(fn { result, _n, _v } ->
        result == 19690720
      end)

    (100 * noun) + verb
  end
end

input = File.read!('in') 
|> String.trim_trailing
|> String.split(",")
|> Enum.map(&String.to_integer/1)

input |> Solution.solve |> IO.inspect

"====== TESTS ====== " |> IO.puts

Intcode.new([1,9,10,3,2,3,11,0,99,30,40,50])
|> Intcode.execute 
|> Intcode.result 
|> IO.inspect(label: 'expected: 3500, actual')

Intcode.new([1,0,0,0,99])
|> Intcode.execute 
|> Intcode.result 
|> IO.inspect(label: 'expected: 2, actual')

Intcode.new([1,1,1,4,99,5,6,0,99])
|> Intcode.execute 
|> Intcode.result 
|> IO.inspect(label: 'expected: 30, actual')

IO.puts("Part 1...")
input
|> Intcode.new
|> Intcode.execute
|> Intcode.result
|> IO.inspect(label: 'expected: 3716250, actual')

IO.puts("Part 2...")
input |> Solution.solve |> IO.inspect(label: 'expected: 6472, actual')

"====== TESTS ====== " |> IO.puts
