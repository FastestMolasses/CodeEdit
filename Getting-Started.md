# Getting Started

Welcome to our guide to getting started on contributing to CodeEdit. This guide will help you understand the basic structure of the app and where to begin with. If you get stuck somewhere please have a look at the [troubleshooting](./Troubleshooting) section or join the discussion on our [Discord Server](https://discord.gg/vChUXVf9Em).

> ⚠️ If you're just starting out with **Swift** we highly recommend checking out [**100 Days of Swift**](https://www.hackingwithswift.com/100) and [**100 Days of SwiftUI**](https://www.hackingwithswift.com/100/swiftui) by [Paul Hudson](https://twitter.com/twostraws) to get a basic understanding of mastering Swift and the SwiftUI framework!
> Also check out our `#swift-beginners` channel on our [Discord Server](https://discord.gg/vChUXVf9Em)

## Fork and Clone

In order to contribute you first have to fork the repository by tapping the **Fork** button on the top left. This will create a copy in your own repository list.

After you forked the repository you can clone your fork to your local machine. For starters we recommend using a tool with a GUI like [GitHub Desktop](https://desktop.github.com) or [Fork](https://git-fork.com).

## Open the Project in Xcode

> **Important:** Make sure you have at least `macOS 13 Ventura` installed since our deployment target is `macOS 13`. Otherwise the project will not build and run properly!

In order to contribute you first have to understand roughly how everything works together in our project.
First of all you need to open the directory where you cloned the repository to in Finder. Inside that directory you will find a couple of files and sub-directories.

You want to open the `CodeEdit.xcodeproj` file in Xcode.

![CodeEdit.xcodeproj](https://user-images.githubusercontent.com/1364843/219864053-7eed048a-5dca-471f-b34e-26e9d0774fab.png)

## Project Structure

After opening the project in Xcode you will find some top level folders but the one that is the most important is `CodeEdit`.

`CodeEdit` is the main app target which we use to build and run the app. It contains all the necessary assets, configurations, and initialization code to build the app. Its top level folders contain code that is general or reusable for the code in the `Features` folder. CodeEdit is structured using the "Package by feature" opposed to "Package by layer".

### Features

<img width="1012" alt="ui-diagram" src="https://user-images.githubusercontent.com/806104/195441086-a19e34be-2c4e-4457-b265-74930da03475.png">

The `Features` folder pretty self descriptive. The above diagram is used a reference to help decide in what folders the features are split. When you are writing new code, always check there is already a feature folder for it that it belongs in. Otherwise just create a new folder for it. (In case you don't know if it's a new feature or not, feel free to ask in the Discord or just create a PR and then other developers can comment)

Every feature should be structure as "Package by layer" which looks something like this:

- {Feature}:
  - Controllers
  - Models
  - ViewModels
  - Views
  - Etc...

The exception to this structure can be that it's a feature with sub-features. The `NavigationSidebar` is a good example of this.

> Note: You'll see that some parts are not visible in the diagram, but are in feature folders like 'Git' and 'AppPreferences', and the other way around. Also some features do not yet follow the above noted guidelines. That's because we recently refactored the codebase, which still has some inconsistencies.

## Next Up

### • [Code Style](./Code-Style) – _(conventions to keep up a uniform code style)_

### • [Developer Docs](./Developer-Docs) – _(Swift developer documentation for CodeEdit)_
