<h1 align="center">FairFlag</h1>

<h4 align="center">A SwiftUI country flag package built to mitigate Taiwan flag censorship issues.</h4>

<p align="center">
<picture>
<img src="FairFlag.png" width="512" alt="BitRemote app icon.">
</picture>
</p>

## Background

In some CN region iPhone environments, the Taiwan flag emoji can fail to render. `FairFlag` solves this by:

- Rendering `TW` from an included ROC image asset.
- Keeping all other country codes on normal emoji-based rendering.


## Features

- Convert ISO country codes to flag emoji (`String.toFlagEmoji()`).
- Render emoji flags as SwiftUI `Image` (`FairFlag.image(countryCode:)`).

## Requirements

- Swift 5.3
- iOS 13.0
- watchOS 6.0
- tvOS 13.0
- macOS 10.15
- visionOS 1.0

## Usage

Add `FairFlag` to your `Package.swift`:

```swift
.package(url: "https://github.com/tatsuz0u/FairFlag", from: "1.0.0")
```

In a SwiftUI view:

```swift
import FairFlag
  
let emoji = "TW".toFlagEmoji() // "🇹🇼"

let flagImage = FairFlag.image(countryCode: "TW")?
  .resizable()
  .frame(width: 20, height: 20)
```
