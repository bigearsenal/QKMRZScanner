import QKMRZParser
import SwiftUI
import UIKit

struct MRZScannerViewRepresentable: UIViewRepresentable {
    class Coordinator: NSObject, QKMRZScannerViewDelegate, ObservableObject {
        fileprivate var parent: MRZScannerViewRepresentable?
        fileprivate var scannerView: QKMRZScannerView?

        func mrzScannerView(_: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
            parent?.didFindScanResult(scanResult)
        }

        func startScanning() {
            scannerView?.startScanning() // Assuming startScanning() is a method of QKMRZScannerView
        }

        func stopScanning() {
            scannerView?.stopScanning() // Assuming stopScanning() is a method of QKMRZScannerView
        }
    }

    let coordinator: Coordinator
    var didFindScanResult: (QKMRZScanResult) -> Void

    func makeCoordinator() -> Coordinator {
        coordinator.parent = self
        return coordinator
    }

    func makeUIView(context: Context) -> QKMRZScannerView {
        let mrzScannerView = QKMRZScannerView()
        mrzScannerView.delegate = context.coordinator
        context.coordinator.scannerView = mrzScannerView // Store the reference to the scanner view
        return mrzScannerView
    }

    func updateUIView(_: QKMRZScannerView, context _: Context) {
        // Perform updates to the view if necessary
    }
}

public struct MRZPassportView: View {
    @State private var sizeToFit: CGSize?
    @StateObject private var coordinator = MRZScannerViewRepresentable.Coordinator()
    private let resultHandler: (QKMRZScanResult) -> Void

    public init(resultHandler: @escaping (QKMRZScanResult) -> Void) {
        self.resultHandler = resultHandler
    }

    public var body: some View {
        MRZScannerViewRepresentable(
            coordinator: coordinator,
            didFindScanResult: resultHandler
        )
        .background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            sizeToFit = calculateRealSize(proxySize: newSize)
        }
        .frame(width: sizeToFit?.width, height: sizeToFit?.height)
        .onAppear {
            self.coordinator.startScanning() // Start scanning when the view appears
        }
        .onDisappear {
            self.coordinator.stopScanning() // Stop scanning when the view disappears
        }
    }

    private func calculateRealSize(proxySize: CGSize) -> CGSize {
        let width: CGFloat
        let height: CGFloat

        if proxySize.height > proxySize.width {
            width = proxySize.width
            height = width * 88 / 128
        } else {
            height = proxySize.height
            width = height / 88 * 128
        }
        return .init(width: width, height: height)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

private struct MockView: View {
    var body: some View {
        VStack {
            Spacer()
            camera
            Text("Hello")
            Spacer()
        }
    }

    var camera: some View {
        MRZPassportView { scanResult in
            print("Scan result: \(scanResult)")
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        MockView()
    }
}
