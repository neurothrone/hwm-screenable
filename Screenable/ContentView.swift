//
//  ContentView.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-10.
//

import SwiftUI
import UniformTypeIdentifiers

@MainActor
struct ContentView: View {
  @Binding var document: ScreenableDocument
  
  let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
  let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")
  
  var body: some View {
    content
      .toolbar {
        Button("Export") { export() }
        ShareLink(item: snapshotToURL())
      }
      .onCommand(#selector(AppCommands.export)) { export() }
  }
  
  private var content: some View {
    HStack(spacing: 20) {
      //MARK: - Render View
      RenderView(document: document)
        .dropDestination(for: URL.self) { items, location in
          handleDrop(of: items)
        }
        .onDrag {
          NSItemProvider(
            item: snapshotToURL() as NSSecureCoding,
            typeIdentifier: UTType.fileURL.identifier
          )
        }
      
      //MARK: - Caption
      VStack(spacing: 20) {
        VStack(alignment: .leading) {
          Text("Caption")
            .bold()
          
          TextEditor(text: $document.caption)
            .font(.title)
            .border(.tertiary, width: 1)
          
          Picker("Select a caption font", selection: $document.font) {
            ForEach(fonts, id: \.self, content: Text.init)
          }
          
          HStack {
            Picker("Size of caption font", selection: $document.fontSize) {
              ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                Text("\(size)pt")
              }
            }
            
            ColorPicker("Caption color", selection: $document.captionColor)
          }
        }
        .labelsHidden()
        
        //MARK: - Background Image
        VStack(alignment: .leading) {
          Text("Background image")
            .bold()
          
          Picker("Background image", selection: $document.backgroundImage) {
            Text("No background image")
              .tag("")
            Divider()
            
            ForEach(backgrounds, id: \.self, content: Text.init)
          }
        }
        .labelsHidden()
        
        //MARK: - Background color
        VStack(alignment: .leading) {
          Text("Background color")
            .bold()
          
          Text("If set to non-transparent, this will be drawn over the background image.")
            .frame(maxWidth: .infinity, alignment: .leading)
          
          HStack(spacing: 20) {
            ColorPicker("Start:", selection: $document.backgroundColorTop)
            ColorPicker("End:", selection: $document.backgroundColorBottom)
          }
        }
        
        //MARK: - Shadows
        VStack(alignment: .leading) {
          Text("Drop shadow")
            .bold()
          
          Picker("Drop shadow location", selection: $document.dropShadowLocation) {
            ForEach(ShadowLocation.allCases) { shadowLocation in
              Text(shadowLocation.label)
                .tag(shadowLocation.rawValue)
            }
          }
          .pickerStyle(.segmented)
          .labelsHidden()
          
          Stepper("Shadow radius: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
        }
      }
      .frame(width: 250)
    }
    .padding()
  }
}

extension ContentView {
  private func handleDrop(of urls: [URL]) -> Bool {
    guard let url = urls.first else { return false }
    
    let loadedImage = try? Data(contentsOf: url)
    document.userImage = loadedImage
    
    return true
  }
  
  func createSnapshot() -> Data? {
    let renderer = ImageRenderer(content: RenderView(document: document))
    
    if let tiff = renderer.nsImage?.tiffRepresentation {
      let bitmap = NSBitmapImageRep(data: tiff)
      
      // It’s possible to add some extra metadata here at the same time if needed, but we’ll just add an empty dictionary
      return bitmap?.representation(using: .png, properties: [:])
    } else {
      return nil
    }
  }
  
  func export() {
    guard let png = createSnapshot() else { return }
    
    let panel = NSSavePanel()
    panel.allowedContentTypes = [.png]
    
    panel.begin { result in
      if result == .OK {
        guard let url = panel.url else { return }
        
        do {
          try png.write(to: url)
        } catch {
          print("❌ -> Failed to write png. Error: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func snapshotToURL() -> URL {
    let url = URL.temporaryDirectory.appending(path: "ScreenableExport")
      .appendingPathExtension("png")
    
      try? createSnapshot()?.write(to: url)
      return url
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(document: .constant(.init()))
  }
}
