defmodule ExHttp2.Router do
  alias ExHttp2.Response
  alias ExHttp2.Request

  def handle(request=%ExHttp2.Request{}, config) do
    case request.method do
      "GET" -> get(request, config)
      "HEAD" -> head(request, config)
      "POST" -> post(request, config)
      _ -> Response.not_implemented
    end
  end

  def get(request=%ExHttp2.Request{}, config) do
    {msg, file} = Request.path(request, config)
      |> File.read
    case {msg, file} do
      {:ok, contents} -> Response.ok(contents)
      _ -> Response.not_found
    end
  end

  def head(_request=%ExHttp2.Request{}, _config) do
    Response.ok
  end

  def post(request=%ExHttp2.Request{}, config) do
    # Handle post data here using request.body
    get(request, config)
  end
end
