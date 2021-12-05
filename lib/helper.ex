defmodule Helper do
  def parse_file(filename, opts \\ []) do
    map_fn = Keyword.get(opts, :map_by, & &1)
    split_by = Keyword.get(opts, :split_by, "\n")

    File.read!(filename)
    |> String.split(split_by, trim: true)
    |> Enum.map(map_fn)
  end
end
