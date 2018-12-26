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
    |> name_inputs()
    |> Map.new()
  end

  def name_inputs(coordinates, index \\ 1)

  def name_inputs([], _) do
    []
  end

  def name_inputs([head | tail], index) do
    current_input = {
      head,
      index
    }

    [current_input | name_inputs(tail, index + 1)]
  end

  def find_closest(coordinates, x, y) do
    coordinates
    |> Enum.map(fn {{cx, cy}, name} ->
      {abs(cx - x) + abs(cy - y), name}
    end)
    |> List.keysort(0)
    |> (fn list ->
      first = list
      |> List.first()

      second = list
      |> Enum.at(1)

      if elem(first, 0) == elem(second, 0) do
        "."
      else
        elem(first, 1)
      end
    end).()
  end

  def get_bounds(coordinates) do
    min_x = coordinates
    |> Map.keys()
    |> List.keysort(0)
    |> List.first()
    |> elem(0)

    max_x = coordinates
    |> Map.keys()
    |> List.keysort(0)
    |> List.last()
    |> elem(0)

    min_y = coordinates
    |> Map.keys()
    |> List.keysort(1)
    |> List.first()
    |> elem(1)

    max_y = coordinates
    |> Map.keys()
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
      coordinates_id = Map.get(coordinates, {x, y})
      name = find_closest(coordinates, x, y)

      cond do
        coordinates_id -> coordinates_id
        name -> name
        true -> "."
      end
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

  def print_grid(grid) do
    0..grid.width
    |> Enum.each(fn x ->
      0..grid.height
      |> Enum.each(fn y ->
        IO.write(Enum.at(grid.values, x * grid.width + y))
      end)
      IO.write("\n")
    end)

    grid
  end

  def count_area(grid) do
    grid.values
    |> Enum.group_by(&(&1))
    |> Enum.map(fn {key, values} -> {key, length(values)} end)
    |> List.keysort(1)
    |> List.last()
    |> elem(1)
  end
end

Main.read_input()
|> Main.init_grid()
# |> Main.print_grid()
|> Main.count_area()
|> IO.inspect(limit: :infinity)
