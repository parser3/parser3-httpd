# Parser3 HTTP Server Application

Parser3 HTTP Server Application is based on built-in HTTP server.

## Starting `parser3` http server

```console
$ docker run -p 8080:9000 parser/parser3-httpd
```

...where `-p 8080:9000` is a `{host}:{container}` port mapping. See the Docker Container networking [documentation](https://docs.docker.com/config/containers/container-networking/).

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
Parser uses `/usr/local/parser3/auto.p` with default configuration which includes base `httpd` class. You can place `httpd.p` in you `$request:document-root` with your implementation.
See [documentation](https://www.parser.ru/en/docs/lang/?parserwebserver.htm).

## Links
[Parser](https://www.parser.ru/en/) — official website.

[Documentations](https://www.parser.ru/en/docs/) — Parser3 documentations.
