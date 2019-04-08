# agent-webhooks-buildkite-plugin

A [Buildkite agent plugin](https://buildkite.com/docs/pipelines/plugins) that
adds webhooks to the agent.

## Configuration

```yaml
steps:
  - command: true
    plugins:
      - uri-canva/agent-webhooks#v0.1:
          endpoint: https://api.example.com/event
          headers:
            - "X-Webhook-Token: 0123456789abcdef"
```

## Events

All events contain a field for each `BUILDKITE_*` environment variable, plus an
`event` field for which hook it was posted from:

* `agent.pre-checkout`
* `agent.post-checkout`
* `agent.pre-command`
* `agent.post-command`
* `agent.pre-artifact`
* `agent.post-artifact`
* `agent.pre-exit`