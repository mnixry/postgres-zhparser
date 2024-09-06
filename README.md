# postgres-zhparser

Docker build scripts for <https://github.com/amutu/zhparser> PostgreSQL extension.

[![Docker Image CI](https://github.com/mnixry/postgres-zhparser/actions/workflows/main.yml/badge.svg)](https://github.com/mnixry/postgres-zhparser/actions/workflows/main.yml)

[![Docker Pulls](https://img.shields.io/docker/pulls/mixdeve/postgres-zhparser?style=for-the-badge)](https://hub.docker.com/r/mixdeve/postgres-zhparser)


## Usage

- Supported versions:
  - 12
  - 13
  - 14
  - 15
  - 16

- Supported architectures:
  - `linux/amd64`
  - `linux/arm64`

```bash
docker run -d \
    --name postgres \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    ghcr.io/mnixry/postgres-zhparser:16
```

That's it. You can now connect to the PostgreSQL server, or use `psql` to test the extension:

```bash
docker exec -it postgres psql -U postgres
# > select to_tsvector('chinese', '小明爱吃苹果');
# ---------------------------------
#  '吃':3 '小明':1 '爱':2 '苹果':4
# (1 row)
```

## License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
