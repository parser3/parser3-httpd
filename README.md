# Parser3 HTTPD Application Server

Parser3 HTTPD Application Server based on built-in HTTPD server.

## Start a `parser3` httpd server

```console
$ docker run -p 8080:9000 parser/parser3-httpd
```

...where `-p 8080:9000` is a `{host}:{container}` port mapping. See the [Container networking](https://docs.docker.com/config/containers/container-networking/) documentation for the Docker.

## Default structure in the container
### `/app`
Application directory.

### `/app/cgi`
Parser log directory. You can change it by setting `CGI_PARSER_LOG` environment variable,
```console
$ docker run --env CGI_PARSER_LOG=/path/to/dir parser/parser3-httpd
```

### `/app/www`
It'a a `$request:document-root` for the Parser. Parser3 will start from this directory. You can change it by setting `workdir` for the container:
```console
$ docker run -w /path/to/dir parser/parser3-httpd
```

## Environment variables

`CGI_PARSER_LOG=/app/cgi/parser.log`

## Parser config and `httpd.p`
Parser use `/usr/local/parser3/auto.p` with default configuration and include base `httpd` class. You can place `httpd.p` in you `$request:document-root` with your implementation.
See [documentation](https://www.parser.ru/en/docs/lang/?parserwebserver.htm).

## Links
[Parser](https://www.parser.ru/en/) — official website.

[Documentations](https://www.parser.ru/en/docs/) — Parser3 documentations.
