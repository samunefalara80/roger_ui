defmodule RogerUI.Web.Helpers.Filter do
  @moduledoc """
  Takes an enumeration and returns only those elements defined by a field and a filter.
  """
  @spec call(
          xs :: Enumerable.t(),
          fields :: List.t(),
          filter :: String.t()
        ) :: []

  @doc """
  Takes an enumerable, list of  fields and a filter and returns it filtered
  """
  def call(enumerable, _, ""), do: enumerable

  def call(enumerable, fields, filter) do
    filter = String.upcase(filter)

    Enum.filter(enumerable, &check(&1, fields, filter))
  end

  defp check(map, field, filter), do: check(map, [field], filter)

  defp check(map, fields, filter) do
    fields
    |> Enum.any?(fn field ->
      map
      |> Map.get(field)
      |> to_string()
      |> String.upcase()
      |> String.contains?(filter)
    end)
  end
end
