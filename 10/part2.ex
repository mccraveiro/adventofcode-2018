defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn input ->
      [x, y, velocity_x, velocity_y] = ~r/-?\d+/
      |> Regex.scan(input)
      |> Enum.map(fn [x] -> String.to_integer(x) end)

      %{
        :x => x,
        :y => y,
        :velocity_x => velocity_x,
        :velocity_y => velocity_y,
      }
    end)
  end

  def find_time(stars, time \\ 0, previous_size \\ nil) do
    size = stars
    |> forward_to(time)
    |> calculate_size()

    if size > previous_size do
      time - 1
    else
      find_time(stars, time + 1, size)
    end
  end

  defp forward_to(stars, time) do
    stars
    |> Enum.map(fn star ->
      %{
        :x => star.x + star.velocity_x * time,
        :y => star.y + star.velocity_y * time,
        :velocity_x => star.velocity_x,
        :velocity_y => star.velocity_y,
      }
    end)
  end

  defp calculate_bounding_box(stars) do
    {min_x, max_x} = stars
    |> Enum.map(fn star -> star.x end)
    |> Enum.min_max()

    {min_y, max_y} = stars
    |> Enum.map(fn star -> star.y end)
    |> Enum.min_max()

    {min_x, max_x, min_y, max_y}
  end

  defp calculate_size(stars) do
    {min_x, max_x, min_y, max_y} = calculate_bounding_box(stars)
    (max_x - min_x) * (max_y - min_y)
  end
end

Main.read_input()
|> Main.find_time()
|> IO.inspect()
