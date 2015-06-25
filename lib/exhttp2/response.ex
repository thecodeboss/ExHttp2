defmodule ExHttp2.Response do
  defstruct version: "HTTP/1.1", code: "500", reason: "Server Error", time: nil
  use Timex

  def ok(_request) do
    %ExHttp2.Response{code: 200, reason: "OK", time: get_current_time}
  end

  def to_string(r=%ExHttp2.Response{}) do
       "#{r.version} #{r.code} #{r.reason}\r\n"
    <> "Server: ExHttp2\r\n"
    <> "Last-Modified: #{r.time}\r\n"
  end

  defp get_current_time do
    Date.now |> DateFormat.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
end
