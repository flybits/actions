# Go gRPC Action

GitHub Action for gRPC projects in Golang.

## Inputs

### `path`

The root path to your project.
The default is your repository root path.

### `command`

 A bash script to be run.

## Example Usages

```yaml
name: Main
on: push
jobs:
  grpc:
    name: gRPC
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Generate gRPC
        uses: flybits/actions/go-grpc@master
        with:
          path: ./protobuf
          command: protoc --proto_path=. --go_out=paths=source_relative,plugins=grpc:. example.proto
```
