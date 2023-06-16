# Record DuckDB Extension

A DuckDB extension to read, write & analyze records from binary or text encoded files

### record_analyze

```duckdb
D select * from record_analyze('./input');
┌───────────────┐
│    result     │
│    varchar    │
├───────────────┤
│ Quack Jane 🐥 │
└───────────────┘
```

### record_detect

```duckdb
D select * from record_detect('./input');
┌───────────────┐
│    result     │
│    varchar    │
├───────────────┤
│ Quack Jane 🐥 │
└───────────────┘
```

### record_scan

```duckdb
D select * from record_scan('./input', '{ "name": "PIC(X(20))", "age": "PIC(9(3)), "salary": "PIC(9(10)V99)" }');
┌───────────────┐
│    result     │
│    varchar    │
├───────────────┤
│ Quack Jane 🐥 │
└───────────────┘
```

### record_write

```duckdb
D select * from record_write('./input', '{ "name": "Scrooge McDuck", "age": 40, "salary": 1000000.13 }');
┌───────────────┐
│    result     │
│    varchar    │
├───────────────┤
│ Quack Jane 🐥 │
└───────────────┘
```

## Development

Use the official DuckDB `cmake` builder

```sh
make
```

Or... use the experimental `nix` flake and `zig` builder within this repo

```sh
nix run .#build-fast
```

## Test

```sh
make test
```

### Installing the deployed binaries

To install your extension binaries from S3, you will need to do two things. Firstly, DuckDB should be launched with the
`allow_unsigned_extensions` option set to true. How to set this will depend on the client you're using. Some examples:

CLI:
```shell
duckdb -unsigned
```

Python:
```python
con = duckdb.connect(':memory:', config={'allow_unsigned_extensions' : 'true'})
```

NodeJS:
```js
db = new duckdb.Database(':memory:', {"allow_unsigned_extensions": "true"});
```

Secondly, you will need to set the repository endpoint in DuckDB to the HTTP url of your bucket + version of the extension
you want to install. To do this run the following SQL query in DuckDB:
```sql
SET custom_extension_repository='bucket.s3.eu-west-1.amazonaws.com/<your_extension_name>/latest';
```
Note that the `/latest` path will allow you to install the latest extension version available for your current version of
DuckDB. To specify a specific version, you can pass the version instead.

After running these steps, you can install and load your extension using the regular INSTALL/LOAD commands in DuckDB:
```sql
INSTALL record
LOAD record
```
