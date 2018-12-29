defmodule ChronalCharge do
  def read_serial_number() do
    IO.read(:all)
    |> String.split("\n")
    |> List.first()
    |> String.to_integer()
  end

  def build_grid(serial_number) do
    1..300
    |> Enum.flat_map(fn x ->
      1..300
      |> Enum.map(fn y ->
        rack_id = x + 10
        power_level = (rack_id * y + serial_number) * rack_id
        get_hundred_digit(power_level) - 5
      end)
    end)
    |> List.to_tuple()
  end

  def calculate_sums(grid) do
    0..89999
    |> Enum.reduce(%{}, fn position, acc ->
      {x, y} = translate_position(position)
      sum = get_position(acc, x - 1, y) +
        get_position(acc, x, y - 1) +
        get_position(grid, x, y) -
        get_position(acc, x - 1, y - 1)

      Map.put(acc, position, sum)
    end)
    |> Map.to_list()
    |> List.keysort(0)
    |> Enum.map(&elem(&1, 1))
    |> List.to_tuple()
  end

  def find_largest_power(grid, position \\ 0, size \\ 1, max_power \\ nil, max_position \\ nil, max_size \\ nil)

  def find_largest_power(_, nil, size, _, max_position, max_size)
  when size == 300 do
    {x, y} = translate_position(max_position, 1)
    {x, y, max_size}
  end

  def find_largest_power(grid, nil, size, max_power, max_position, max_size) do
    find_largest_power(grid, 0, size + 1, max_power, max_position, max_size)
  end

  def find_largest_power(grid, position, size, max_power, max_position, max_size) do
    power = calculate_power(grid, position, size)
    next_position = next_position(position, size)

    if max_power == nil or power > max_power do
      find_largest_power(grid, next_position, size, power, position, size)
    else
      find_largest_power(grid, next_position, size, max_power, max_position, max_size)
    end
  end

  defp get_position(grid, x, y)
  when is_map(grid) do
    cond do
      x < 0 -> 0
      y < 0 -> 0
      true -> grid[x * 300 + y]
    end
  end

  defp get_position(grid, x, y)
  when is_tuple(grid) do
    cond do
      x < 0 -> 0
      y < 0 -> 0
      true -> elem(grid, x * 300 + y)
    end
  end

  defp get_hundred_digit(value) do
    div(value, 100) - (10 * div(value, 1000))
  end

  defp translate_position(position, offset \\ 0) do
    {div(position, 300) + offset, rem(position, 300) + offset}
  end

  defp calculate_power(grid, position, size) do
    offset = size - 1
    {x, y} = translate_position(position)

    get_position(grid, x + offset, y + offset) +
    get_position(grid, x - 1, y - 1) -
    get_position(grid, x + offset, y - 1) -
    get_position(grid, x - 1, y + offset)
  end

  defp next_position(position, size) do
    margin = 300 - size
    position = position + 1
    {x, y} = translate_position(position)

    cond do
      x > 299 or y > 299 -> nil
      x > margin or y > margin -> next_position(position, size)
      true -> position
    end
  end
end

ChronalCharge.read_serial_number()
|> ChronalCharge.build_grid()
|> ChronalCharge.calculate_sums()
|> ChronalCharge.find_largest_power()
|> IO.inspect()
