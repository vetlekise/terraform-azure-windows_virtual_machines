# Information
This document provides an overview of this docs directory and the template's development tooling.

## File Structure
| File | Description |
|--|--|
| [docs](./docs) | Additional documentation, images for README.md and more. |
| [examples](./examples) | Executable example usage of the module. |
| [modules](./modules) | Submodules used by the root module. |
| [locals.tf](./locals.tf) | Defines named, reusable expressions within the module. |
| [main.tf](./main.tf) | Core resources and their configurations. |
| [outputs.tf](./outputs.tf) | Declares values to be outputted after applying. |
| [variables.tf](./variables.tf) | Defines input parameters to customize the module. |
| [versions.tf](./versions.tf) | Specifies required provider versions and the Terraform version for the module. |

## Dependencies
### [Release Drafter](https://github.com/release-drafter/release-drafter)
Automates the creation of draft release notes for your GitHub releases based on merged pull requests.

#### Configuration
| File | Description |
|--|--|
| [.github/workflows/release-drafter.yml](./.github/workflows/release-drafter.yml) | Contains the workflow that runs Release Drafter. |
| [.github/release-drafter.yml](./.github/release-drafter.yml) | Contains the configuration of Release Drafter. |

### [Terraform Docs](https://github.com/terraform-docs/terraform-docs/?tab=readme-ov-file)
Generates documentation from Terraform modules in various output formats (e.g., Markdown tables for READMEs). This helps keep your module's inputs, outputs, and providers documentation up-to-date.

#### Configuration
| File | Description |
|--|--|
| [.github/workflows/terraform-docs.yml](./.github/workflows/terraform-docs.yml) | Contains the workflow that runs Terraform Docs. |
| [.terraform-docs.yml](./.terraform-docs.yml) | Contains the configuration of Terraform Docs. |

### Linting & Security Scanning: [TFLint](https://github.com/terraform-linters/tflint), [Trivy](https://github.com/aquasecurity/trivy) & [Checkov](https://github.com/bridgecrewio/checkov)
These tools help ensure your Terraform code is valid, follows best practices, and is free from common security vulnerabilities.
* **TFLint**: A pluggable Terraform linter to enforce coding standards and catch errors.
* **Trivy**: A comprehensive security scanner that can find vulnerabilities in your Infrastructure as Code (IaC).
* **Checkov**: A static code analysis tool for IaC to find misconfigurations that may lead to security or compliance problems.

#### Configuration
| File | Description |
|--|--|
| [.github/workflows/terraform-linter.yml](./.github/workflows/terraform-docs.yml) | Contains the workflow that runs TFLint, Trivy & Checkov. |
| [.tflint.hcl](./.tflint.hcl) | Contains the configuration of TFLint. |
| [.checkov.yaml](./.checkov.yaml) | Contains the configuration of Chekov. |
| [trivy.yaml](./trivy.yaml) | Contains the configuration of Trivy. |

### [Pre-commit](https://github.com/pre-commit/pre-commit)
A framework for managing and maintaining multi-language pre-commit hooks. It runs checks on your code before you commit, helping to enforce code quality and catch issues early.

#### Configuration
| File | Description |
|--|--|
| [.pre-commit-config.yaml](./.pre-commit-config.yaml) | Contains the configuration of pre-commit. |

#### Usage
First, install dependencies:

**macOS**
```bash
brew install python
brew install terraform
brew install tflint
brew install aquasecurity/trivy/trivy
brew install terraform-docs
brew install checkov
brew install pre-commit
```

**Windows**
```powershell
choco install python --pre
choco install terraform
choco install tflint
choco install trivy
choco install terraform-docs
pip install checkov
pip install pre-commit
```

1. Install git hooks: `pre-commit install`
1. Manually run all files: `pre-commit run --all-files`
1. Manually run a specific hook: `pre-commit run <hook_id>`
1. Skip hooks: `git commit --no-verify -m "Your commit message"`
