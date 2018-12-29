defmodule SubterraneanSustainability do
  def read_input() do
    input = IO.read(:all)

    [[_, initial_state]] = Regex.scan(~r/initial state: ([#.]+)/, input)
    initial_state = String.codepoints(initial_state)
    initial_state = put_offset({initial_state, 0})

    notes = ~r/([#.]+) => ([#.])/
    |> Regex.scan(input)
    |> Enum.map(fn [_, pattern, value] ->
      pattern = String.codepoints(pattern)
      {pattern, value}
    end)
    |> Map.new()

    {initial_state, notes}
  end

  def get_generation({{state, offset}, _}, 0) do
    {state, offset}
  end

  def get_generation({{state, offset}, patterns}, generation_count) do
    {state, offset} = put_offset({state, offset})
    state = state
    |> Enum.with_index()
    |> Enum.map(fn {_, position} ->
      slice = Enum.slice(state, (position - 2)..(position + 2))
      patterns[slice] || "."
    end)

    get_generation({{state, offset}, patterns}, generation_count -  1)
  end

  def sum_pots({state, offset}) do
    state
    |> Enum.with_index()
    |> Enum.reduce(0, fn {value, position}, acc ->
      if value == "." do
        acc
      else
        acc + (position - offset)
      end
    end)
  end

  defp put_offset({state, offset}) do
    min_margin = 5
    first_pot_index = Enum.find_index(state, &(&1 == "#"))
    last_pot_index = state
    |> Enum.reverse()
    |> Enum.find_index(&(&1 == "#"))

    leading_margin = max(min_margin - first_pot_index, 0)
    ending_margin = max(min_margin - last_pot_index, 0)
    {
      Enum.concat([
        List.duplicate(".", leading_margin),
        state,
        List.duplicate(".", ending_margin),
      ]),
      offset + leading_margin
    }
  end
end

SubterraneanSustainability.read_input()
|> SubterraneanSustainability.get_generation(20)
|> SubterraneanSustainability.sum_pots()
|> IO.inspect()
