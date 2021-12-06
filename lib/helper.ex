defmodule Helper do
  def parse_file(input, opts \\ []) do
    map_fn = Keyword.get(opts, :map_by, & &1)
    split_by = Keyword.get(opts, :split_by, "\n")

    if input =~ "priv" do
      File.read!(input)
    else
      input
    end
    |> String.trim()
    |> String.split(split_by, trim: true)
    |> Enum.map(map_fn)
  end
end
