defmodule Main do
  alias __MODULE__.CircularList

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
    remaining_marbles = for n <- 1..(captures.marbles * 100), do: n
    circle = CircularList.new([0])
    place_marble(circle, scores, 0, remaining_marbles)
  end

  defp place_marble(_, scores, _, []) do
    Enum.max(scores)
  end

  defp place_marble(circle, scores, current_player, [next_marble | remaining_marbles])
  when rem(next_marble, 23) == 0 do
    {scored, circle} = 1..7
    |> Enum.reduce(circle, fn _, circle -> CircularList.previous(circle) end)
    |> CircularList.pop()

    turn_score = next_marble + scored
    scores = List.update_at(scores, current_player, &(&1 + turn_score))
    current_player = rem(current_player + 1, length(scores))
    place_marble(circle, scores, current_player, remaining_marbles)
  end

  defp place_marble(circle, scores, current_player, [next_marble | remaining_marbles]) do
    circle = circle
    |> CircularList.next()
    |> CircularList.next()
    |> CircularList.insert(next_marble)

    current_player = rem(current_player + 1, length(scores))
    place_marble(circle, scores, current_player, remaining_marbles)
  end

  # Credits to github.com/sasa1977
  defmodule CircularList do
    def new(elements), do: {elements, []}

    def next({[], previous}), do: next({Enum.reverse(previous), []})
    def next({[current | rest], previous}), do: {rest, [current | previous]}

    def previous({next, []}), do: previous({[], Enum.reverse(next)})
    def previous({next, [last | rest]}), do: {[last | next], rest}

    def insert({next, previous}, element), do: {[element | next], previous}

    def pop({[], previous}), do: pop({Enum.reverse(previous), []})
    def pop({[current | rest], previous}), do: {current, {rest, previous}}
  end
end

Main.read_input()
|> Main.run()
|> IO.inspect()
