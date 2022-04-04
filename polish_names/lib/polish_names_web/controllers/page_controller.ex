defmodule PolishNamesWeb.PageController do
  use PolishNamesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
