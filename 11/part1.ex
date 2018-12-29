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

  defp get_hundred_digit(value) do
    div(value, 100) - (10 * div(value, 1000))
  end

  def find_largest_power(grid, position \\ 0, max_power \\ nil, max_position \\ nil)

  def find_largest_power(_, nil, _, max_position) do
    translate_position(max_position, 1)
  end

  def find_largest_power(grid, position, max_power, max_position) do
    power = calculate_power(grid, position)
    next_position = next_position(position)

    if max_power == nil or power > max_power do
      find_largest_power(grid, next_position, power, position)
    else
      find_largest_power(grid, next_position, max_power, max_position)
    end
  end

  defp calculate_power(grid, position) do
    elem(grid, position + 0)   + elem(grid, position + 1)   + elem(grid, position + 2) +
    elem(grid, position + 300) + elem(grid, position + 301) + elem(grid, position + 302) +
    elem(grid, position + 600) + elem(grid, position + 601) + elem(grid, position + 602)
  end

  defp next_position(position) do
    position = position + 1
    {x, y} = translate_position(position)

    cond do
      x > 299 or y > 299 -> nil
      x > 297 or y > 297 -> next_position(position)
      true -> position
    end
  end

  defp translate_position(position, offset \\ 0) do
    {div(position, 300) + offset, rem(position, 300) + offset}
  end
end

ChronalCharge.read_serial_number()
|> ChronalCharge.build_grid()
|> ChronalCharge.find_largest_power()
|> IO.inspect()
