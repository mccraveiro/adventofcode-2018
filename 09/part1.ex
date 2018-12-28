defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> List.first()
    |> (fn input ->
      regex = ~r/(?<players>\d+) players; last marble is worth (?<marbles>\d+) points/
      Regex.named_captures(regex, input)
    end).()
    |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end

  def run(captures) do
    scores = for _ <- 1..captures.players, do: 0
    remaining_marbles = 1..captures.marbles
    place_marble([0], 0, scores, 0, remaining_marbles)
  end

  defp place_marble(_, _, scores, _, []) do
    Enum.max(scores)
  end

  defp place_marble(circle, current_marble_index, scores, current_player, remaining_marbles) do
    next_marble = Enum.at(remaining_marbles, 0)
    remaining_marbles = Enum.drop(remaining_marbles, 1)

    if rem(next_marble, 23) == 0 do
      current_marble_index = rem(rem(current_marble_index - 7, length(circle)) + length(circle), length(circle))
      turn_score = next_marble + Enum.at(circle, current_marble_index)
      circle = List.delete_at(circle, current_marble_index)
      scores = List.update_at(scores, current_player, &(&1 + turn_score))
      current_player = rem(current_player + 1, length(scores))
      place_marble(circle, current_marble_index, scores, current_player, remaining_marbles)
    else
      current_marble_index = rem(current_marble_index + 1, length(circle)) + 1
      circle = List.insert_at(circle, current_marble_index, next_marble)
      current_player = rem(current_player + 1, length(scores))
      place_marble(circle, current_marble_index, scores, current_player, remaining_marbles)
    end
  end
end

Main.read_input()
|> Main.run()
|> IO.inspect()
