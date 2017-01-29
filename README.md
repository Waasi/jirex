# Jirex

Jirex is a simple client for JIRA REST API.

## Installation

  ```elixir
  def deps do
    [{:jirex, "~> 0.1.0"}]
  end
  ```

## Configuration

First generate your api key using your username and password:

  - Construct the following string with your credentials: `user:passwd`
  - Encode with Base 64 the generated string

Then proceed to configure jirex:

  - `export JIRA_API_KEY=<insert_jira_api_key_here>`
  - `export JIRA_API_URL=<insert_jira_api_url_here>`

## Usage

Jirex curently supports get action for issues.

### Jirex.Issue

To get a issue with key TEST-14 do:

```elixir
iex> Jirex.Issue.get("TEST-14")
{:ok, %Jirex.Issue{assignee: "Juan del Pueblo", status: "In Progress", summary: "Hello", desciption: "weepaaa"}}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jirex/fork )
2. Create your feature branch (`git checkout -b feature/my_new_feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
