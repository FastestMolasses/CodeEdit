# Terminology

## Overview

* [Workspace](#workspace)
* [Editor](#editor)
* [Sidebars](#sidebars)
  * [Navigator](#navigator-sidebar)
  * [Inspector](#inspector-sidebar)
* [Statusbar](#statusbar)
* [Toolbar](#toolbar)
* [Tabbar](#tabbar)
* [Breadcrumbs](#breadcrumbs)

------

## Workspace

A workspace is a single instance of a CodeEdit window that represents one open project.

You can have multiple workspaces open with one project each.

## Editor

The editor takes up the main section in the workspace. It displays the content of the selected file.

## Sidebars

A workspace has two sidebars. The navigator sidebar and the inspector sidebar. Sidebars can be toggled to show or hide and may be resized.

### Navigator Sidebar

The navigator sidebar sits on the leading edge of the workspace window and is used to navigate through the project. It contains the `Project Navigator`, `Find Navigator`, `Extension Navigator`, and more.

### Inspector Sidebar

The Inspector sidebar is dynamic to the currently selected file. It contains the `File Inspector`, `History Inspector`, and more depending on the file type of the selected file.

## Statusbar

The statusbar sits on the bottom of the Editor. It gives quick access to some editor-specific settings, shows the location of the cursor in the editor, and gives access to the integrated terminal, output view, and debug console.

## Toolbar

The toolbar is the top most part of the workspace window. It contains buttons for toggling the sidebars, the branch selector, and other toolbar items.

## Tabbar

The tabbar sits on top of the editor and shows tabs for each opened file. Tabs can be reordered or closed. Once selecting a tab the content of the selected file will show up in the editor.

## Breadcrumbs

The breadcrumbs navigator is located just below the tabbar and visually presents the path of the currently opened file in the project. When selecting a path section a menu appears to browse the contents of the parent directory.
