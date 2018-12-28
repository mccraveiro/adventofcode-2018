defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(fn [x, y] ->
      {
        String.to_integer(x),
        String.to_integer(y),
      }
    end)
  end

  def calculate_distance(coordinates, x, y) do
    coordinates
    |> Enum.map(fn {cx, cy} ->
      abs(cx - x) + abs(cy - y)
    end)
    |> Enum.sum()
  end

  def get_bounds(coordinates) do
    min_x = coordinates
    |> List.keysort(0)
    |> List.first()
    |> elem(0)

    max_x = coordinates
    |> List.keysort(0)
    |> List.last()
    |> elem(0)

    min_y = coordinates
    |> List.keysort(1)
    |> List.first()
    |> elem(1)

    max_y = coordinates
    |> List.keysort(1)
    |> List.last()
    |> elem(1)

    {min_x, max_x, min_y, max_y}
  end

  def init_grid(coordinates) do
    {min_x, max_x, min_y, max_y} = get_bounds(coordinates)
    width = max_x - min_x
    height = max_y - min_y

    values = 0..(width * height)
    |> Enum.map(fn value ->
      x = div(value, width) + min_x
      y = rem(value, width) + min_y
      calculate_distance(coordinates, x, y)
    end)

    %{
      :min_x => min_x,
      :max_x => max_x,
      :min_y => min_y,
      :max_y => max_y,
      :width => width,
      :height => height,
      :coordinates => coordinates,
      :values => values,
    }
  end

  def count_area(grid) do
    grid.values
    |> Enum.filter(&(&1 < 10000))
    |> length()
  end
end

Main.read_input()
|> Main.init_grid()
|> Main.count_area()
|> IO.inspect(limit: :infinity)
