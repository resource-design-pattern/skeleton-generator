# RESOURCE DESIGN PATTERN - SKELETON GENERATOR

This bash package will generate the **Skeleton** for the **Resource Design Pattern**.

Generating the **Skeleton** for a specific Programming Language is possible, providing that the target language can implement the **Resource Design Pattern**.

For more information on the **Resource Design Pattern**, please visit https://github.com/resource-design-pattern/concepts.

## How to Install

This package as dependencies on several other Bash Packages, therefore to require them we will use the **Bash Package Manager**.

If is installed yet in your system, please visit https://github.com/exadra37-bash/package-manager and follow the instructions.

##### Preferred method is to install globally in our environment:

```bash
# this path is for Ubuntu 14.04, may be necessary to adjust in other O.S.
> cd /usr/local/bin

# this must be run as root, therefore the use of `sudo`
>sudo git clone -b master --single-branch --depth 1 https://github.com/resource-design-pattern/skeleton-generator.git vendor/resource-design-pattern/skeleton-generator
```

##### Installing required packages for our Skeleton Generator

```bash
> cd vendor/resource-design-pattern/skeleton-generator

# We must have already the Bash Package Manager installed to run the next command
> sudo bpm install
```

##### Permanent Alias

```bash
# for ZSH shell - IF YOU ARE NOT USING IT, YOU SHOULD ;)
> echo "alias skg=/usr/local/bin/vendor/resource-design-pattern/skeleton-generator/src/skeleton-generator.sh" >> ~/.zshrc && . ~/.zshrc

# for Bash shell
> echo "alias skg=/usr/local/bin/vendor/resource-design-pattern/skeleton-generator/src/skeleton-generator.sh" >> ~/.bashrc && . ~/.bashrc
```

## How to Use

### Basic Usage

We can invoke it like `skg <vendor-name/package-name> <file-extension> <resources>`

##### Lets create first a temporary folder to try the **Skeleton Generator**:

```bash
> mkdir -p tmp/demo && cd tmp/demo
```

##### Generating the Skeleton for Resource Design Pattern with defaults:

```bash
# skg <vendor-name/package-name> <file-extension> <resources>
> skg skg exadra37/ecommerce php Clients,Categories,Products,Carts,Checkout


# lets check our main Skeleton
> ls -1

config
deploy
docs
public
src
tests
```

##### Specifying a path where we want to generate the Skeleton

```bash
# skg <vendor-name/package-name> <file-extension> <resources> -p <path/to/generate/skeleton>
> skg exadra37/ecommerce php Clients,Categories,Products,Carts,Checkout -p vendor/exadra37/ecommerce
```

### Advanced Usage

Several options are available for advanced usage, but in the moment they are not fully tested or implemented, therefore when ready the proper documentation will be added here.
