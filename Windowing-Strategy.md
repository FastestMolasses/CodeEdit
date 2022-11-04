Open CodeEdit windows can have various states depending on the circumstance. I'd like to outline my thoughts around window states and how they can change during the lifecycle of the file/project to get feedback from the community on this approach.

Our goal is to provide a simple UI when creating or viewing individual files that can be scaled up if need be. Projects will have a more comprehensive UI to accommodate navigation and other project needs.

To set the stage, upon launching CodeEdit, we start at the welcome screen which looks like this.

![image](https://user-images.githubusercontent.com/806104/199353104-d9382dec-3e73-43fa-8175-d79b23d412ac.png)

From here, the user can perform the following actions, each of which we will discuss.

1. Create a new file
2. Open a file
3. Open a folder

## Creating a new file

When a user creates a new file it might look like this.

![image](https://user-images.githubusercontent.com/806104/199355064-a2dd5a26-e78b-436b-9dcd-cf1256acd41a.png)

The user can then show the Navigator sidebar and they will see a zero-state in place of the folder structure with a button that allows them to open a folder in this Workspace.

![image](https://user-images.githubusercontent.com/806104/199525116-7207a0ed-0975-4f2c-88c3-19afed4a1484.png)

## Opening an existing file

If the user opens an existing file or saves a newly created file, it might look like this.

![image](https://user-images.githubusercontent.com/806104/199354865-30353069-4171-48ac-a486-b9b063fbf591.png)


To open a folder, the user can show the Navigator sidebar, and click one of the buttons below to open a folder. Because the file already exists in a folder, we can provide an option for the user to open the containing folder in addition to opening something else.

![image](https://user-images.githubusercontent.com/806104/199525888-e906f0af-6cc0-4076-a745-9014c2f9a7c2.png)

Our goal here is to seamlessly allow the user to transition between states easily as needs change. Consider the following scenario:

1. User opens CodeEdit
2. Welcome screen is displayed
3. User creates new file
4. User saves new file in a new directory
5. User needs to view a folder including this new file in the project navigator.

So the question was, what are we to display in the project navigator in this scenario?

Our thought was that it may cause some frustration if we showed the containing folder structure of the file originally saved. We would be making the unsafe assumption that the user wants to use this folder as the project root. We need to consider the likely possibility that the file that was open may be in a nested folder structure and the desired project root may be a few levels up.

So we will show a zero-state in place of the folder structure in the project navigator along with two buttons – one to open the containing folder and the other to allow the user to select which folder to open as shown above.

## Opening an existing project folder

If the user opens an existing project it might look like this.

![image](https://user-images.githubusercontent.com/806104/199355623-ca72217d-472e-4d3d-a2cb-3e5e8361c02c.png)

## Dragging tabs

### Dragging a tab inside the window

If the user drags a tab inside the window it will create a split editor layout like so.

![image](https://user-images.githubusercontent.com/806104/200044762-2ac4775e-2471-4db1-9cc3-4e19a6865dca.png)

![image](https://user-images.githubusercontent.com/806104/200044808-ede0a914-8776-4b2b-8318-5f3febe7e7eb.png)

![image](https://user-images.githubusercontent.com/806104/200045018-36205f49-0c42-4d85-95c5-813232f9da6f.png)

![image](https://user-images.githubusercontent.com/806104/200045090-55f6c21f-0b88-4243-9b59-b65c29079259.png)

### Dragging a tab outside the window 

If the user drags a tab outside of the window to break it out like this.

![image](https://user-images.githubusercontent.com/806104/199356347-129c4721-2fb2-41c5-8038-eb69e36e43be.png)

Then it would create a new window like so.

![image](https://user-images.githubusercontent.com/806104/199757841-cc4d2cc0-6430-4ded-8fd3-282372a19d92.png)

Let's take a closer look. Now that we have popped the file out into it's own window, you will see a few differences when compared to the previous two single file windows.

![image](https://user-images.githubusercontent.com/806104/199636128-fa589a13-bd4c-465d-aee8-d9a1be388101.png)

First, you will notice a new button to the right in the titlebar. This indicates that this is a child file window that belongs to a parent project window and when clicking this button, it pops it back into the original project window as a tab.

Second, you will notice that the Navigator sidebar toggle button and the debugger drawer toggle button are missing. This is for the same reason. This is a child window to a parent project window and there is no reason for a navigator or debug area within this window. The user will still be able to access the Inspector sidebar, however it is hidden by default.

When the parent project window is closed, these child windows will close as well. There is in a sense a link between all these windows of the same project.

The Open in Project button is visible and the Navigator sidebar toggle button is hidden because when the new window was created, it stores a reference to the original window it came from - if no reference is present, there is no Open in Project button and the Navigator sidebar toggle remains visible.

### Dragging additional tabs on the breakout window

This is what that would look like...

#### Scenario 1

User has breakout window.

![image](https://user-images.githubusercontent.com/806104/200029897-d8cd9cea-0b0c-4f14-9ae8-1f0a6bac91d1.png)

User drags tab to left of breakout window.

![image](https://user-images.githubusercontent.com/806104/200034180-99531676-55d8-4149-8d2f-14d89dbefcd4.png)

Tab is dropped. Breakout window now has split layout.

![image](https://user-images.githubusercontent.com/806104/200032944-de24cf05-9f56-48a1-bf20-b4714d1302f5.png)

Notice tabs are now visible and title becomes project folder name.

#### Scenario 2

User has breakout window 

![image](https://user-images.githubusercontent.com/806104/200029897-d8cd9cea-0b0c-4f14-9ae8-1f0a6bac91d1.png)

User drags tab to center of breakout window.

![image](https://user-images.githubusercontent.com/806104/200032564-e57590b2-e5bb-4326-a8ba-2cc44b68f0e9.png)

Tab is dropped and is merged into breakout window.

![image](https://user-images.githubusercontent.com/806104/200033249-6518b676-beb2-42fe-b9de-afda58edc068.png)

Again notice that the tab bar is now visible and window title is now project folder name. 

Another tab is dragged to the right side of the breakout window.

![image](https://user-images.githubusercontent.com/806104/200033409-c405272c-0bbe-490b-b4f2-cc6d37e5d406.png)

Tab is dropped and split view is created.

![image](https://user-images.githubusercontent.com/806104/200033520-dbde8bd7-7574-47c6-96ae-a7452a5ce73e.png)


## Additional considerations

Windows only intended to display a single file (new files, open files, and files popped out of a project window) will have the navigator sidebar, inspector sidebar, debug area, breadcrumbs bar and tab bar all hidden by default. We may have a "Hide Interface" menu item in the View menu that does this instead of having to manually hide/show each.

When the tab bar is hidden, the window title becomes the filename (instead of the project folder name).

## Wrapping up

In conclusion, I think this is the best approach to handle how our windows change according to the file/project lifecycle. Please let me know if I am missing something or if we could be handling this better. I have been wrong before and I hope that we can discuss this to either validate this usability pattern or come up with something even better. I look forward to your comments! 👀