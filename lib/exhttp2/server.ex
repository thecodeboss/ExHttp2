defmodule ExHttp2.Server do
  use Timex
  alias ExHttp2.Request
  alias ExHttp2.Response
  alias ExHttp2.Router

  def accept(config) do
    port = config[:port]
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts "Accepting HTTP connections on port #{port}"
    loop_acceptor(socket, config)
  end

  defp loop_acceptor(socket, config) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(ExHttp2.Server.TaskSupervisor, fn -> serve(client, config) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, config)
  end

  defp serve(socket, config) do
    socket
    |> Request.parse
    |> Router.handle(config)
    |> Response.to_string
    |> write_line(socket)
  end

  def read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  def read_bytes(socket, num_bytes) do
    {:ok, data} = :gen_tcp.recv(socket, num_bytes)
    data
  end

  def write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
