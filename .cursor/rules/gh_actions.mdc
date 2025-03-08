# Homebrew Tap Formula Creation Guide

Standards and best practices for creating and maintaining Homebrew tap formulas.

<rule>
name: homebrew_tap_formula
description: Guide for creating and maintaining Homebrew tap formulas
filters:
  # Match Ruby files in Formula directory
  - type: file_path
    pattern: "Formula/.*\\.rb$"
  # Match Ruby files with Formula class
  - type: content
    pattern: "class .*< Formula"
  # Match formula creation events
  - type: event
    pattern: "file_create"

actions:
  - type: suggest
    message: |
      # Homebrew Tap Formula Creation Guide

      This guide provides standards and best practices for creating and maintaining Homebrew tap formulas.

      ## Formula Structure

      A Homebrew formula is a Ruby file that describes how to install a package. Here's the standard structure:

      ```ruby
      # typed: false
      # frozen_string_literal: true

      class PackageName < Formula
        desc "Short description of the package"
        homepage "https://example.com/package"
        url "https://example.com/package-1.0.0.tar.gz"
        sha256 "checksum_of_the_package"
        license "MIT"  # or appropriate license

        # Optional: specify head for development version
        head "https://github.com/user/package.git", branch: "main"

        # Dependencies
        depends_on "dependency1"
        depends_on "dependency2"
        depends_on "dependency3" => :optional  # Optional dependency

        # Platform-specific code
        on_macos do
          if Hardware::CPU.intel?
            # Intel-specific code
          end
          if Hardware::CPU.arm?
            # ARM-specific code
          end
        end

        on_linux do
          if Hardware::CPU.intel?
            # Linux Intel-specific code
          end
          if Hardware::CPU.arm?
            # Linux ARM-specific code
          end
        end

        def install
          # Installation steps
          system "./configure", "--prefix=#{prefix}"
          system "make", "install"

          # Install completions if available
          bash_completion.install "completions/package.bash"
          fish_completion.install "completions/package.fish"
          zsh_completion.install "completions/_package"
        end

        def caveats
          <<~EOS
            Additional information or warnings for users.
            For example, how to enable the package in their shell.
          EOS
        end

        test do
          # Test commands to verify installation
          system "#{bin}/package", "--version"
        end
      end
      ```

      ## Versioned Formulas

      For versioned formulas (e.g., `package@1.0.0`), follow this naming convention:

      ```ruby
      class PackageAT100 < Formula
        # Formula content
      end
      ```

      ## Best Practices

      ### 1. Formula Naming

      - Use lowercase for formula names
      - For versioned formulas, use `@` followed by the version number
      - Convert version dots to underscores in the class name (e.g., `1.0.0` becomes `100`)

      ### 2. Dependencies

      - Only include direct dependencies
      - Use `:optional` for optional dependencies
      - Use `:recommended` for recommended but not required dependencies
      - Use `:build` for build-time dependencies

      ```ruby
      depends_on "openssl@3"
      depends_on "readline"
      depends_on "python" => :optional
      depends_on "cmake" => :build
      ```

      ### 3. Installation

      - Use `#{prefix}` for the installation prefix
      - Use `#{bin}`, `#{lib}`, etc. for standard directories
      - Install documentation to `#{doc}`
      - Install completions to `bash_completion`, `fish_completion`, and `zsh_completion`

      ### 4. Platform-Specific Code

      - Use `on_macos` and `on_linux` blocks for platform-specific code
      - Check CPU architecture with `Hardware::CPU.intel?` and `Hardware::CPU.arm?`
      - Provide separate URLs and installation steps if necessary

      ### 5. Testing

      - Include a `test` block to verify the installation
      - Test that the binary runs and produces expected output
      - Keep tests simple and fast

      ### 6. Caveats

      - Use the `caveats` method to provide additional information
      - Include instructions for enabling the package
      - Mention any post-installation steps

      ## Common Patterns

      ### Installing from GitHub Releases

      ```ruby
      url "https://github.com/user/repo/archive/refs/tags/v#{version}.tar.gz"
      ```

      ### Installing Binary Releases

      ```ruby
      if OS.mac? && Hardware::CPU.intel?
        url "https://example.com/package-#{version}-mac-x86_64.tar.gz"
        # ...
      elsif OS.mac? && Hardware::CPU.arm?
        url "https://example.com/package-#{version}-mac-arm64.tar.gz"
        # ...
      elsif OS.linux? && Hardware::CPU.intel?
        url "https://example.com/package-#{version}-linux-x86_64.tar.gz"
        # ...
      end
      ```

      ### Installing from Git

      ```ruby
      url "https://github.com/user/repo.git", tag: "v#{version}"
      ```

      ### Building from Source

      ```ruby
      def install
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}"
        system "make", "install"
      end
      ```

      ### Installing a Go Package

      ```ruby
      def install
        system "go", "build", *std_go_args(ldflags: "-s -w")
      end
      ```

      ### Installing a Node.js Package

      ```ruby
      def install
        system "npm", "install", *Language::Node.std_npm_install_args(libexec)
        bin.install_symlink Dir["#{libexec}/bin/*"]
      end
      ```

      ## ASDF Version Manager Formulas

      For ASDF version manager formulas, follow these additional guidelines:

      1. Disable automatic updates by creating an empty file:
         ```ruby
         touch libexec/"asdf_updates_disabled"
         ```

      2. Install the entire package to `libexec` and create a script in `bin`:
         ```ruby
         libexec.install Dir["*"]
         bin.write_exec_script libexec/"bin/asdf"
         ```

      3. Include appropriate caveats for shell initialization:
         ```ruby
         def caveats
           s = "To use asdf, add the following line to your #{shell_profile}:\n"
           s += if preferred == :fish
             "  source #{opt_libexec}/asdf.fish\n\n"
           else
             "  . #{opt_libexec}/asdf.sh\n\n"
           end
           s += "Restart your terminal for the settings to take effect."
           s
         end
         ```

