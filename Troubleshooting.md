# Troubleshooting

## Project does not build

It's possible that the project will not build at first try. This might be due to caching issues of some sort.
Please try the following steps in sequential order:

1. Clean the build folder (**⇧⌘K**)
2. Reset package caches using `File > Packages > Reset Package Caches`
3. Clear the `DerivedData` folder which is usually located in `~/Library/Developer/Xcode`
4. Make sure `SwiftLint` is installed on your machine. See [SwiftLint](/Code-Style.md#swiftlint) for more information.
5. Restart Xcode.
6. Restart your Mac.

If none of the above mentioned steps work please have a chat with us in the `help` channel on our [Discord Server](https://discord.gg/vChUXVf9Em).
