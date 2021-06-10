defmodule Mix.Tasks.Start do
  use Mix.Task

  @spec run(any) :: atom()
  def run(_), do: Genicon.main("dabliuw22")
end
