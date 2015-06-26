defmodule ExHttp2.Response do
  defstruct version: "HTTP/1.1", code: "500", reason: "Server Error", time: nil,
            content_length: 0, content_type: "text/html", body: ""
  use Timex

  def ok(body) do
    %{ok | content_length: byte_size(body),
           body: body}
  end

  def ok do
    %ExHttp2.Response{code: 200,
                      reason: "OK",
                      time: get_current_time}
  end

  def not_found do
    %ExHttp2.Response{code: 404,
                      reason: "Not found"}
  end

  def not_implemented do
    %ExHttp2.Response{code: 501,
                      reason: "Not implemented"}
  end

  def to_string(r=%ExHttp2.Response{}) do
       "#{r.version} #{r.code} #{r.reason}\r\n"
    <> "Server: ExHttp2\r\n"
    <> "Last-Modified: #{r.time}\r\n"
    <> "Date: #{r.time}\r\n"
    <> "Content-Type: #{r.content_type}\r\n"
    <> "Content-Length: #{r.content_length}\r\n"
    <> "\r\n"
    <> "#{r.body}"
  end

  defp get_current_time do
    Date.now |> DateFormat.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
end
