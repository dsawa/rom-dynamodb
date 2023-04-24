# ROM DynamoDB Adapter

Original repository (forked from): https://github.com/davidkelley/rom-dynamodb
It seems that above is not maintained anymore. This fork updates gem to use with latest rom and aws-sdk versions.
Soon it will be adapted for use with Ruby 3. For now tested and

This adapter uses [ROM (>= 5.3.0)](http://rom-rb.org/) to provide an easy-to-use, clean and understandable interface for [AWS DynamoDB](https://aws.amazon.com/documentation/dynamodb/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rom-dynamodb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-dynamodb

## Usage

The following container setup is for demonstration purposes only. You should follow the standard way of integrating ROM into your environment, as [documented here](https://rom-rb.org/learn/core/5.2/quick-setup/).

```ruby
require 'rom/dynamodb'

TABLE = "my-dynamodb-users-table"

# any other Aws::DynamoDB::Client options
credentials = { region: 'us-east-1' }

container = ROM.container(:dynamodb, credentials) do |rom|
  rom.relations[:users] do
    # Key Schema: id<Hash>
    dataset TABLE

    def by_id(val)
      where { id == val }
    end
  end

  rom.commands[:users] do
    FILTER = Functions[:symbolize_keys] >> Functions[:accept_keys, [:id]]

    define(:create) do
      KEYS = %w(id name)
      result :one
      input Functions[:accept_keys, KEYS]
    end

    define(:delete) do
      result :one
      input FILTER
    end

    define(:update) do
      result :one
      input FILTER
    end
  end
end

relation = container.relations[:users]

relation.count # => 1234

relation.where { id == 1 }.one! # => { id: 1, name: "David" }

relation.info # => <Hash> DynamoDB Table Information

relation.status # => :active

# create a new user
create = container.commands[:users][:create]
user = create.call({ id: 2, name: "James" })

# update an existing user
update = container.commands[:users][:update]
update.by_id(user[:id]).call(name: "Mark")

relation.where(id: user[:id]) { id == id }.one! # => { id: 2, name: "Mark" }

# delete an existing user
delete = container.commands[:users][:delete]
delete.by_id(user[:id]).call
```
---

#### Querying a composite key DynamoDB Table

```ruby
container = ROM.container(:dynamodb, credentials) do |rom|
  rom.relations[:logs] do
    # Key Schema: host<Hash>, timestamp<Range>
    dataset "my-logs-table"

    def by_host(ip)
      where { host == ip }
    end

    def after_timestamp(time)
      where { timestamp > time }
    end

    def before_timestamp(time)
      where { timestamp < time }
    end
  end

  rom.commands(:logs) do
    define(:create) do
      KEYS = %w(host timestamp message)
      result :one
      input Functions[:accept_keys, KEYS]
    end
  end
end

num_of_logs = 20

host = "192.168.0.1"

logs = (1..num_of_logs).to_a.collect do |i|
  { host: host, timestamp: Time.now.to_f + (i * 60), message: "some message" }
end

# create fake logs
container.commands[:logs][:create].call(logs)

relation = container.relations[:logs]

relation.count == num_of_logs # => true

all = relation.where(ip: host) { host == ip }.after(0).to_a # => [{host: "192.168.0.1", ... }, ...]

all.size # => 20

before = relation.where(ip: host) { [host == ip, timestamp < (Time.now.to_f + 60 * 60)] }.limit(1).to_a

before.size # => 1

before.first == logs.first # => true

offset = { ip: host, timestamp: logs[-2][:timestamp] }

last = relation.where(ip: host) { ip == host }.descending.after(0).offset(offset).limit(1).one!

last == logs.last # => true
```

---

## Development

All development takes place inside [Docker Compose](). Run the following commands to get setup:

```
$ docker-compose pull
$ docker-compose build
```

You can then begin developing, running RSpec tests with the following command:

```
$ docker-compose run --rm rom rspec [args...]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dsawa/rom-dynamodb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
