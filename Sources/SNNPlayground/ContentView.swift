import SwiftUI
import Charts
import SNN

struct ContentView: View {
	@StateObject var model = Model()
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Button("Start") {
					model.start()
				}
				.disabled(model.isRun)
				
				Button("Stop") {
					model.stop()
				}
				.disabled(!model.isRun)
				
				Button("Inject") {
					model.pulse = 800.0
				}
				.disabled(!model.isRun)
				
				HStack(spacing: 5) {
					Text("Iconst")
					Slider(value: $model.Iconst, in: 99.0...700)
						.disabled(!model.isRun)
					Text(String(format: "%.2f", model.Iconst))
						.frame(width: 60, alignment: .trailing)
				}
				
			}
			.padding()
			
			Divider()
			
			Chart(model.V, id: \.self) { p in
				LineMark(x:
						.value("Time", p.t),
						 y: .value("V", p.v)
				)
			}
			.chartYScale(domain: -90...50)
			.chartXAxis {
				AxisMarks { value in
					AxisGridLine()
				}
			}
			.border(.gray)
			.background()
			.padding()
		}
	}
}

struct ChartPoint: Hashable {
	var t = Date.now
	var v: Double
}

@MainActor final class Model: ObservableObject {
	private var neuron: Izhikevich
	private let params: IzhikevichParams
	private var task: Task<Void, Never>?
	@Published private(set) var isRun: Bool = false
	@Published private(set) var V: [ChartPoint] = []
	@Published private(set) var spikes: [Int] = []
	@Published var Iconst: Double = 99.0
	@Published var pulse: Double = 0
	
	func stop() {
		if let task { task.cancel() }
	}
	
	private func I() async -> Double {
		let I = Iconst + pulse; pulse = 0
		return I
	}
	
	func start() {
		guard !isRun else { return }
		V.removeAll()
		
		task = Task {
			isRun = true
			
			while !Task.isCancelled {
				let dummySynapseOutput = TotalSynapseOutput(neuronG: 0, neuronGiEi: 0, Iconst: await I())
				if neuron.updateState(by: dummySynapseOutput) {
					spikes.append(spikes.count)
				}
				
				V.append(ChartPoint(v: neuron.V))
				if V.count > 1000 { V.removeFirst() }
				
				try? await Task.sleep(for: .milliseconds(1))
			}
			
			isRun = false
		}
	}
	
	init() {
		neuron = Izhikevich.defaultRegularSpiking()
		params = neuron.params
	}
}

#Preview {
	ContentView()
}
