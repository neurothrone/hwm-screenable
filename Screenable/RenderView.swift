//
//  RenderView.swift
//  Screenable
//
//  Created by Zaid Neurothrone on 2022-12-11.
//

import SwiftUI

struct RenderView: View {
  let document: ScreenableDocument
  
  private var textShadowColor: Color {
    document.dropShadowLocation == ShadowLocation.text.rawValue ||
    document.dropShadowLocation == ShadowLocation.both.rawValue ? .black : .clear
  }
  
  var deviceHasShadows: Bool {
    document.dropShadowLocation > ShadowLocation.text.rawValue
  }

  var body: some View {
    Canvas { context, size in
      //MARK: - Set up
      let fullSizeRect = CGRect(origin: .zero, size: size)
      let fullSizePath = Path(fullSizeRect)
      let phoneSize = CGSize(width: 300, height: 607)
      let imageInsets = CGSize(width: 16, height: 14)

      //MARK: - Draw the background image
      context.fill(fullSizePath, with: .color(.black))
      
      if document.backgroundImage.isNotEmpty {
        context.draw(Image(document.backgroundImage), in: fullSizeRect)
      }

      //MARK: - Add a gradient
      context.fill(
        fullSizePath,
        with: .linearGradient(
          Gradient(
            colors: [
              document.backgroundColorTop,
              document.backgroundColorBottom
            ]
          ),
          startPoint: .zero,
          endPoint: CGPoint(x: 0, y: size.height)
        )
      )

      //MARK: - Draw the caption
      var verticalOffset: Double = .zero
      let horizontalOffset = (size.width - phoneSize.width) / 2

      if document.caption.isEmpty {
        verticalOffset = (size.height - phoneSize.height) / 2
      } else {
        if let resolvedCaption = context.resolveSymbol(id: "Text") {
          // Center the text
          let textPosition = (size.width - resolvedCaption.size.width) / 2

          // Draw it 20 points from the top
          context.draw(
            resolvedCaption,
            in: CGRect(
              origin: CGPoint(x: textPosition, y: 20),
              size: resolvedCaption.size
            )
          )

          // Use the text height + 20 before the text + 20 after the text for verticalOffset
          verticalOffset = resolvedCaption.size.height + 40
        }
      }

      //MARK: - Draw the phone
      if deviceHasShadows {
        var contextCopy = context
        
        contextCopy.addFilter(.shadow(
          color: .black,
          radius: Double(document.dropShadowStrength))
        )
        contextCopy.addFilter(.shadow(
          color: .black,
          radius: Double(document.dropShadowStrength))
        )
        
        contextCopy.draw(
          Image("iPhone"),
          in: CGRect(
            origin: CGPoint(x: horizontalOffset, y: verticalOffset),
            size: phoneSize
          )
        )
      }
      
      if let screenshot = context.resolveSymbol(id: "Image") {
        let drawPosition = CGPoint(
          x: horizontalOffset + imageInsets.width,
          y: verticalOffset + imageInsets.height
        )
        
        let drawSize = CGSize(
          width: phoneSize.width - imageInsets.width * 2,
          height: phoneSize.height - imageInsets.height * 2
        )
        
        context.draw(
          screenshot,
          in: CGRect(
            origin: drawPosition,
            size: drawSize
          )
        )
      }
      
      context.draw(
        Image("iPhone"),
        in: CGRect(
          origin: CGPoint(x: horizontalOffset,y: verticalOffset),
          size: phoneSize
        )
      )
    } symbols: {
      //MARK: - Add custom SwiftUI views
      Text(document.caption)
        .font(.custom(document.font, size: Double(document.fontSize)))
        .foregroundColor(document.captionColor)
        .multilineTextAlignment(.center)
        .shadow(
          color: textShadowColor,
          radius: Double(document.dropShadowStrength)
        )
        .shadow(
          color: textShadowColor,
          radius: Double(document.dropShadowStrength)
        )
        .tag("Text")
      
      Group {
        if let userImage = document.userImage,
           let nsImage = NSImage(data: userImage) {
          Image(nsImage: nsImage)
        } else {
          Color.gray
        }
      }
      .tag("Image")
    }
    // Size is capped to be exactly 1/3rd the size of our assets, which provides enough space to see fine detail without becoming overwhelmingly large.
    .frame(width: 414, height: 736)
  }
}

struct RenderView_Previews: PreviewProvider {
  static var previews: some View {

    var document = ScreenableDocument()
    document.caption = "Welcome! There is no turning back now."

    return RenderView(document: document)
  }
}
