defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> List.first()
    |> String.codepoints()
  end

  def process_input(input, pile \\ [])

  def process_input([], pile) do
    pile
  end

  def process_input([head | tail], pile) do
    if match(head, List.first(pile)) do
      process_input(tail, Enum.drop(pile, 1))
    else
      process_input(tail, [head | pile])
    end
  end

  defp match(_char1, nil) do
    false
  end

  defp match(char1, char2) do
    char1 != char2 and
    (String.downcase(char1) == char2 or
    char1 == String.downcase(char2))
  end
end

Main.read_input()
|> Main.process_input()
|> length()
|> IO.inspect()
