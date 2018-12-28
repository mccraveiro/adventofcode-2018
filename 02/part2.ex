defmodule Main do
  # Source: https://github.com/tallakt/comb
  def combinations(enum, k) do
    List.last(do_combinations(enum, k))
    |> Enum.uniq
  end

  defp do_combinations(enum, k) do
    combinations_by_length = [[[]]|List.duplicate([], k)]

    list = Enum.to_list(enum)
    List.foldr list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end
  end
end

IO.read(:all)
 |> String.split("\n")
 |> Enum.filter(&(&1 != ""))
 |> Main.combinations(2)
 |> Enum.map(fn [w1, w2] ->
      word1 = String.codepoints(w1)
      word2 = String.codepoints(w2)

      Enum.zip(word1, word2)
        |> Enum.reduce("", fn {x, y}, acc ->
          if x == y, do: acc <> x, else: acc
        end)
    end)
 |> Enum.sort_by(&String.length/1)
 |> Enum.fetch!(-1)
 |> IO.inspect
