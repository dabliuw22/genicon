defmodule Genicon.Domain.Icon do
  alias Genicon.Domain.Icon
  defstruct hex: nil, color: nil, grid: nil, pixels: nil

  def new(hex, color, grid, pixels) do
    %__MODULE__{
      hex: hex,
      color: color,
      grid: grid,
      pixels: pixels
    }
  end

  @type t :: %__MODULE__{
          # [pos_integer()]
          hex: list(pos_integer()) | nil,
          # tuple()
          color: {pos_integer(), pos_integer(), pos_integer()} | nil,
          grid: list(pos_integer()) | nil,
          pixels: list(pos_integer()) | nil
        }

  @spec pixel_map(Icon.t()) :: Icon.t()
  def pixel_map(%Icon{grid: grid} = icon) do
    pixels =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Icon{icon | pixels: pixels}
  end
end

defmodule Genicon.Domain.Color do
  alias Genicon.Domain.Icon

  @spec color(Icon.t()) :: Icon.t()
  def color(%Icon{hex: [r, g, b | _tail]} = icon) do
    %Icon{icon | color: {r, g, b}}
  end
end

defmodule Genicon.Domain.Grid do
  alias Genicon.Domain.Icon

  @spec build_grid(Icon.t()) :: Icon.t()
  def build_grid(%Icon{hex: hex} = icon) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&build_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Icon{icon | grid: grid}
  end

  @spec build_row([pos_integer()]) :: [pos_integer()]
  defp build_row(row) when is_list(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @spec filter(Icon.t()) :: Icon.t()
  def filter(%Icon{grid: grid} = icon) do
    grid = Enum.filter(grid, fn {code, _} -> rem(code, 2) == 0 end)
    %Icon{icon | grid: grid}
  end
end
