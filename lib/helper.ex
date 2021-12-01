defmodule Helper do
  def parse_file(filename, opts \\ []) do
    map_fn = Keyword.get(opts, :map_by, & &1)

    File.read!(filename)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(map_fn)
  end
end
