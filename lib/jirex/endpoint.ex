defmodule Jirex.Endpoint do
  @moduledoc """
  Jirex.Endpoint provides functions
  that construct the url value for
  a resource's endpoint.

  ### Functions
      - issue_get/0
      - issue_search/1
  """

  @doc """
  The issue_get/0 function returns the
  corrsponding url for the issue
  resource endpoint using the configured
  api url.

  ### Example
      iex> Jirex.Endpoint.issue_get
      "https://someteam.atlassian.net/rest/api/2/issue/"
  """
  def issue_get do
    Application.get_env(:jirex, :jira_api_url) <> "/issue/"
  end

  @doc """
  The issue_search/1 function returns the
  corrsponding url for the issue
  resource endpoint using the configured
  api url.

  ### Example
      iex> Jirex.Endpoint.issue_search(%{assignee: "Eric"})
      "https://someteam.atlassian.net/rest/api/2/search?jql=assignee=Eric"
  """

  @spec issue_search(map()) :: String.t()
  def issue_search(params) do
    predicate =
      params
      |> Enum.map(&build_param(&1))
      |> Enum.join("&")

    Application.get_env(:jirex, :jira_api_url) <> "/search?jql=#{predicate}"
  end

  #####
  # Private API
  #####

  defp build_param({field, value}), do: "#{field}=#{value}"
end
