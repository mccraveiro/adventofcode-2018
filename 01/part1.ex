IO.read(:all)
 |> String.split("\n")
 |> Enum.filter(&(&1 != ""))
 |> Enum.map(&String.to_integer/1)
 |> Enum.sum
 |> IO.puts
