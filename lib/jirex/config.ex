defmodule Jirex.Config do
  @moduledoc false

  def api_key do
    Application.get_env(:jirex, :jira_api_key)
  end
end
