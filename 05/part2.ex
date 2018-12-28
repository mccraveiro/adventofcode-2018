defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> List.first()
  end

  def generate_possibilities(input) do
    ?a..?z
    |> Enum.map(&List.wrap/1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&remove_polymers(&1, input))
    |> Enum.map(&String.codepoints/1)
  end

  defp remove_polymers(char, input) do
    re = Regex.compile!(char, "i")
    Regex.replace(re, input, "")
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
|> Main.generate_possibilities()
|> Enum.map(&Main.process_input/1)
|> Enum.map(&length/1)
|> Enum.min()
|> IO.inspect()
