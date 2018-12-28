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

    {input, children_values} = if num_children > 0 do
      1..num_children
      |> Enum.reduce({input, %{}}, fn index, {input, children_values} ->
        {updated_input, value} = calculate_metadata(input)
        {updated_input, Map.put(children_values, index, value)}
      end)
    else
      {input, %{}}
    end

    value = cond do
      num_children == 0 ->
        input
        |> Enum.take(num_metadata)
        |> Enum.sum()
      num_metadata == 0 ->
        0
      true ->
        input
        |> Enum.take(num_metadata)
        |> Enum.map(fn index ->
          Map.get(children_values, index, 0)
        end)
        |> Enum.sum()
    end

    input = Enum.drop(input, num_metadata)

    {input, value}
  end
end

Main.read_input()
|> Main.calculate_metadata()
|> elem(1)
|> IO.inspect()
