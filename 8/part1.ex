defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> List.first()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_metadata(input) do
    [num_children, num_metadata] = Enum.take(input, 2)
    input = Enum.drop(input, 2)

    {input, metadata_sum} = if num_children > 0 do
      1..num_children
      |> Enum.reduce({input, 0}, fn _, {input, acc_sum} ->
        {updated_input, sum} = calculate_metadata(input)
        {updated_input, acc_sum + sum}
      end)
    else
      {input, 0}
    end

    metadata_sum = metadata_sum + (input |> Enum.take(num_metadata) |> Enum.sum())
    input = Enum.drop(input, num_metadata)

    {input, metadata_sum}
  end
end

Main.read_input()
|> Main.calculate_metadata()
|> elem(1)
|> IO.inspect()
