# Code Style

Every programmer has their own preference on what coding style to use. But when working in a team it is important we have a consistent style throughout our codebase.

> See the [SwiftLint](#swiftlint) section to see how we test the coding style in our project.

## Swift

`CodeEdit` is entirely written using `Swift`. We decided to choose `SwiftUI` for most parts of the app where it makes sense. Though some parts require the implementation of `AppKit` code due to mostly customizability and performance reasons.

We currently are targeting `macOS 12` since it enables us to use many crucial new `SwiftUI` libraries. But we don't see this as a problem since once we reach the final release stage `macOS 13` will most likely be out already. Further most developers tend to keep their machines on the latest firmware version anyways - if not even firmware in beta stage.

## Basics

We use the standard code style used in the [Swift Language Guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html). If you're not familiar please have a read!

### Spaces/Tabs

In CodeEdit we decided to use `Spaces` instead of `Tabs`. A `\t` will be translated into `4` spaces. This is setup in our projects settings and must not be changed.

### `var` vs. `let`

We encourage you to use `let foo = ...` over `var foo = ...` wherever possible.

This is to make clear to others whether a value will change or not.

### `guard` over `if`

Use `guard` over `if` when the execution should stop when the criteria are not met:

```swift
/* Don't use this */
if fruits.isEmpty {
    // do stuff here
} else {
    return
}

/* Use this instead */
guard fruits.isEmpty else { return }
// do stuff here
```

### Don't force-unwrap

Force-unwrapping `Optional` values is never a good practice since the app will crash when it fails.

Instead of unwrapping `let foo: FooType?` don't use `foo!` to unwrap. Use this instead:

```swift
if let foo = foo {
    /// use safely unwrapped foo here
}
```

In case of optional chaining you can easily use this: `foo?.someFunctionCall()`.

### Implicit `return` and `get`

When possible don't use explicit `return` statements when they are not required.

```swift
/* Don't use this */
var someProperty: String {
    get {
        return "Hello, World!"
    }
}

/* Use this instead */
var someProperty: String {
    "Hello, World!"
}
```

### Access Control

Properties in a `class` or `struct` should be considered `private` unless they need to be either `internal` or `public`.

In a `struct` create a designated `init` and set the `private` properties there.

### Naming Conventions

Naming your properties and functions/methods appropriately is very important so people understand what they are doing.

Instead of `var n: Int = 4` use `var number: Int = 4`.

### Function Headers

Reduce redundancy in function headers whenever possible.

```swift
/* Don't use this*/
func addNumber(number: Int, toNumber: Int) {}

/* Use this instead */
func addNumber(_ num1: Int, to num2: Int) {}
```

### Documentation

Before submitting a pull request, make sure your code is well documented.

* Add comments to larger blocks of code describing what the steps do.
* Add `Swift` documentation to all public `struct`, `class`, `enum`, `var/let` and `func` declarations.

> To add documentation blocks `⌘ + click` on the name of the desired type and select `Add Documentation`.

### Use Modules

When implementing a new feature please create a new standalone module in `CodeEditModules`. See [Project Structure](./Getting-Started#project-structure) for more information.

### Remove Comments and `print`

In your final code there should not be any commented code or `print()` statements. Please remove them.

Same goes for `// swiftlint:disable` comments.

### External Libraries

We only use a handful of external libraries. Don't add external dependencies without prior discussion in issues or on [Discord](https://discord.gg/vChUXVf9Em).

This is because we want to keep our dependencies as slim as possible. In certain cases it might make sense to use an external library though.

> Keep in mind that most of UI related extensions or convenience methods can easily be implemented in a internal module/package.

## SwiftLint

To enforce our style we settled on, we use a tool called [SwiftLint](https://github.com/realm/SwiftLint). It gets executed at build time and injects error messages right into Xcode.

### Installation

All you have to do is installing it using [Homebrew](http://brew.sh/):

```bash
brew install swiftlint
```

### Configuration

We basically use the standard configuration with a handful of changes. Our current configuration looks like this:

```yaml
disabled_rules:
  - todo
  - trailing_comma

identifier_name:
  excluded:
    - id
    - vc

opt_in_rules:
  - empty_count
  - contains_over_first_not_nil

custom_rules:
  spaces_over_tabs:
    included: ".*\\.swift"
    name: "Spaces over Tabs"
    regex: "\t"
    message: "Prefer spaces for indents over tabs. See Xcode setting: 'Text Editing' -> 'Indentation'"
    severity: warning
```

> Note that we're using `--strict` mode both locally in the project as well as in our `CI` environment which runs our tests on submission of pull requests.

### Recommendation

We recommend to change the following setting in Xcode:

* `Preferences > Text Editing > Editing` and enable:
  * [x] Automatically trim trailing whitespace
    * [x] Including whitespace-only lines
