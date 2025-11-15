import Synchronization
import UniformTypeIdentifiers

extension UTType {
	static var dragItem: UTType {
		UTType(exportedAs: "com.ntest.dragitem")
	}
}

let EPSILON = 1e-7
//@MainActor var globalTimer: Double = 0
let dt = 1.0

let atomicGt = Atomic<UInt64>(0)
