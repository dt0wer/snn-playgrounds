import SwiftUI

@main struct SNNPlayground: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onDisappear {
					exit(0)
				}
		}
	}
}
