defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn input ->
      regex = ~r/Step (?<source>[A-Z]) must be finished before step (?<target>[A-Z]) can begin\./
      Regex.named_captures(regex, input)
    end)
    |> Enum.reduce(Map.new(), fn capture, acc ->
      acc = Map.put_new(acc, capture["source"], MapSet.new())
      acc = Map.put_new(acc, capture["target"], MapSet.new())
      updated_list = MapSet.put(acc[capture["target"]], capture["source"])
      Map.put(acc, capture["target"], updated_list)
    end)
  end

  def choose_task(dependencies, result) when dependencies == %{} do
    result
  end

  def choose_task(dependencies, result) do
    next_task = dependencies
    |> Enum.filter(fn {_, value} ->
      MapSet.size(value) == 0
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
    |> List.first()

    updated_dependencies = dependencies
    |> Map.delete(next_task)
    |> Enum.map(fn {key, value} ->
      {key, MapSet.delete(value, next_task)}
    end)
    |> Enum.into(%{})

    updated_result = result <> next_task

    choose_task(updated_dependencies, updated_result)
  end
end

Main.read_input()
|> Main.choose_task("")
|> IO.inspect(limit: :infinity)
