defmodule ElixtronDesktop do
  defdelegate open_browser(), to: ElixtronDesktop.Server
  defdelegate connect(), to: ElixtronDesktop.Server
  defdelegate navigate(url), to: ElixtronDesktop.Server
end