examples:
  - input: |
      # Creating a formula for a simple CLI tool
      I need to create a formula for a CLI tool that's distributed as a tarball.
    output: |
      Here's a formula for a simple CLI tool distributed as a tarball:

      ```ruby
      # typed: false
      # frozen_string_literal: true

      class SimpleCli < Formula
        desc "Command-line tool for doing simple things"
        homepage "https://example.com/simple-cli"
        url "https://example.com/downloads/simple-cli-1.2.3.tar.gz"
        sha256 "abcdef1234567890abcdef1234567890abcdef1234567890"
        license "MIT"

        depends_on "libfoo"
        depends_on "libbar"

        def install
          system "./configure", "--prefix=#{prefix}"
          system "make"
          system "make", "install"

          # Install completions
          bash_completion.install "completions/simple-cli.bash"
          fish_completion.install "completions/simple-cli.fish"
          zsh_completion.install "completions/_simple-cli"
        end

        test do
          assert_match "simple-cli version 1.2.3", shell_output("#{bin}/simple-cli --version")
        end
      end
      ```

      This formula:
      1. Defines metadata (description, homepage, URL, checksum, license)
      2. Specifies dependencies
      3. Implements the installation process
      4. Installs shell completions
      5. Includes a test to verify the installation

  - input: |
      # Creating a versioned formula for a specific version of a tool
      I need to create a formula for version 2.1.0 of a tool that already has a formula for the latest version.
    output: |
      Here's how to create a versioned formula for a specific version:

      ```ruby
      # typed: false
      # frozen_string_literal: true

      class ToolAT210 < Formula
        desc "Specific version (2.1.0) of the tool"
        homepage "https://example.com/tool"
        url "https://example.com/downloads/tool-2.1.0.tar.gz"
        sha256 "abcdef1234567890abcdef1234567890abcdef1234567890"
        license "Apache-2.0"

        keg_only :versioned_formula

        depends_on "dependency1"
        depends_on "dependency2"

        def install
          system "./configure", "--prefix=#{prefix}"
          system "make", "install"
        end

        test do
          assert_match "2.1.0", shell_output("#{bin}/tool --version")
        end
      end
      ```

      Key points for versioned formulas:
      1. Name the class with `AT` followed by the version with dots replaced by underscores
      2. Add `keg_only :versioned_formula` to prevent conflicts with the main formula
      3. Specify the exact version in the URL and tests
      4. Include appropriate dependencies for this specific version

  - input: |
      # Creating a formula for a tool with platform-specific binaries
      I need to create a formula for a tool that provides different binaries for different platforms.
    output: |
      Here's a formula for a tool with platform-specific binaries:

      ```ruby
      # typed: false
      # frozen_string_literal: true

      class PlatformTool < Formula
        desc "Tool with platform-specific binaries"
        homepage "https://example.com/platform-tool"
        version "3.0.1"
        license "MIT"

        on_macos do
          if Hardware::CPU.intel?
            url "https://example.com/downloads/platform-tool-3.0.1-macos-x86_64.tar.gz"
            sha256 "abcdef1234567890abcdef1234567890abcdef1234567890"

            def install
              bin.install "platform-tool"
              # Mac Intel-specific installation steps
            end
          end
          if Hardware::CPU.arm?
            url "https://example.com/downloads/platform-tool-3.0.1-macos-arm64.tar.gz"
            sha256 "123456abcdef123456abcdef123456abcdef123456abcdef"

            def install
              bin.install "platform-tool"
              # Mac ARM-specific installation steps
            end
          end
        end

        on_linux do
          if Hardware::CPU.intel?
            url "https://example.com/downloads/platform-tool-3.0.1-linux-x86_64.tar.gz"
            sha256 "fedcba0987654321fedcba0987654321fedcba0987654321"

            def install
              bin.install "platform-tool"
              # Linux Intel-specific installation steps
            end
          end
          if Hardware::CPU.arm?
            url "https://example.com/downloads/platform-tool-3.0.1-linux-arm64.tar.gz"
            sha256 "abcdef1234567890abcdef1234567890abcdef1234567890"

            def install
              bin.install "platform-tool"
              # Linux ARM-specific installation steps
            end
          end
        end

        test do
          assert_match "3.0.1", shell_output("#{bin}/platform-tool --version")
        end
      end
      ```

      This formula:
      1. Uses platform-specific blocks with `on_macos` and `on_linux`
      2. Checks CPU architecture with `Hardware::CPU.intel?` and `Hardware::CPU.arm?`
      3. Provides different URLs, checksums, and installation steps for each platform
      4. Includes a common test that works across all platforms

