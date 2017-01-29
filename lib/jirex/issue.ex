defmodule Jirex.Issue do
  @moduledoc """
  Jirex.Issue provides functions to manage
  JIRA Issues. It also provides a Struct for
  JIRA Issues for easy access of values.
  """

  alias Jirex.Endpoint
  alias Jirex.Config

  @type issue() :: Jirex.Issue
  defstruct assignee: nil, status: nil, summary: nil, description: nil

  #####
  # Public API
  #####

  @doc """
  The get/1 function takes a String type
  id and it returns a tuple containing
  the status and the issue itself as a
  Jirex.Issue struct.

  ### Examples
      iex> Jirex.Issue.get("ISU-12")
      {:ok, %Jirex.Issue{assignee: "Juan del Pueblo", status: "In Progress", summary: "Hello", desciption: "weepaaa"}}

      iex> Jirex.Issue.get("unknown")
      {:error, error}
  """

  @spec get(String.t()) :: {:ok, issue()} | {:error, String.t()}
  def get(id) do
    [Endpoint.issue, id]
    |> Enum.join()
    |> HTTPoison.get([{"authorization", "Basic #{Config.api_key}"}])
    |> parse_response()
  end

  #####
  # Private API
  #####

  defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
    with {:ok, issue} <- body |> Poison.decode(),
         %{"expand" => _expand_value} <- issue do

      {:ok, %__MODULE__{
        assignee: get_in(issue, ["fields", "assignee", "displayName"]),
        status: get_in(issue, ["fields", "status", "statusCategory", "name"]),
        summary: get_in(issue, ["fields", "summary"]),
        description: get_in(issue, ["fields", "status", "description"])}}
    else
      %{"errorMessages" => [error|_]} ->
        {:error, error}
    end
  end
end
