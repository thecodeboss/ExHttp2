defmodule ExHttp2 do
  use Application

  def start(_type, config) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: ExHttp2.Server.TaskSupervisor]]),
      worker(Task, [ExHttp2.Server, :accept, [config]])
    ]

    opts = [strategy: :one_for_one, name: ExHttp2.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
