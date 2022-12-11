//
//  ScreenableDocument.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-11.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScreenableDocument {
  //MARK: - Caption
  var caption = ""
  
  var font = "Helvetica Neue"
  var fontSize = 16

  //MARK: - Image
  var backgroundImage = ""
  var userImage: Data?
  
  //MARK: - Colors & Gradients
  var captionColor: Color = .white
  var backgroundColorTop: Color = .clear
  var backgroundColorBottom: Color = .clear
  
  //MARK: - Shadows
  var dropShadowLocation: Int = .zero
  var dropShadowStrength: Int = 1

  // For new and empty documents
  init() {}
}

//MARK: - FileDocument conformance
extension ScreenableDocument: FileDocument, Codable {
  static var readableContentTypes = [
    UTType(exportedAs: "tech.neurothrone.screenable")
  ]

  // Loads the content of a file and decodes it into a ScreenableDocument instance
  init(configuration: ReadConfiguration) throws {
    if let data = configuration.file.regularFileContents {
      self = try JSONDecoder().decode(ScreenableDocument.self, from: data)
    }
  }

  // Write our data to disk
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let data = try JSONEncoder().encode(self)
    return FileWrapper(regularFileWithContents: data)
  }
}
