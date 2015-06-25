defmodule ExHttp2.Request do
  defstruct method: "GET", path: "/", version: "HTTP/1.1", headers: []
  alias ExHttp2.Server

  def parse(socket) do
    initial_header = Server.read_line(socket)
    [method, path, version] = String.split(initial_header)
    headers = read_headers(socket)
    %ExHttp2.Request{method: method,
                     path: path,
                     version: version,
                     headers: headers}
  end

  defp read_headers(socket, acc \\ [])

  defp read_headers(_, ["\r\n" | acc]) do
    acc
  end

  defp read_headers(socket, acc) do
    read_headers(socket, [Server.read_line(socket) | acc])
  end
end
