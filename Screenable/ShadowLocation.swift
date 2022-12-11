//
//  ShadowLocation.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-11.
//

enum ShadowLocation: Int {
  case none, text, device, both
}

extension ShadowLocation: Identifiable, CaseIterable {
  var id: Self { self }
  
  var label: String {
    switch self {
    case .none:
      return "None"
    case .text:
      return "Text"
    case .device:
      return "Device"
    case .both:
      return "Both"
    }
  }
}
