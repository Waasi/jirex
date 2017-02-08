defmodule Jirex.Issue do
  @moduledoc """
  Jirex.Issue provides functions to manage
  JIRA Issues. It also provides a Struct for
  JIRA Issues for easy access of values.

  ### Functions
      - get/1
      - search/1
      - transitions/1
      - move/2
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
    [Endpoint.issue_get, id]
    |> Enum.join()
    |> HTTPoison.get(headers)
    |> parse_response()
  end


  @doc """
  The search/1 function takes a Map type
  filters and it returns a tuple containing
  the status and the list of matching issues
  as a Jirex.Issue struct.

  ### Examples
      iex> Jirex.Issue.search(%{"status" => 3})
      {:ok, [%Jirex.Issue{assignee: "Juan del Pueblo", status: "In Progress", summary: "Hello", desciption: "weepaaa"}]}

      iex> Jirex.Issue.get(%{"wepaaa" => "boricua"})
      {:error, error}
  """

  @spec search(map()) :: {:ok, list()} | {:error, String.t()}
  def search(filter) do
    filter
    |> Endpoint.issue_search()
    |> HTTPoison.get(headers)
    |> parse_response()
  end

  @doc """
  The transitions/1 function takes a String type
  id and it returns a tuple containing the status
  and the list of transitions for the given issue.

  ### Examples
      iex> Jirex.Issue.transitions("ISU-12")
      {:ok, %{"Done" => "31", "In Progress" => "21", "To Do" => "11"}}

      iex> Jirex.Issue.transitions("unknown")
      {:error, error}
  """

  @spec transitions(String.t()) :: {:ok, list()} | {:error, String.t()}
  def transitions(issue) do
    issue
    |> Endpoint.issue_transitions()
    |> HTTPoison.get(headers)
    |> parse_response()
  end

  @doc """
  The move/2 function takes a String type
  id and String type destination column.
  It returns :ok or an error tuple.

  ### Examples
      iex> Jirex.Issue.move("ISU-12", "Done")
      :ok

      iex> Jirex.Issue.move("ISU-12", "unknown")
      {:error, error}
  """

  @spec move(String.t(), String.t()) :: :ok | {:error, String.t()}
  def move(issue, destination) do
    with {:ok, transition_list} <- transitions(issue),
         {:ok, action_id} <- transition_list |> Map.fetch(String.downcase(destination)),
         payload = %{transition: %{id: action_id}} |> Poison.encode!() do

      issue
      |> Endpoint.issue_transitions()
      |> HTTPoison.post(payload, headers)
      |> parse_response()
    end
  end

  #####
  # Private API
  #####

  defp parse_response({:ok, %HTTPoison.Response{body: "", status_code: 204}}), do: :ok
  defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
    with {:ok, issue} <- body |> Poison.decode() do
      issue |> parse_issue()
    end
  end

  defp parse_issue(%{"issues" => issues}) do
    issue_list =
      issues
      |> Enum.map(&parse_issue/1)
      |> Enum.map(&clean/1)

    {:ok, issue_list}
  end
  defp parse_issue(%{"expand" => "transitions", "transitions" => transitions}) do
    transition_list =
      transitions
      |> Enum.map(&parse_transition(&1))
      |> Enum.reduce(%{}, &Map.merge(&1, &2))

    {:ok, transition_list}
  end
  defp parse_issue(%{"expand" => _expand_value} = issue) do
    {:ok, %__MODULE__{
      assignee: get_in(issue, ["fields", "assignee", "displayName"]),
      status: get_in(issue, ["fields", "status", "statusCategory", "name"]),
      summary: get_in(issue, ["fields", "summary"]),
      description: get_in(issue, ["fields", "status", "description"])}}
  end
  defp parse_issue(%{"errorMessages" => [error]}), do: {:error, error}

  defp parse_transition(%{"id" => id, "name" => name}), do: %{String.downcase(name) => id}

  defp clean({:ok, issue}), do: issue

  defp headers do
    [{"authorization", "Basic #{Config.api_key}"}, {"Content-Type", "application/json"}]
  end
end
