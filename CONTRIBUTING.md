# Contributing Guidelines

Thank you for your interest in contributing to **k6 Extension Registry**!

To contribute, simply open a pull request.

Before you begin, make sure to familiarize yourself with the [Code of Conduct](CODE_OF_CONDUCT.md). If you've previously contributed to other open source project, you may recognize it as the classic [Contributor Covenant](https://contributor-covenant.org/).

## Contributing to the registry

> [!IMPORTANT]
> Before registering a new extension, please read the [Registry Requirements](https://grafana.com/docs/k6/latest/extensions/explanations/extensions-registry/#registry-requirements).

The source of the registry can be found in the [registry.yaml] file. To register an extension, simply add a new entry to the end of the file. The data of the already registered extension can be modified accordingly.

After modifying the [registry.yaml], it is advisable to [run the linter](#lint---run-the-linter).

[registry.yaml]: registry.yaml

## Contribute to the JSON schema

The source of the JSON schema can be found in the [registry.schema.yaml] file. After the modification, the [schema should be converted](#schema---convert-the-schema-to-json) to JSON format and saved in the [registry.schema.json] file.

[registry.schema.yaml]: registry.schema.yaml
[registry.schema.json]: registry.schema.json

## Tasks

The following sections describe the typical tasks of contributing. As long as the [cdo](https://github.com/szkiba/cdo) tool is installed, these can be easily executed using it (tip: first run the `cdo` command without parameters).

### tools - Install the required tools

Contributing will require the use of some tools, which can be installed most easily with a well-configured [eget] tool.

```bash
eget mikefarah/yq
eget grafana/k6registry
pip install json-schema-for-humans
```

[eget]: https://github.com/zyedidia/eget

### lint - Run the linter

After modifying the [registry.yaml] file, it is recommended to run the static analysis using the [k6registry] command. This may take 1-2 minutes.

```bash
k6registry -q --lint registry.yaml
```

[lint]: #lint---run-the-linter
[k6registry]: https://github.com/grafana/k6registry

### schema - Convert the schema to JSON

The source of the JSON schema is [registry.schema.yaml], after its modification, the schema should be converted into JSON format and saved in [registry.schema.json].

```bash
yq -o=json -P registry.schema.yaml > registry.schema.json
```

### public - Generate static documentation

```bash
npx @redocly/cli build-docs -o public/index.html openapi.yaml
generate-schema-doc --config with_footer=false --config collapse_long_descriptions=false registry.schema.json public
```