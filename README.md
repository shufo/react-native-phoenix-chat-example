An example React Native chat application with [Phoenix](http://www.phoenixframework.org/).

## Requirements

- [React Native](https://facebook.github.io/react-native/) (Tested on `0.40.0`)
- [Elixir](http://elixir-lang.org/) (Tested on `1.3.4`)
- [docker](https://www.docker.com/) (Tested on `1.13.0`)
- [docker-compose](https://docs.docker.com/compose/) (Tested on `1.10.0`)

## Installation

### Client

- Build React Native client

```bash
cd client
npm install
# ios
react-native run-ios
# android
react-native run-android
```

#### Running on real device

If you running the application on an actual device, replace api server endpoint with your host ip address.

`Chat.js`

```js
const URL = '//localhost/socket'
```

`Root.js`

```js
const HOST = 'localhost'
```

### Server

- Running phoenix server with docker

```bash
cd server
make up
```

- see logs

```bash
$ docker logs -f chat_app
...
[info] Running Server.Endpoint with Cowboy using http://localhost:4000

# Confirm Running
$ curl localhost/messages
{"messages":[]}%
```

#### Running server manually

- Run Redis and Postgres on localhost
- Configure postgres username & password

`config/dev.exs`

```elixir
username: "postgres",
password: "postgres",
database: "server_dev",
hostname: "localhost",
```

configure redis host

```elixir
config :redix,
  host: "localhost",
```

- Run Phoenix server

```
mix deps.get
mix phoenix.server
```
