defmodule Jirex.Endpoint do
  @moduledoc """
  Jirex.Endpoint provides functions
  that construct the url value for
  a resource's endpoint.

  ### Functions
      issue/0
  """

  @doc """
  The issue/0 function returns the
  corrsponding url for the issue
  resource endpoint using the configured
  api url.

  ### Example
      iex> Jirex.Endpoint.issue
      "https://someteam.atlassian.net/rest/api/2/issue/"
  """
  def issue do
    Application.get_env(:jirex, :jira_api_url) <> "/issue/"
  end
end
