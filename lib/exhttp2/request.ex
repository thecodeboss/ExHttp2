defmodule ExHttp2.Request do
  defstruct method: "GET", path: "/", version: "HTTP/1.1", headers: %{}, body: ""
  alias ExHttp2.Server

  def parse(socket) do
    initial_header = Server.read_line(socket)
    [method, path, version] = String.split(initial_header)
    headers = read_headers(socket)
    request = %ExHttp2.Request{method: method,
                               path: path,
                               version: version,
                               headers: headers}
    case request.method do
      "POST" -> parse_body(socket, request)
      _ -> request
    end
  end

  def parse_body(socket, request=%ExHttp2.Request{}) do
    num_bytes = request.headers["Content-Length"] |> String.to_integer
    :inet.setopts(socket, packet: :raw)
    body = Server.read_bytes(socket, num_bytes)
    %{request | body: body}
  end

  def path(request=%ExHttp2.Request{}, config) do
    Path.join(config[:content_path], request.path)
  end

  defp read_headers(socket, acc \\ %{})

  defp read_headers(socket, acc) do
    line = Server.read_line(socket)
    case line do
      "\r\n" -> acc
      line -> [key, value] = String.split(line, ":", parts: 2)
              clean_value = String.strip(value)
              read_headers(socket, Map.put(acc, key, clean_value))
    end
  end
end
