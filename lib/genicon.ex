defmodule Genicon do
  import Genicon.Domain.Icon
  import Genicon.Crypto.Hash
  import Genicon.Domain.Color
  import Genicon.Domain.Grid
  alias Genicon.Domain.Icon

  @spec main(binary()) :: atom()
  def main(username) when is_binary(username) do
    username
    |> hash!()
    |> color()
    |> build_grid()
    |> filter()
    |> pixel_map()
    |> draw()
    |> save(username)

    :ok
  end

  @spec draw(Icon.t()) :: binary()
  def draw(%Icon{color: color, pixels: pixels}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixels, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @spec save(binary, binary) :: atom()
  def save(image, filename), do: File.write!("#{filename}.png", image)
end
