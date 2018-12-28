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

  def run(stars) do
    time = find_time(stars)

    stars
    |> forward_to(time)
    |> draw_sky()
  end

  defp draw_sky(stars) do
    {min_x, max_x, min_y, max_y} = calculate_bounding_box(stars)

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x ->
        exists? = stars
        |> Enum.find(fn star ->
          star.x == x and star.y == y
        end)

        if exists? do
          IO.write("#")
        else
          IO.write(" ")
        end
      end)

      IO.write("\n")
    end)
  end

  defp find_time(stars, time \\ 0, previous_size \\ nil) do
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
|> Main.run()
