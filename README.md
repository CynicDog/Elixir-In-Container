# Elixir in Container ☁️

## Hello World! 
> This section demonstrates how to run an Elixir app inside a Docker container and interact with it via HTTP and distributed BEAM nodes.

<details> 

#### Pull image from this repository package 
```bash
cynocdig@CynicDogs-MacBook % docker pull ghcr.io/cynicdog/containerized_elixir:latest
```

#### Run Docker container with port 8080 exposed
```bash
cynocdig@CynicDogs-MacBook % docker run -p 8080:8080 --rm -d ghcr.io/cynicdog/containerized_elixir:latest
```

#### httpie to the container..
```bash
cynocdig@CynicDogs-MacBook % http :8080/greet

HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-length: 59
content-type: text/plain; charset=utf-8
date: Tue, 08 Jul 2025 12:26:48 GMT
server: Cowboy

🚀 Elixir inside a container — greetings from the BEAM!
```

</details>


## Communicate with an Elixir Node in Docker Container
> This guide shows how to set up distributed Elixir nodes between your **host machine (macOS)** and a **Docker container** using node names and cookies, and how to call functions remotely.

<details>
  
### On Host Machine 🧑🏻‍💻 

##### Start a BEAM node on the host machine

```bash
cynocdig@CynicDogs-MacBook % iex --name host@host.docker.internal --cookie mycookie
````

### On Docker Container 🐋

##### Run the container with network configuration

```bash
cynocdig@CynicDogs-MacBook % docker run -it --rm \
  --add-host host.docker.internal:host-gateway \
  elixir bash
```

##### Curious about `host.docker.internal`?

If you check the container’s `/etc/hosts` file, you’ll see something like:
```bash
root@container:/# cat /etc/hosts
127.0.0.1	localhost
::1	        localhost ip6-localhost ip6-loopback
...
192.168.65.254	host.docker.internal
```
> That `192.168.65.254 host.docker.internal`  line is a special DNS entry Docker provides to containers to reach the host machine.

##### Start a BEAM node inside the container
```bash
root@3e185f96415a:/# iex --name elixir_node@container --cookie mycookie
```

##### Connect container node to host node
```bash
iex(elixir_node@container)1> Node.connect(:'host@host.docker.internal')
```

### Say Hello to the Host Node!

Define a module on both the host node:

```elixir
defmodule Greet do
  def say_hello do
    IO.puts("Hello 👋🏻 from #{node()}! 🐋")
  end
end
```
> Avoid sending anonymous functions between remote nodes. Distributed BEAM nodes send function “closures” as a serialized object. For remote execution (e.g., `Node.spawn/2`), the function must be sent (serialized) over the network.
 
Then, from the container node IEx shell, call the function remotely on the host node:

```bash
iex(elixir_node@container)2> Node.spawn(:"host@host.docker.internal", Greet, :say_hello, [])
```

</details>

## Inspecting and Using `epmd` in a Container 
> This section explores how to inspect and interact with the **Erlang Port Mapper Daemon (epmd)** inside a running Elixir Docker container. This is useful for understanding how distributed Elixir nodes discover each other via `epmd`.

<details>

#### Start an Elixir Container

```bash
ginsenglee@Ginsengs-MacBook-Air ~ % docker run -it --name nostalgic_banzai \
  --add-host host.docker.internal:host-gateway \
  elixir bash
```

#### Locate the `epmd` Binary

```bash
root@e9e6d65de9af:/# which epmd 
/usr/local/bin/epmd
```

#### Manually Start `epmd`
```
root@e9e6d65de9af:/# epmd -daemon 
root@e9e6d65de9af:/# ps aux | grep epmd
 
root        19  0.0  0.0   2824   928 ?        S    06:46   0:00 epmd -daemon
```

#### Look Up Listening Ports
```
root@e9e6d65de9af:/# netstat -tlnp | grep 4369 
tcp        0      0 0.0.0.0:4369            0.0.0.0:*               LISTEN      19/epmd             
tcp6       0      0 :::4369                 :::*                    LISTEN      19/epmd             
```
> This requires `net-tools` installed on the container. If not installed, run the command of `apt-get update && apt-get install net-tools ` to download the binary.

#### Check for Registered Nodes

Initially there will be no nodes:
```
root@e9e6d65de9af:/# epmd -names
epmd: up and running on port 4369 with data:
```

#### Open a Second Terminal in the Same Container
```
ginsenglee@Ginsengs-MacBook-Air ~ % docker exec -it nostalgic_banzai bash 
```

Start a named Elixir node: 
```
root@e9e6d65de9af:/# iex --name node_in_container_1@container --cookie my_cookie 
```

You should now see this node registered with `epmd` in the first container:

```bash
root@e9e6d65de9af:/# epmd -names
epmd: up and running on port 4369 with data:
name node_in_container_1 at port 33911
```

</details>
