use Mix.Config
config :jirex,
  jira_api_key: System.get_env("JIRA_API_KEY"),
  jira_api_url: System.get_env("JIRA_API_URL")
