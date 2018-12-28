defmodule Main do
  def read_input() do
    IO.read(:all)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
  end

  def process_input(input) do
    process_input(input, nil, Map.new())
  end

  defp process_input([], _, calendar) do
    calendar
  end

  defp process_input([head | tail], guard_id, calendar) do
    case match_action(head) do
      %{ :action => "begins shift", :guard_id => new_guard_id } ->
        calendar = if calendar[new_guard_id],
          do: calendar,
          else: put_in(calendar[new_guard_id], %{})

        process_input(tail, new_guard_id, calendar)

      %{ :action => "falls asleep", :time => time, :day => day } ->
        updated_calendar = if calendar[guard_id][day] do
          calendar
        else
          put_in(calendar[guard_id][day], create_calendar())
        end

        updated_day_calendar = Map.merge(updated_calendar[guard_id][day], create_calendar(time, "#"))
        updated_calendar = put_in(calendar[guard_id][day], updated_day_calendar)
        process_input(tail, guard_id, updated_calendar)

      %{ :action => "wakes up", :time => time, :day => day } ->
        updated_day_calendar = Map.merge(calendar[guard_id][day], create_calendar(time))
        updated_calendar = put_in(calendar[guard_id][day], updated_day_calendar)
        process_input(tail, guard_id, updated_calendar)
    end
  end

  defp create_calendar(time \\ 0, symbol \\ ".") do
    Map.new(time..59, &({&1, symbol}))
  end

  defp match_action(input) do
    regex = ~r/^\[(?<year>\d+)-(?<day>\d+-\d+) (?<hour>\d+):(?<minute>\d+)\] (Guard #(?<guard_id>\d+) )?(?<action>[\w ]+)$/
    captures = Regex.named_captures(regex, input)

    guard_id = if captures["guard_id"] == "",
      do: nil,
      else: String.to_integer(captures["guard_id"])

    %{
      :action => captures["action"],
      :guard_id => guard_id,
      :time => String.to_integer(captures["minute"]),
      :day => captures["day"],
    }
  end

  def print_calendar(calendar) do
    calendar
    |> Enum.map(fn {guard_id, guard_calendar} ->
      guard_calendar
      |> Enum.map(fn {day, day_calendar} ->
        IO.write day
        IO.write " "
        IO.write String.pad_leading(to_string(guard_id), 4)
        IO.write " "

        day_calendar
        |> Map.to_list()
        |> Enum.sort(&(elem(&1, 0) <= elem(&2, 0)))
        |> Enum.map(fn {_time, value} -> IO.write(value) end)

        IO.write "\n"
      end)
    end)

    calendar
  end

  def calculate_result(calendar) do
    { guard_id, minute, _} = calendar
    |> Enum.map(fn {guard_id, guard_calendar} ->
      {minute, count} = find_minute(guard_calendar)
      {guard_id, minute, count}
    end)
    |> Enum.sort(&(elem(&1, 2) >= elem(&2, 2)))
    |> List.first()

    guard_id * minute
  end

  defp find_minute(guard_calendar, minute \\ 0, max_value \\ 0, max_minute \\ 0) do
    if minute == 60 do
      { max_minute, max_value }
    else
      count = guard_calendar
      |> Map.values()
      |> Enum.map(&(&1[minute]))
      |> Enum.count(&(&1 == "#"))

      if max_value > count do
        find_minute(guard_calendar, minute + 1, max_value, max_minute)
      else
        find_minute(guard_calendar, minute + 1, count, minute)
      end
    end
  end
end

Main.read_input()
|> Enum.sort()
|> Main.process_input()
|> Main.print_calendar()
|> Main.calculate_result()
|> IO.inspect(limit: :infinity, pretty: true)
