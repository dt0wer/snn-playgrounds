import Foundation

// MARK: - Core Protocols and Types

// Basic parameters every excitable element must have
public protocol ExcitableParams: CustomStringConvertible {
	var code: String { get }           // Short code for firing pattern type
	var type: NeuronType { get }       // Excitatory or inhibitory
	var vr: Double { get }             // Resting membrane potential
}

// Types of neurons in biological/inspired models
public enum NeuronType { case excitatory, inhibitory }

// Global constants for simulation timing and precision thresholds
public struct GP {
	public static let dt = 1.0         // Time step (ms or arbitrary unit)
	public static let epsilon = 1e-7   // Stability threshold
}

// Type alias for aggregated synaptic outputs (conductances)
public typealias SynapsesOut = (giEi: Double, G: Double)

// Common neuron interface: can update state and expose membrane voltage
public protocol Excitable {
	associatedtype P: ExcitableParams
	mutating func updateState(_ s: SynapsesOut, constI: Double) -> Bool // returns true if spike fired
	var V: Double { get }              // Current membrane potential
	init(_ params: P)                  // Initializer from parameters
}

// MARK: - Izhikevich Model Parameters

public struct IzhikevichParams: ExcitableParams {
	// Model coefficient parameters
	public var a: Double               // Recovery time constant
	public var b: Double               // Sensitivity of u to v
	public var c: Double               // Reset voltage after spike
	public var d: Double               // Reset adjustment for recovery variable

	public let type: NeuronType        // Neuron type (exc/inhib)
	public var code: String            // Short pattern id, e.g. "RS" for regular spiking
	public var description: String     // Human-readable pattern description

	public var vP: Double               // Spike peak threshold
	public var v0: Double { c }         // Initial membrane potential

	// Extra parameters for generalized model form
	public var k: Double                // Intrinsic gain
	public var C: Double                // Membrane capacitance
	public var vr: Double               // Rest potential
	public var vt: Double               // Threshold potential

	// Explicit initializer for clarity
	public init(a: Double, b: Double, c: Double, d: Double,
				type: NeuronType, code: String, description: String,
				vP: Double, k: Double, C: Double, vr: Double, vt: Double) {
		self.a = a; self.b = b; self.c = c; self.d = d
		self.type = type; self.code = code; self.description = description
		self.vP = vP; self.k = k; self.C = C; self.vr = vr; self.vt = vt
	}
}

// MARK: - Izhikevich Neuron Implementation

public struct Izhikevich {
	private var isStable: Bool = true          // Stability flag
	// State variables: membrane potential v and recovery variable u
	private var state: (v: Double, u: Double)
	private let params: IzhikevichParams       // Model parameters

	public init(_ params: IzhikevichParams) {
		// Initial state: v set to c (reset value), u proportional to v0
		self.state = (v: params.v0, u: params.v0 * params.b)
		self.params = params
	}
}

extension Izhikevich: Excitable {
	public var V: Double { state.v }           // Public voltage accessor

	public mutating func updateState(_ s: SynapsesOut, constI: Double) -> Bool {
		// 1. Local time variables
		var u_dt = GP.dt
		let (v0, u0) = state
		let vr = params.vr
		let vt = params.vt
		let v_dt = GP.dt

		// 2. Compute dv according to Izhikevich equations (with conductance input)
		let dv = params.k * (v0 - vr) * (v0 - vt) - u0 + constI
		let enumerator = dv / params.C + s.giEi
		let v1 = (v0 + v_dt * enumerator) / (1 + v_dt * s.G)

		// 3. Spike detection and interpolation for u update
		var isFire = false
		if v1 >= params.vP {
			u_dt = (params.vP - v0) / (v1 - v0)   // Fraction of dt until spike
			isFire = true
		}

		// 4. Update recovery variable u
		let du = params.a * (params.b * (v0 - vr) - u0)
		let u1 = u0 + du * u_dt

		// 5. Apply reset if fired, else update normally
		if isFire {
			state = (v: params.c, u: u1 + params.d)
		} else {
			state = (v: v1, u: u1)
		}

		// 6. Set stability flag for equilibrium detection
		isStable = abs(dv) < GP.epsilon && !isFire && abs(du) < GP.epsilon
		return isFire
	}
}

// MARK: - Convenience factory
public extension Izhikevich {
	// Preconfigured regular-spiking excitatory neuron
	static func defaultRegularSpiking() -> Izhikevich {
		let p = IzhikevichParams(
			a: 0.01, b: 5, c: -60, d: 400,
			type: .excitatory, code: "RS", description: "Regular spiking",
			vP: 50, k: 3, C: 100, vr: -60, vt: -50
		)
		return Izhikevich(p)
	}
}
