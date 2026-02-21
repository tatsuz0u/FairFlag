import SwiftUI
import FairFlag

public struct ContentView: View {
    let size: CGFloat = 32
    let columns: Int = 11

    public init() {}

    public var body: some View {
        ScrollView {
            Group {
                if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *) {
                    LazyVGrid(columns: .init(repeating: .init(), count: columns), spacing: .zero) {
                        ForEach(NSLocale.isoCountryCodes, id: \.self) { countryCode in
                            FairFlag.image(countryCode: countryCode)?
                                .resizable()
                                .frame(width: size, height: size)
                        }
                    }
                } else {
                    legacyGrid()
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

private extension ContentView {
    var countryCodeRows: [[String?]] {
        let codes = NSLocale.isoCountryCodes.map(Optional.some)
        let rowCount = Int(ceil(Double(codes.count) / Double(columns)))

        return (0..<rowCount).map { row in
            (0..<columns).map { column in
                let index = row * columns + column
                return index < codes.count ? codes[index] : nil
            }
        }
    }

    func legacyGrid() -> some View {
        VStack(spacing: .zero) {
            ForEach(countryCodeRows.indices, id: \.self) { row in
                HStack(spacing: .zero) {
                    ForEach(countryCodeRows[row].indices, id: \.self) { column in
                        if let countryCode = countryCodeRows[row][column],
                           let image = FairFlag.image(countryCode: countryCode) {
                            image
                                .resizable()
                                .frame(width: size, height: size)
                        } else {
                            Color.clear
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
    }
}

public struct FairFlag_Previews: PreviewProvider {
    public static var previews: some View {
        ContentView()
            .background(Color.white)
            .previewLayout(.fixed(width: 700, height: 800))
    }
}
