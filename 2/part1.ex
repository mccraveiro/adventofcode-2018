defmodule Main do
  def process(input) do
    String.codepoints(input)
      |> Enum.group_by(&(&1))
      |> Map.values
      |> Enum.map(&length/1)
      |> Main.count_twos_and_threes
  end

  def count_twos_and_threes(repetitions) do
    {has_number(repetitions, 2), has_number(repetitions, 3)}
  end

  def has_number(repetitions, number) do
    if Enum.member?(repetitions, number), do: 1, else: 0
  end

  def sum_tuples({twos, threes}, {twos_acc, threes_acc}) do
    {twos + twos_acc, threes + threes_acc}
  end

  def checksum({twos, threes}) do
    twos * threes
  end
end

IO.read(:all)
 |> String.split("\n")
 |> Enum.filter(&(&1 != ""))
 |> Enum.map(&Main.process/1)
 |> Enum.reduce({ 0, 0 }, &Main.sum_tuples/2)
 |> Main.checksum
 |> IO.inspect
