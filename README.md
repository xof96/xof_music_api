# XOF Music API

A simple REST API built with Elixir that retrieves an artist's discography from the Deezer API and stores it locally in PostgreSQL for future requests.

## Features

- Retrieve an artist's discography
- Cache artists and albums in PostgreSQL
- Avoid repeated requests to Deezer
- REST API returning JSON
- Dockerized PostgreSQL database

---

# Tech Stack

- Elixir
- Plug
- Bandit
- Ecto
- PostgreSQL
- Docker
- Req
- Jason

---

# Project Structure

```
Router
   │
   ▼
Music
   ├── Repository
   │      │
   │      ▼
   │    PostgreSQL
   │
   └── DeezerClient
          │
          ▼
      Deezer API
```

### Responsibilities

- **Router**
  - HTTP routing
  - Status codes
  - JSON responses

- **Music**
  - Business logic
  - Orchestrates data retrieval
  - Decides whether to use the database or Deezer

- **Repository**
  - Database access

- **DeezerClient**
  - External API communication
  - Response normalization

- **Discography**
  - Converts internal Ecto models into the public API response

---

# Requirements

- Elixir 1.20+
- Erlang / OTP 29
- Docker Desktop
- Git

---

# Installation

Clone the repository

```bash
git clone https://github.com/xof96/xof_music_api.git

cd xof_music_api
```

Start PostgreSQL

```bash
docker compose up -d
```

Install dependencies

```bash
mix deps.get
```

Create the database

```bash
mix ecto.create
```

Run migrations

```bash
mix ecto.migrate
```

Start the server

```bash
mix run --no-halt
```

The API will be available at

```
http://localhost:4000
```

---

# Endpoint

Retrieve an artist's discography

```
GET api/artists/:artist_name/discography
```

Example

```
GET api/artists/Eminem/discography
```

Example response

```json
{
  "name": "Eminem",
  "deezer_id": 13,
  "albums": [
    {
      "name": "The Marshall Mathers LP",
      "release_date": "2000-05-23"
    },
    {
      "name": "Recovery",
      "release_date": "2010-01-01"
    }
  ]
}
```

---

# How it works

1. The API searches the artist in PostgreSQL.
2. If the artist exists, the stored data is returned.
3. Otherwise:
   - the Deezer API is queried,
   - the artist and albums are stored,
   - the normalized response is returned.
4. Future requests are served directly from PostgreSQL.

---

# Development Notes

This project was intentionally designed with separated responsibilities:

- Persistence is isolated inside `Repository`.
- External communication is isolated inside `DeezerClient`.
- Business logic lives in `Music`.
- API responses are generated through `Discography`, avoiding exposure of Ecto schemas outside the persistence layer.