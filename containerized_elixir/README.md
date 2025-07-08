# ContainerizedElixir 🚀

A minimal Elixir web application running inside a Docker container using [Plug](https://hexdocs.pm/plug) and [Cowboy](https://github.com/ninenines/cowboy).  

This app serves a simple HTTP endpoint `/greet` that responds with a friendly message from the BEAM inside the container.

---

## Features

- Simple HTTP server powered by Plug and Cowboy
- Single `/greet` route responding with a plain-text greeting
- Designed to run containerized with Docker