metadata:
  priority: high
  version: 1.0
  tags:
    - homebrew
    - formula
    - package-management
    - ruby
</rule>

## Additional Resources

### Official Documentation

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Ruby Style Guide](https://docs.brew.sh/Ruby-Style-Guide)
- [Homebrew Formula API](https://rubydoc.brew.sh/Formula.html)

### Tools for Formula Development

- `brew create URL` - Create a formula template
- `brew audit --strict --online formula` - Check formula for issues
- `brew style formula` - Check formula style
- `brew test formula` - Run formula tests

### Common Formula Patterns

#### Go Packages

```ruby
class GoPackage < Formula
  desc "Go package description"
  homepage "https://example.com/gopackage"
  url "https://github.com/user/gopackage/archive/v1.0.0.tar.gz"
  sha256 "checksum"
  license "MIT"
  head "https://github.com/user/gopackage.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopackage version")
  end
end
```

#### Ruby Gems

```ruby
class RubyGem < Formula
  desc "Ruby gem description"
  homepage "https://example.com/rubygem"
  url "https://github.com/user/rubygem/archive/v1.0.0.tar.gz"
  sha256 "checksum"
  license "MIT"

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "rubygem.gemspec"
    system "gem", "install", "rubygem-#{version}.gem"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubygem --version")
  end
end
```

#### Python Packages

```ruby
class PythonPackage < Formula
  include Language::Python::Virtualenv

  desc "Python package description"
  homepage "https://example.com/pythonpackage"
  url "https://files.pythonhosted.org/packages/source/p/pythonpackage/pythonpackage-1.0.0.tar.gz"
  sha256 "checksum"
  license "MIT"

  depends_on "python@3.10"

  resource "dependency" do
    url "https://files.pythonhosted.org/packages/source/d/dependency/dependency-2.0.0.tar.gz"
    sha256 "dependency-checksum"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pythonpackage --version")
  end
end
```

#### Node.js Packages

```ruby
class NodePackage < Formula
  desc "Node.js package description"
  homepage "https://example.com/nodepackage"
  url "https://registry.npmjs.org/nodepackage/-/nodepackage-1.0.0.tgz"
  sha256 "checksum"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodepackage --version")
  end
end

```

# GitHub Actions Workflow Debugging Guide

Standards and best practices for debugging GitHub Actions workflows using the GitHub CLI.

<rule>
name: github_actions_workflow_debugging
description: Guide for debugging GitHub Actions workflows using the GitHub CLI
filters:
  # Match GitHub workflow files
  - type: file_path
    pattern: "\.github/workflows/.*\\.ya?ml$"
  # Match GitHub Actions related commands
  - type: message
    pattern: "(?i)(github actions|gh workflow|workflow debug|workflow logs|workflow failed)"
  # Match workflow debugging events
  - type: event
    pattern: "file_create"

actions:
  - type: suggest
    message: |
      # GitHub Actions Workflow Debugging Guide

      This guide provides standards and best practices for debugging GitHub Actions workflows using the GitHub CLI.

      ## GitHub CLI Workflow Debugging Commands

      The GitHub CLI (`gh`) provides several commands for debugging workflows:

      ```bash
      # List workflow runs to identify failed runs
      gh run list

      # View details of a specific workflow run
      gh run view <run-id>

      # View logs of a specific workflow run
      gh run view <run-id> --log

      # Download logs of a specific workflow run
      gh run view <run-id> --log-failed --log-file=logs.txt

      # Watch a running workflow
      gh run watch <run-id>

      # Re-run a failed workflow
      gh run rerun <run-id>
      ```

      ## Common Options

      All `gh run` commands support these options:

      ```bash
      -R, --repo <[HOST/]OWNER/REPO>  # Select another repository
      ```

      ## Workflow Debugging Best Practices

      ### 1. Identifying Failed Workflows

      List recent workflow runs to identify failures:

      ```bash
      # List all recent workflow runs
      gh run list

      # List only failed workflow runs
      gh run list --status failed

      # List runs for a specific workflow
      gh run list --workflow "CI"
      ```

      ### 2. Examining Workflow Run Details

      View detailed information about a workflow run:

      ```bash
      # View run details
      gh run view <run-id>

      # View run details in web browser
      gh run view <run-id> --web
      ```

      ### 3. Analyzing Workflow Logs

      Access and analyze workflow logs:

      ```bash
      # View complete logs
      gh run view <run-id> --log

      # View only logs from failed steps
      gh run view <run-id> --log-failed

      # Download logs for offline analysis
      gh run view <run-id> --log --log-file=workflow-logs.txt
      ```

      ### 4. Debugging with Workflow Re-runs

      Re-run workflows for debugging:

      ```bash
      # Re-run a failed workflow
      gh run rerun <run-id>

      # Re-run a workflow from a specific failed job
      gh run rerun <run-id> --failed
      ```

      ### 5. Using Debug Logging

      Enable debug logging in workflows:

      ```yaml
      # Add this to your workflow file
      env:
        ACTIONS_RUNNER_DEBUG: true
        ACTIONS_STEP_DEBUG: true
      ```

      Or set repository secrets for debugging:

      ```
      ACTIONS_RUNNER_DEBUG: true
      ACTIONS_STEP_DEBUG: true
      ```

      ### 6. Using the Debug Action

      Add a debugging step to your workflow:

      ```yaml
      steps:
        - name: Debug
          uses: actions/github-script@v6
          with:
            script: |
              console.log(context)
              console.log(github)
      ```

      ### 7. Using tmate for Interactive Debugging

      Add tmate to your workflow for SSH access:

      ```yaml
      steps:
        - name: Setup tmate session
          uses: mxschmitt/action-tmate@v3
          with:
            limit-access-to-actor: true
      ```

      ## Common Debugging Scenarios

      ### Debugging Environment Variables

      ```yaml
      steps:
        - name: Debug environment variables
          run: env | sort
      ```

      ### Debugging Context Information

      ```yaml
      steps:
        - name: Debug context
          run: |
            echo "github.event_name: ${{ github.event_name }}"
            echo "github.ref: ${{ github.ref }}"
            echo "github.sha: ${{ github.sha }}"
            echo "github.workflow: ${{ github.workflow }}"
      ```

      ### Debugging File System

      ```yaml
      steps:
        - name: Debug file system
          run: |
            pwd
            ls -la
            find . -type f -name "*.yml" | sort
      ```

examples:
  - input: |
      # How do I check why my workflow failed?
    output: |
      To check why your workflow failed, follow these steps:

      1. First, list your recent workflow runs to identify the failed run:

      ```bash
      gh run list --status failed
      ```

      2. Note the run ID of the failed workflow, then view the details:

      ```bash
      gh run view <run-id>
      ```

      3. To see the logs from the failed steps:

      ```bash
      gh run view <run-id> --log-failed
      ```

      4. For a more detailed analysis, you can view the complete logs:

      ```bash
      gh run view <run-id> --log
      ```

      5. If you prefer to analyze the logs in your browser:

      ```bash
      gh run view <run-id> --web
      ```

      This will open the GitHub Actions web interface where you can see a visual representation of the workflow run and detailed logs for each step.

      If you need to download the logs for offline analysis:

      ```bash
      gh run view <run-id> --log --log-file=debug-logs.txt
      ```

  - input: |
      # How can I debug a workflow interactively?
    output: |
      To debug a GitHub Actions workflow interactively, you can use tmate to get SSH access to the runner. Here's how:

      1. Add the tmate action to your workflow file:

      ```yaml
      name: Debugging with tmate
      on:
        workflow_dispatch:  # Allows manual triggering

      jobs:
        debug:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3

            # Add any steps that come before the failure

            # Add this step to enable SSH access
            - name: Setup tmate session
              uses: mxschmitt/action-tmate@v3
              with:
                limit-access-to-actor: true  # Only allow the workflow triggerer to connect
      ```

      2. Trigger the workflow manually:

      ```bash
      gh workflow run "Debugging with tmate"
      ```

      3. Watch the workflow run:

      ```bash
      gh run watch
      ```

      4. When the tmate step executes, it will output SSH connection details in the logs. You can use these details to connect to the runner via SSH and debug interactively.

      5. After you're done debugging, you can exit the SSH session, and the workflow will continue.

      This approach is extremely useful for:
      - Inspecting the environment
      - Testing commands manually
      - Checking file contents
      - Verifying permissions
      - Debugging complex issues that are hard to diagnose from logs alone

  - input: |
      # How do I enable debug logging in GitHub Actions?
    output: |
      To enable debug logging in GitHub Actions, you have two options:

      ### Option 1: Add debug environment variables to your workflow

      Add these environment variables to your workflow file:

      ```yaml
      name: Workflow with Debug Logging
      on:
        push:
          branches: [main]

      env:
        ACTIONS_RUNNER_DEBUG: true
        ACTIONS_STEP_DEBUG: true

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - name: Build
              run: ./build.sh
      ```

      ### Option 2: Set repository secrets

      For more persistent debugging across all workflows:

      1. Go to your repository settings
      2. Navigate to Secrets > Actions
      3. Add these repository secrets:
         - Name: `ACTIONS_RUNNER_DEBUG`, Value: `true`
         - Name: `ACTIONS_STEP_DEBUG`, Value: `true`

      These debug settings will:
      - Enable detailed logs for the Actions runner
      - Show step-by-step debug information
      - Include more context in error messages
      - Log internal processes that are normally hidden

      After enabling debug logging, run your workflow:

      ```bash
      gh workflow run "Workflow Name"
      ```

      Then view the detailed logs:

      ```bash
      gh run view --log
      ```

      The logs will now contain much more detailed information to help you diagnose issues.

metadata:
  priority: high
  version: 1.0
  tags:
    - github-actions
    - debugging
    - workflows
    - ci-cd
    - github-cli
</rule>

## Additional Resources

### Official Documentation

- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub Actions Troubleshooting Guide](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/using-workflow-run-logs)
- [Enabling Debug Logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging)

### Debugging Tools

#### GitHub Actions Debug Action

```yaml
# Add this to your workflow for debugging context
- name: Dump GitHub context
  uses: actions/github-script@v6
  with:
    script: console.log(JSON.stringify(context, null, 2))
```

#### Workflow Dump Environment

```yaml
# Add this to your workflow to dump all environment variables
- name: Dump environment
  run: |
    echo "=============================================="
    echo "Dumping environment variables"
    echo "=============================================="
    env | sort
    echo "=============================================="
```

#### Workflow Dump Context

```yaml
# Add this to your workflow to dump GitHub context
- name: Dump GitHub context
  env:
    GITHUB_CONTEXT: ${{ toJson(github) }}
  run: echo "$GITHUB_CONTEXT"
```

#### Workflow Dump Job Context

```yaml
# Add this to your workflow to dump job context
- name: Dump job context
  env:
    JOB_CONTEXT: ${{ toJson(job) }}
  run: echo "$JOB_CONTEXT"
```
