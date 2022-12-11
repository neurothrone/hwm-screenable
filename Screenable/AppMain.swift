//
//  AppMain.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-10.
//

import SwiftUI

@main
struct AppMain: App {
  var body: some Scene {
    DocumentGroup(newDocument: ScreenableDocument()) { file in
      ContentView(document: file.$document)
    }
    .windowResizability(.contentSize)
    //MARK: The first method I want to demonstrate is for when you want to piggyback a menu item onto an existing main menu group, e.g. File or Edit. To do this, you should use a CommandGroup with some kind of position, like this:
    .commands {
      CommandGroup(after: .saveItem) {
        Button("Export...") {
          NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
        }
        // The keyboardShortcut() modifier tells SwiftUI to activate this when Cmd+E is pressed – you can attach custom modifier key if you want, but Cmd is assumed if you don’t say otherwise.
        .keyboardShortcut("e")
      }
    }
    //MARK: - As an alternative, you can also create a wholly new top-level menu for your need. For example, if you wanted to allow export in several different formats, you might prefer to have Export as a top-level menu, with “Export as PNG”, “Export as JPEG”, etc, as menu items in there.
    // To try this approach instead, use CommandMenu instead of CommandGroup, giving it a name to show in the menu bar. You can then go ahead and add as many buttons as you want there, optionally using Divider() to add a separator where needed.
//    .commands {
//      CommandMenu("Export") {
//        Button("Export as PNG") {
//          NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
//        }
//        .keyboardShortcut("e")
//      }
//    }
    
    //MARK: - You can give even go deeper if you need to, by adding submenus inside your menus. This is done using Menu views with more buttons, so for example we might want to have some inline options to configure our export options:
//    .commands {
//      CommandMenu("Export") {
//        Menu("Options") {
//          Button("Ignore Background", action: {})
//          Button("Also Render Thumbnail", action: {})
//        }
//
//        Button("Export as PNG", action: {})
//          .keyboardShortcut("e")
//      }
//    }
  }
}
