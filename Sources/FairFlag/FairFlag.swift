import SwiftUI

private let nativeEmojiSize: CGFloat = 160

public enum FairFlag {
    public static func image(countryCode: String) -> Image? {
        let flag = countryCode.toFlagEmoji().map(Image.init(emoji:))
        #if os(iOS)
        return countryCode.uppercased() == "TW" ? Image("ROC", bundle: .module) : flag
        #else
        return flag
        #endif
    }
}

public extension String {
    func toFlagEmoji() -> String? {
        guard !isEmpty else { return nil }

        var result = ""
        for scalar in uppercased().unicodeScalars {
            guard let scalarValue = UnicodeScalar(127397 + scalar.value) else {
                return nil
            }
            result.unicodeScalars.append(scalarValue)
        }

        return result.isEmpty ? nil : result
    }
}

private extension Image {
    init(emoji: String) {
        let osImage = emoji.render(size: nativeEmojiSize)

        #if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        if let cgImage = osImage.cgImage {
            self.init(cgImage, scale: 1, label: Text(emoji))
        } else {
            self.init(uiImage: osImage)
        }
        #elseif os(macOS)
        if let cgImage = osImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            self.init(cgImage, scale: 1, label: Text(emoji))
        } else {
            self.init(nsImage: osImage)
        }
        #endif
    }
}

private extension String {
    #if os(iOS) || os(tvOS) || os(visionOS)
    func render(size: CGFloat) -> UIImage {
        let font = UIFont.systemFont(ofSize: size)
        let cgSize = CGSize(width: size, height: size)

        return UIGraphicsImageRenderer(size: cgSize).image { _ in
            self.draw(
                at: CGPoint(x: -5.5 * (size / nativeEmojiSize), y: -16 * (size / nativeEmojiSize)),
                withAttributes: [.font: font]
            )
        }
    }
    #elseif os(watchOS)
    func render(size: CGFloat) -> UIImage {
        let font = UIFont.systemFont(ofSize: size)
        let cgSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContext(cgSize)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()!
        self.draw(
            at: CGPoint(x: -5.5 * (size / nativeEmojiSize), y: -16 * (size / nativeEmojiSize)),
            withAttributes: [.font: font]
        )
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    #elseif os(macOS)
    func render(size: CGFloat) -> NSImage {
        let cgSize = CGSize(width: size, height: size)

        return NSImage(size: cgSize, flipped: false) { _ in
            let attributes = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: size)]
            let attributedString = NSAttributedString(string: self, attributes: attributes)
            attributedString.draw(at: CGPoint(x: -5.5 * (size / nativeEmojiSize), y: -14 * (size / nativeEmojiSize)))
            return true
        }
    }
    #endif
}
