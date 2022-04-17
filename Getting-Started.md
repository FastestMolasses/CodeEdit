# Getting Started

Welcome to our guide to getting started on contributing to CodeEdit. This guide will help you understand the basic structure of the app and where to begin with. If you get stuck somewhere please have a look at the [troubleshooting](./Troubleshooting) section or join the discussion on our [Discord Server](https://discord.gg/vChUXVf9Em).

## Fork and Clone

In order to contribute you first have to fork the repository by tapping the **Fork** button on the top left. This will create a copy in your own repository list.

After you forked the repository you can clone your fork to your local machine. For starters we recommend using a tool with a GUI like [GitHub Desktop](https://desktop.github.com) or [Fork](https://git-fork.com).

## Open the Project in Xcode

> **Important:** Make sure you have at least `macOS 12 Monterey` installed since our deployment target is `macOS 12`. Otherwise the project will not build and run properly!

In order to contribute you first have to understand roughly how everything works together in our project.
First of all you need to open the directory where you cloned the repository to in Finder. Inside that directory you will find a couple of files and sub-directories.

You want to open the `CodeEdit.xcworkspace` file in Xcode.

![CodeEdit.xcworkspace](https://user-images.githubusercontent.com/9460130/158924759-42a61d23-4961-4bfb-8d44-930ec2427f0f.png)

> Note: Do not open the `CodeEdit.xcodeproj` file since it will not include our internal modules which are required to build & run CodeEdit.

## Project Structure

After opening the project in Xcode you will find the following top level folders:

* `CodeEditModules`
* `CodeEdit`

`CodeEdit` is the main app target which we use to build and run the app. It contains all the necessary assets, configurations, and initialization code to build the app.

`CodeEditModules` is our internal package of libraries where most of our code lives. It is divided in different libraries which allows us to build and run tests on individual parts of our app. It also leads to less conflicts when merging changes.

If you add a new feature please do so by adding a new module library to `CodeEditModules`.

> Note: Some parts of the app are still inside the `CodeEdit` main target. We are currently transitioning those to their own modules inside `CodeEditModules`.

## Module Libraries

The structure of the libraries found in `CodeEditModules` looks like this:

* CodeEditModules
  * Modules
    * Name_Of_The_Library
      * src
      * Tests

The `src` directory contains all the code of your library while the `Tests` directory contains all tests.

To add a library just add a new folder inside `Modules` and add the sub-folders as outlined above. Then add the following to the `Package.swift` file:

Add this to the end of `products` array:

```swift
.library(
    name: "Name_Of_The_Library",
    targets: ["Name_Of_The_Library"]
),
```

Then add this to the end of the `targets` array:

```swift
.target(
    name: "Name_Of_The_Library",
    dependencies: [
      // other library names (comma separated) your library depends on
    ],
    path: "Modules/Name_Of_The_Library/src"
),
```

Lastly add the newly created library to the main project:

1. Click on the `CodeEdit` main target folder.
2. Select `CodeEdit` under `Targets` in the left sidebar.
3. Under `General` find the `Frameworks, Libraries & Embedded Content` section.
4. Click the `+` icon on the bottom of the list and select your newly created module.

## Next Up

### • [Code Style](./Code-Style) – _(conventions to keep up a uniform code style)_

### • [Developer Docs](./Developer-Docs) – _(Swift developer documentation for CodeEdit)_
