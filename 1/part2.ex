defmodule Main do
  def run(sequence, index, result, previousResults) do
    updatedResult = result + Enum.at(sequence, index)

    if MapSet.member?(previousResults, updatedResult) do
      updatedResult
    else
      next = rem(index + 1, length(sequence))
      Main.run(sequence, next, updatedResult, MapSet.put(previousResults, updatedResult))
    end
  end
end

IO.read(:all)
 |> String.split("\n")
 |> Enum.filter(&(&1 != ""))
 |> Enum.map(&String.to_integer/1)
 |> Main.run(0, 0, MapSet.new())
 |> IO.puts
