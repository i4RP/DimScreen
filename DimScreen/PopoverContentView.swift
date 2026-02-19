import SwiftUI

struct PopoverContentView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "sun.min.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text("DimScreen")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $brightnessManager.isEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            Divider()

            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "sun.max.fill")
                        .font(.body)
                        .foregroundColor(.yellow)
                    Slider(value: $brightnessManager.dimLevel, in: 0...0.85, step: 0.01)
                        .disabled(!brightnessManager.isEnabled)
                    Image(systemName: "moon.fill")
                        .font(.body)
                        .foregroundColor(.indigo)
                }

                Text("\(Int(brightnessManager.dimLevel * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            }

            Divider()

            HStack {
                Spacer()
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("終了")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .frame(width: 260)
    }
}
