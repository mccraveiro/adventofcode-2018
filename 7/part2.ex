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

  defp get_duration(key) do
    charcode = key
    |> String.to_charlist()
    |> hd()

    charcode - 4
  end

  def choose_task(dependencies, workers \\ [], time \\ 0)

  def choose_task(dependencies, _workers, time) when dependencies == %{} do
    time - 1
  end

  def choose_task(dependencies, workers, time) do
    finished_workers = workers
    |> Enum.filter(fn {key, started_time} ->
      (time - started_time) >= get_duration(key)
    end)
    |> Enum.map(&elem(&1, 0))

    workers = workers
    |> Enum.filter(fn {key, started_time} ->
      (time - started_time) < get_duration(key)
    end)

    dependencies = dependencies
    |> Map.drop(finished_workers)
    |> Enum.map(fn {key, value} ->
      {key, MapSet.difference(value, MapSet.new(finished_workers))}
    end)
    |> Enum.into(%{})

    current_tasks = workers
    |> Enum.map(&elem(&1, 0))

    next_task = dependencies
    |> Enum.filter(fn {key, value} ->
      MapSet.size(value) == 0 and !Enum.member?(current_tasks, key)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
    |> List.first()

    if next_task && length(workers) < 5 do
      choose_task(dependencies, [{next_task, time} | workers], time)
    else
      choose_task(dependencies, workers, time + 1)
    end
  end
end

Main.read_input()
|> Main.choose_task()
|> IO.inspect()
