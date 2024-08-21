# k6 Extension Registry

The k6 extension registry source is a YAML file ([registry.yaml](registry.yaml)) that contains the most important properties of extensions. An automatic workflow completes the source of the registry with properties that can be queried on the repository manager APIs (versions, stars, etc.) and keeps it up-to-date in a JSON file ([registry.json](https://grafana.github.io/k6-extension-registry/registry.json)).

An up-to-date version of the k6 extension registry is available at https://grafana.github.io/k6-extension-registry/registry.json

If the [registry.json](https://grafana.github.io/k6-extension-registry/registry.json) changes, the [watch](https://github.com/grafana/k6-extension-registry/actions/workflows/watch.yml) workflow creates a `repository_dispatch` event with `extension-registry-changed` event_type parameter to execute external GitHub workflows (for example, the `extension-registry-changed` workflow of the [grafana/k6-extension-catalog](https://github.com/grafana/k6-extension-catalog) repository, which is responsible for keeping the extension catalogs up-to-date)

## Contributing

To contribute, you need to modify the `registry.yaml` file and then open a pull request. The [watch](https://github.com/grafana/k6-extension-registry/actions/workflows/watch.yml) workflow will automatically validate the `registry.yaml` file and, after successful validation, generate the `registry.json` file.

After the pull request is merged, the new extension registry will be automatically deployed to GitHub Pages.

## Registry Validation

The registry is validated using [JSON schema](https://grafana.github.io/k6registry/registry.schema.json). Requirements that cannot be validated using the JSON schema are validated using [custom linter](https://github.com/grafana/k6registry).

Custom linter checks the following for each extension:

  - Is the go module path valid?
  - Is there at least one versioned release?
  - Is a valid license configured?
  - Is the xk6 topic set for the repository?
  - Is the repository not archived?


## Registry Source

The k6 extension registry source is a YAML file that contains the most important properties of extensions.

### File format

The k6 extension registry source format is YAML, because the registry is edited by humans and the YAML format is more human-friendly than JSON. The files generated from the registry are typically in JSON format, because they are processed by programs and JSON is more widely supported than YAML. A JSON format is also generated from the entire registry, so that it can also be processed by programs.

### Registered Properties

Only those properties of the extensions are registered, which either cannot be detected automatically, or delegation to the extension is not allowed.

Properties that are available using the repository manager API (GitHub API, GitLab API, etc) are intentionally not registered. For example, the number of stars can be queried via the repository manager API, so this property is not registered.

Exceptions are the string-like properties that are embedded in the Grafana documentation. These properties are registered because it is not allowed to inject arbitrary text into the Grafana documentation site without approval. Therefore, these properties are registered (eg `description`)

The properties provided by the repository managers ([Repository Metadata]) are queried during registry processing and can be used to produce the output properties.

### Extension Identification

The primary identifier of an extension is the extension's [go module path].

The extension does not have a `name` property, the [repository metadata] can be used to construct a `name` property. Using the repository owner and the repository name, for example, `grafana/xk6-dashboard` can be generated for the `github.com/grafana/xk6-dashboard` extension.

The extension does not have a `url` property, but there is a `url` property in the [repository metadata].

[go module path]: https://go.dev/ref/mod#module-path
[Repository Metadata]: #repository-metadata

### JavaScript Modules

The JavaScript module names implemented by the extension can be specified in the `imports` property. An extension can register multiple JavaScript module names, so this is an array property.

### Output Names

The output names implemented by the extension can be specified in the `outputs` property. An extension can register multiple output names, so this is an array property.

### Tier

Extensions can be classified according to who maintains the extension. This usually also specifies who the user can get support from.

The `tier` property refers to the maintainer of the extension.

Possible values:

  - **official**: Extensions owned, maintained, and designated by Grafana as "official"
  - **partner**: Extensions written, maintained, validated, and published by third-party companies against their own projects.
  - **community**: Extensions are listed on the Registry by individual maintainers, groups of maintainers, or other members of the k6 community.

Extensions owned by the `grafana` GitHub organization are not officially supported by Grafana by default. There are several k6 extensions owned by the `grafana` GitHub organization, which were created for experimental or example purposes only. The `official` tier value is needed so that officially supported extensions can be distinguished from them.

If it is missing from the registry source, it will be set with the default `community` value during generation.

### Products

The `products` property contains the names of the k6 products in which the extension is available.

Some extensions are not available in all k6 products. This may be for a technological or business reason, or the functionality of the extension may not make sense in the given product.

Possible values:

  - **oss**: Extensions are available in *k6 OSS*
  - **cloud**: Extensions are available in *Grafana Cloud k6*

If the property is missing or empty in the source of the registry, it means that the extension is only available in the *k6 OSS* product. In this case, the registry will be filled in accordingly during generation.

### Categories

The `categories` property contains the categories to which the extension belongs.

If the property is missing or empty in the registry source, the default value is "misc".

Possible values:

  - **authentication**
  - **browser**
  - **data**
  - **kubernetes**
  - **messaging**
  - **misc**
  - **observability**
  - **protocol**
  - **reporting**

### Repository Metadata

Repository metadata provided by the extension's git repository manager. Repository metadata are not registered, they are queried at processing time using the repository manager API.

#### Owner

The `owner` property contains the owner of the extension's git repository.

#### Name

The `name` property contains the name of the extension's git repository.

#### License

The `license` property contains the SPDX ID of the extension's license. For more information about SPDX, visit https://spdx.org/licenses/

#### Public

The `true` value of the `public` flag indicates that the repository is public, available to anyone.

#### URL

The `url` property contains the URL of the repository. The `url` is provided by the repository manager and can be displayed in a browser.

#### Homepage

The `homepage` property contains the project homepage URL. If no homepage is set, the value is the same as the `url` property.

#### Stars

The `stars` property contains the number of stars in the extension's repository. The extension's popularity is indicated by how many users have starred the extension's repository.

#### Topics

The `topics` property contains the repository topics. Topics make it easier to find the repository. It is recommended to set the `xk6` topic to the extensions repository.

#### Versions

The `versions` property contains the list of supported versions. Versions are tags whose format meets the requirements of semantic versioning. Version tags often start with the letter `v`, which is not part of the semantic version.

#### Archived

The `true` value of the `archived` flag indicates that the repository is archived, read only.

If a repository is archived, it usually means that the owner has no intention of maintaining it. Such extensions should be removed from the registry.

### Example registry

**Example registry source**

```yaml
- module: github.com/grafana/xk6-dashboard
  description: Web-based metrics dashboard for k6
  outputs:
    - dashboard
  tier: official
  categories:
    - reporting
    - observability

- module: github.com/grafana/xk6-sql
  description: Load test SQL Servers
  imports:
    - k6/x/sql
  tier: official
  products: ["cloud", "oss"]
  categories:
    - data

- module: github.com/grafana/xk6-disruptor
  description: Inject faults to test
  imports:
    - k6/x/disruptor
  tier: official
  categories:
    - kubernetes

- module: github.com/szkiba/xk6-faker
  description: Generate random fake data
  imports:
    - k6/x/faker
  categories:
    - data
```

<details>
<summary><b>Example registry</b></summary>

Registry generated from the source above.

```json file=docs/example.json
[
  {
    "categories": [
      "reporting",
      "observability"
    ],
    "description": "Web-based metrics dashboard for k6",
    "module": "github.com/grafana/xk6-dashboard",
    "outputs": [
      "dashboard"
    ],
    "products": [
      "oss"
    ],
    "repo": {
      "description": "A k6 extension that makes k6 metrics available on a web-based dashboard.",
      "homepage": "https://github.com/grafana/xk6-dashboard",
      "license": "AGPL-3.0",
      "name": "xk6-dashboard",
      "owner": "grafana",
      "public": true,
      "stars": 323,
      "topics": [
        "xk6",
        "xk6-official",
        "xk6-output-dashboard"
      ],
      "url": "https://github.com/grafana/xk6-dashboard",
      "versions": [
        "v0.7.5",
        "v0.7.4",
        "v0.7.3",
        "v0.7.3-alpha.1",
        "v0.7.2",
        "v0.7.1",
        "v0.7.0",
        "v0.7.0-apha.3",
        "v0.7.0-alpha.5",
        "v0.7.0-alpha.4",
        "v0.7.0-alpha.3",
        "v0.7.0-alpha.2",
        "v0.7.0-alpha.1",
        "v0.6.1",
        "v0.6.0",
        "v0.5.5",
        "v0.5.4",
        "v0.5.3",
        "v0.5.2",
        "v0.5.1",
        "v0.5.0",
        "v0.4.4",
        "v0.4.3",
        "v0.4.2",
        "v0.4.1",
        "v0.4.0",
        "v0.3.2",
        "v0.3.1",
        "v0.3.0",
        "v0.2.0",
        "v0.1.3",
        "v0.1.2",
        "v0.1.1",
        "v0.1.0"
      ]
    },
    "tier": "official"
  },
  {
    "categories": [
      "data"
    ],
    "description": "Load test SQL Servers",
    "imports": [
      "k6/x/sql"
    ],
    "module": "github.com/grafana/xk6-sql",
    "products": [
      "cloud",
      "oss"
    ],
    "repo": {
      "description": "k6 extension to load test RDBMSs (PostgreSQL, MySQL, MS SQL and SQLite3)",
      "homepage": "https://github.com/grafana/xk6-sql",
      "license": "Apache-2.0",
      "name": "xk6-sql",
      "owner": "grafana",
      "public": true,
      "stars": 104,
      "topics": [
        "k6",
        "sql",
        "xk6"
      ],
      "url": "https://github.com/grafana/xk6-sql",
      "versions": [
        "v0.4.0",
        "v0.3.0",
        "v0.2.1",
        "v0.2.0",
        "v0.1.1",
        "v0.1.0",
        "v0.0.1"
      ]
    },
    "tier": "official"
  },
  {
    "categories": [
      "kubernetes"
    ],
    "description": "Inject faults to test",
    "imports": [
      "k6/x/disruptor"
    ],
    "module": "github.com/grafana/xk6-disruptor",
    "products": [
      "oss"
    ],
    "repo": {
      "description": "Extension for injecting faults into k6 tests",
      "homepage": "https://k6.io/docs/javascript-api/xk6-disruptor/",
      "license": "AGPL-3.0",
      "name": "xk6-disruptor",
      "owner": "grafana",
      "public": true,
      "stars": 87,
      "topics": [
        "chaos-engineering",
        "fault-injection",
        "k6",
        "testing",
        "xk6"
      ],
      "url": "https://github.com/grafana/xk6-disruptor",
      "versions": [
        "v0.3.11",
        "v0.3.10",
        "v0.3.9",
        "v0.3.8",
        "v0.3.7",
        "v0.3.6",
        "v0.3.5",
        "v0.3.5-rc2",
        "v0.3.5-rc1",
        "v0.3.4",
        "v0.3.3",
        "v0.3.2",
        "v0.3.1",
        "v0.3.0",
        "v0.2.1",
        "v0.2.0",
        "v0.1.3",
        "v0.1.2",
        "v0.1.1",
        "v0.1.0"
      ]
    },
    "tier": "official"
  },
  {
    "categories": [
      "data"
    ],
    "description": "Generate random fake data",
    "imports": [
      "k6/x/faker"
    ],
    "module": "github.com/szkiba/xk6-faker",
    "products": [
      "oss"
    ],
    "repo": {
      "description": "Random fake data generator for k6.",
      "homepage": "http://ivan.szkiba.hu/xk6-faker/",
      "license": "AGPL-3.0",
      "name": "xk6-faker",
      "owner": "szkiba",
      "public": true,
      "stars": 49,
      "topics": [
        "xk6",
        "xk6-javascript-k6-x-faker"
      ],
      "url": "https://github.com/szkiba/xk6-faker",
      "versions": [
        "v0.3.0",
        "v0.3.0-alpha.1",
        "v0.2.2",
        "v0.2.1",
        "v0.2.0",
        "v0.1.0"
      ]
    },
    "tier": "community"
  },
  {
    "categories": [
      "misc"
    ],
    "description": "A modern load testing tool, using Go and JavaScript",
    "module": "go.k6.io/k6",
    "products": [
      "cloud",
      "oss"
    ],
    "repo": {
      "description": "A modern load testing tool, using Go and JavaScript - https://k6.io",
      "homepage": "https://github.com/grafana/k6",
      "license": "AGPL-3.0",
      "name": "k6",
      "owner": "grafana",
      "public": true,
      "stars": 24285,
      "topics": [
        "es6",
        "go",
        "golang",
        "hacktoberfest",
        "javascript",
        "load-generator",
        "load-testing",
        "performance"
      ],
      "url": "https://github.com/grafana/k6",
      "versions": [
        "v0.53.0",
        "v0.52.0",
        "v0.51.0",
        "v0.50.0",
        "v0.49.0",
        "v0.48.0",
        "v0.47.0",
        "v0.46.0",
        "v0.45.1",
        "v0.45.0",
        "v0.44.1",
        "v0.44.0",
        "v0.43.1",
        "v0.43.0",
        "v0.42.0",
        "v0.41.0",
        "v0.40.0",
        "v0.39.0",
        "v0.38.3",
        "v0.38.2",
        "v0.38.1",
        "v0.38.0",
        "v0.37.0",
        "v0.36.0",
        "v0.35.0",
        "v0.34.1",
        "v0.34.0",
        "v0.33.0",
        "v0.32.0",
        "v0.31.1",
        "v0.31.0",
        "v0.30.0",
        "v0.29.0",
        "v0.28.0",
        "v0.27.1",
        "v0.27.0",
        "v0.26.2",
        "v0.26.1",
        "v0.26.0",
        "v0.25.1",
        "v0.25.0",
        "v0.24.0",
        "v0.23.1",
        "v0.23.0",
        "v0.22.1",
        "v0.22.0",
        "v0.21.1",
        "v0.21.0",
        "v0.20.0",
        "v0.19.0",
        "v0.18.2",
        "v0.18.1",
        "v0.18.0",
        "v0.17.2",
        "v0.17.1",
        "v0.17.0",
        "v0.16.0",
        "v0.15.0",
        "v0.14.0",
        "v0.13.0",
        "v0.12.2",
        "v0.12.1",
        "v0.11.0",
        "v0.10.0",
        "v0.9.3",
        "v0.9.2",
        "v0.9.1",
        "v0.9.0",
        "v0.8.5",
        "v0.8.4",
        "v0.8.3",
        "v0.8.2",
        "v0.8.1",
        "v0.8.0",
        "v0.7.0",
        "v0.6.0",
        "v0.5.2",
        "v0.5.1",
        "v0.5.0",
        "v0.4.5",
        "v0.4.4",
        "v0.4.3",
        "v0.4.2",
        "v0.4.1",
        "v0.4.0",
        "v0.3.0",
        "v0.2.1",
        "v0.2.0",
        "v0.0.2",
        "v0.0.1"
      ]
    },
    "tier": "official"
  }
]
```

</details>

