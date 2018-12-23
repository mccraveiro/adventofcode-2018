defmodule Main do
  def create_fabric() do
    (0..1000000)
      |> Enum.map(fn x -> {x, 0} end)
      |> Map.new
  end

  def read_input(input) do
    String.codepoints(input)
    regex = ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/
    captures = Regex.named_captures(regex, input)

    %{
      :id => String.to_integer(captures["id"]),
      :x => String.to_integer(captures["x"]),
      :y => String.to_integer(captures["y"]),
      :width => String.to_integer(captures["width"]),
      :height => String.to_integer(captures["height"]),
    }
  end

  def derive_claims(claim) do
    id = claim.id
    x = claim.x
    y = claim.y
    end_x = x + claim.width - 1
    end_y = y + claim.height - 1

    (x..end_x)
      |> Enum.flat_map(fn current_x ->
        (y..end_y)
          |> Enum.map(fn current_y ->
            %{
              :id => id,
              :x => current_x,
              :y => current_y
            }
          end)
      end)
  end

  def paint_fabric(claims) do
    claims_id = claims
      |> Enum.map(&(&1.id))
      |> MapSet.new

    { claims_id, paint_fabric(claims, Main.create_fabric(), MapSet.new()) }
  end

  defp paint_fabric([], _, overlapping_ids) do
    overlapping_ids
  end

  defp paint_fabric([claim | tail], fabric, overlapping_ids) do
    position = claim.x * 1000 + claim.y
    current_id = Map.get(fabric, position)

    id = if current_id == 0,
      do: claim.id,
      else: "X"

    updated_overlapping_ids = if (id == "X"),
      do: MapSet.union(overlapping_ids, MapSet.new([current_id, claim.id])),
      else: overlapping_ids

    painted_fabric = Map.put(fabric, position, id)
    paint_fabric(tail, painted_fabric, updated_overlapping_ids)
  end

  def find_claim_not_overlapping({ set1, set2 }) do
    MapSet.difference(set1, set2)
      |> MapSet.to_list()
      |> List.first()
  end
end

IO.read(:all)
 |> String.split("\n")
 |> Enum.filter(&(&1 != ""))
 |> Enum.map(&Main.read_input/1)
 |> Enum.flat_map(&Main.derive_claims/1)
 |> Main.paint_fabric()
 |> Main.find_claim_not_overlapping()
 |> IO.inspect
