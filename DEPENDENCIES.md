# Dependencies

This repo uses Terraform and optional tools for linting, documentation generation, security scanning, and Git workflow automation.

## Tools Overview

| Tool | Purpose | Required | Install Method |
|------|---------|----------|-----------------|
| Terraform | Infrastructure as Code | ✅ Yes | Native installers |
| terraform-docs | Auto-generate README docs | Optional | Native installers |
| TFLint | Terraform linting & validation | Optional | Native installers |
| Checkov | Security scanning | Optional | `uv tool install` |
| pre-commit | Git hook automation | Optional | `uv tool install` |

## Installation

### Prerequisites: `uv` Tool

Optional tools (Checkov, pre-commit) use `uv`, a fast Python package installer. Install it first on your platform:

#### Windows

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

#### macOS

```bash
brew install uv
```

#### Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

### Required Tools

#### Terraform

**Purpose:** Infrastructure as Code framework for AWS resource management

##### Windows

```powershell
# Option 1: winget (modern)
winget install --id Hashicorp.Terraform

# Option 2: Chocolatey
choco install terraform
```

##### macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

##### Linux

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

---

### Optional Tools

#### terraform-docs

**Purpose:** Auto-generate Terraform documentation from comments and configuration

##### Windows

```powershell
# Option 1: winget
winget install --id terraform-docs.terraform-docs

# Option 2: Chocolatey
choco install terraform-docs
```

##### macOS

```bash
brew install terraform-docs
```

##### Linux

```bash
TFDOCS_VERSION="v0.21.0"
curl -sLo /tmp/terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION#v}-linux-amd64.tar.gz"
tar -xzf /tmp/terraform-docs.tar.gz -C /tmp
sudo mv /tmp/terraform-docs /usr/local/bin/terraform-docs
```

#### TFLint

**Purpose:** Terraform linter for best practices and security checks

##### Windows

```powershell
# Option 1: Chocolatey
choco install tflint

# Option 2: Manual installation (check latest version at: https://github.com/terraform-linters/tflint/releases)
$ver = "v0.61.0"
$url = "https://github.com/terraform-linters/tflint/releases/download/$ver/tflint_windows_amd64.zip"
$outFile = "$env:TEMP\tflint.zip"
$destPath = "$env:USERPROFILE\.local\bin"

Invoke-WebRequest -Uri $url -OutFile $outFile
Expand-Archive $outFile -DestinationPath $destPath -Force
# Add to PATH if needed (see Windows Troubleshooting section)
```

##### macOS

```bash
brew install tflint
```

##### Linux

```bash
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

#### Checkov

**Purpose:** Security scanning for Infrastructure as Code (detects misconfigurations)

Available on all platforms via `uv`:

```bash
uv tool install checkov
```

#### pre-commit

**Purpose:** Git hook automation for running linters and validators before commits

Available on all platforms via `uv`:

```bash
uv tool install pre-commit
```

---

## Verification

Verify all installed tools are working:

```bash
terraform version
terraform-docs --version
tflint --version
checkov --version
pre-commit --version
```

---

## Troubleshooting

### macOS Issues

#### Homebrew permission denied

If you get permission errors with Homebrew:

```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /usr/local/Cellar
```

#### `uv` not found after install

Restart your terminal session after installing `uv` via Homebrew.

### Linux Issues

#### `curl` or `wget` not found

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y curl wget

# Fedora/RHEL
sudo dnf install -y curl wget
```

#### Permission denied during installation

Some tools require `sudo` for `/usr/local/bin`. Ensure your user has appropriate permissions or use `sudo` for install commands.

### Windows Issues

#### Command not found errors

If commands aren't found after installation, they may not be in your PATH:

1. **winget/Chocolatey installs** — Usually auto-add to PATH; restart PowerShell/Command Prompt

2. **Manual installs** — Ensure `$env:USERPROFILE\.local\bin` is in System PATH:
   ```powershell
   # Check if directory is in PATH
   $env:Path -split ';' | Select-String "\.local\bin"

   # If not present, add permanently (requires admin):
   [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$env:USERPROFILE\.local\bin", "User")
   ```
   After updating PATH, restart PowerShell for changes to take effect.

3. **After installing `uv`** — Restart PowerShell to ensure it's in PATH

#### `uv tool install` fails

Ensure Python 3.7+ is installed and in PATH:

```powershell
python --version
# or
py --version
```

If Python isn't found, install from [python.org](https://www.python.org) or via winget:
```powershell
winget install --id Python.Python.3.12
```

#### pre-commit on Windows

For best compatibility:
- Run pre-commit commands in **PowerShell** (not Command Prompt)
- Ensure Python is in PATH: `python --version`
- Verify `uv` installation: `uv --version`

#### Git hooks not executing

If pre-commit hooks don't run on commit:

```powershell
# Re-install hooks
pre-commit install --install-hooks

# Test hooks manually
pre-commit run --all-files
```
