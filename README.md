<h1 align="center">FairFlag</h1>

<h4 align="center">A SwiftUI country flag package built to mitigate Taiwan flag censorship issues.</h4>

<p align="center">
<picture>
<img src=".github/images/Logo.png" width="512" alt="BitRemote app icon.">
</picture>
</p>

## Background

On China-model iPhone and iPad devices, the Taiwan flag emoji may not render correctly. To keep behavior consistent for those cases, FairFlag uses a fixed rule for `TW`.

- On iOS and iPadOS, when the country code is `TW`, FairFlag always uses the bundled ROC image asset.
- For all other country codes, FairFlag keeps normal emoji-based rendering.

## Features

- Convert ISO country codes to flag emoji (`String.toFlagEmoji()`).
- Render an emoji string as a SwiftUI `Image` (`FairFlag.image(emoji:)`).
- Render a country code as a SwiftUI `Image` (`FairFlag.image(countryCode:)`).

## Requirements

- Swift 5.3+
- iOS 13.0+
- iPadOS 13.0+
- watchOS 6.0+
- tvOS 13.0+
- macOS 10.15+
- visionOS 1.0+

## Usage

Add `FairFlag` to your `Package.swift`:

```swift
.package(url: "https://github.com/tatsuz0u/FairFlag", from: "1.0.0")
```

In a SwiftUI view:

```swift
import FairFlag
  
let emoji = "TW".toFlagEmoji()

let countryCodeImage =
FairFlag.image(countryCode: "TW")?
  .resizable()
  .frame(width: 20, height: 20)

let emojiImage = FairFlag.image(emoji: "🇹🇼")
```
