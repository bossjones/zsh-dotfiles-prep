---
description:
globs:
alwaysApply: false
---
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

      ## Brewfile and Bundle Command

      Homebrew's bundle command allows you to manage dependencies using a Brewfile, similar to a Gemfile in Ruby or package.json in Node.js.

      ### Brewfile Structure

      A Brewfile is a simple text file that lists all the packages you want to install:

      ```ruby
      # Taps (third-party repositories)
      tap "homebrew/core"
      tap "homebrew/cask"
      tap "homebrew/bundle"
      tap "user/repo"  # Custom taps

      # Formulae (CLI tools and libraries)
      brew "git"
      brew "python"
      brew "node"
      brew "formula", args: ["with-option", "without-option"]  # With arguments
      brew "formula", link: false  # Install but don't link
      brew "formula", restart_service: true  # Restart service after upgrade

      # Casks (macOS applications)
      cask "google-chrome"
      cask "visual-studio-code"
      cask "docker"

      # Mac App Store applications
      mas "Xcode", id: 497799835
      mas "1Password", id: 1333542190

      # Visual Studio Code extensions
      vscode "ms-python.python"
      vscode "golang.go"

      # Whalebrew containers
      whalebrew "whalebrew/wget"
      ```

      ### Using the Bundle Command

      #### Installing from a Brewfile

      ```bash
      # Install everything from the Brewfile in the current directory
      brew bundle install

      # Install from a specific Brewfile
      brew bundle install --file=/path/to/Brewfile

      # Install from the global Brewfile
      brew bundle install --global

      # Install without upgrading existing packages
      brew bundle install --no-upgrade
      ```

      #### Creating a Brewfile

      ```bash
      # Create a Brewfile from currently installed packages
      brew bundle dump

      # Create with specific package types
      brew bundle dump --formula --cask --tap --mas

      # Create with descriptions
      brew bundle dump --describe

      # Create a global Brewfile
      brew bundle dump --global
      ```

      #### Checking a Brewfile

      ```bash
      # Check if all dependencies are installed
      brew bundle check

      # Check with verbose output
      brew bundle check --verbose
      ```

      #### Cleaning Up

      ```bash
      # Uninstall all dependencies not listed in Brewfile
      brew bundle cleanup

      # Actually perform the cleanup (by default only lists what would be removed)
      brew bundle cleanup --force
      ```

      ### Best Practices for Brewfiles

      1. **Version Control**: Commit your Brewfile to version control to share your development environment.

      2. **Organization**: Group related packages together and use comments to explain their purpose.

      3. **Global vs. Project Brewfiles**: Use global Brewfiles for personal tools and project-specific Brewfiles for project dependencies.

      4. **Descriptions**: Use the `--describe` flag when dumping to include package descriptions as comments.

      5. **Regular Updates**: Periodically update your Brewfile with `brew bundle dump` to capture new dependencies.

      6. **CI Integration**: Use `brew bundle check` in CI to ensure all dependencies are documented.

      7. **Selective Dumping**: Use flags like `--formula` or `--cask` to selectively dump only certain types of dependencies.

      ### Updating Your Brewfile

      It's good practice to periodically update your Brewfile to ensure it reflects your current environment:

      ```bash
      # Check for outdated packages
      brew outdated

      # Update all packages
      brew upgrade

      # Generate a new Brewfile with current packages
      brew bundle dump --force

      # Or update with descriptions
      brew bundle dump --force --describe
      ```

      For a more selective approach:

      ```bash
      # Update only specific package types
      brew bundle dump --force --formula --cask --tap

      # Update without certain package types
      brew bundle dump --force --no-vscode
      ```

      When working with multiple environments or machines:

      ```bash
      # Create a Brewfile on one machine
      brew bundle dump --describe

      # Transfer the Brewfile to another machine and install
      brew bundle install

      # Check for differences between Brewfile and installed packages
      brew bundle check --verbose
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

  - input: |
      # Creating a Brewfile for a development environment
      I need to create a Brewfile to set up a consistent development environment across multiple machines.
    output: |
      Here's how to create a Brewfile for a consistent development environment:

      First, create a file named `Brewfile` in your project root with the following content:

      ```ruby
      # Taps
      tap "homebrew/core"
      tap "homebrew/cask"
      tap "homebrew/bundle"
      tap "homebrew/services"

      # Development tools
      brew "git"                  # Version control
      brew "gh"                   # GitHub CLI
      brew "node"                 # JavaScript runtime
      brew "python@3.12"          # Python programming language
      brew "go"                   # Go programming language
      brew "cmake"                # Build system
      brew "make"                 # Build automation tool

      # Shell utilities
      brew "bash"                 # Modern bash version
      brew "zsh"                  # Z shell
      brew "tmux"                 # Terminal multiplexer
      brew "fzf"                  # Fuzzy finder
      brew "ripgrep"              # Fast grep replacement
      brew "fd"                   # Fast find replacement
      brew "bat"                  # Cat with syntax highlighting
      brew "jq"                   # JSON processor

      # Container and cloud tools
      brew "docker", link: false  # Container platform
      brew "kubernetes-cli"       # Kubernetes CLI
      brew "helm"                 # Kubernetes package manager
      brew "awscli"               # AWS CLI

      # Database tools
      brew "postgresql@14", restart_service: true  # PostgreSQL database
      brew "redis", restart_service: true          # Redis database

      # Applications
      cask "visual-studio-code"   # Code editor
      cask "docker"               # Docker desktop
      cask "iterm2"               # Terminal emulator
      cask "postman"              # API testing tool

      # Fonts
      cask "font-fira-code"       # Monospaced font with ligatures
      cask "font-jetbrains-mono"  # Developer-focused font

      # VS Code extensions
      vscode "ms-python.python"
      vscode "golang.go"
      vscode "dbaeumer.vscode-eslint"
      vscode "esbenp.prettier-vscode"
      ```

      To use this Brewfile:

      1. Install Homebrew Bundle if you haven't already:
         ```bash
         brew tap homebrew/bundle
         ```

      2. Run the installation:
         ```bash
         brew bundle install
         ```

      3. To check if all dependencies are installed:
         ```bash
         brew bundle check
         ```

      4. To update the Brewfile with your current environment:
         ```bash
         brew bundle dump --force --describe
         ```

      This Brewfile:
      1. Installs essential development tools and languages
      2. Sets up common shell utilities for productivity
      3. Includes container and cloud tools
      4. Configures databases with automatic service restart
      5. Installs developer applications and fonts
      6. Sets up VS Code extensions

      You can commit this to version control to share with your team or use across multiple machines.

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

- [Homebrew Formula Cookbook](mdc:https:/docs.brew.sh/Formula-Cookbook)
- [Homebrew Ruby Style Guide](mdc:https:/docs.brew.sh/Ruby-Style-Guide)
- [Homebrew Formula API](mdc:https:/rubydoc.brew.sh/Formula.html)

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
