//
//  IzhikevichParams.swift
//  SNNPlayground
//
//  Created by Aleksandr Chitalkin on 15.11.2025.
//

public struct IzhikevichExtra: Codable, Sendable, Hashable {
	let uLimit: Double?
	let bLimit: Double?
	let bL: Double?
}

// Izhikevich Model Parameters
public struct IzhikevichParams: ExcitableParams {
	// Protocol requirements:
	// ExcitableParams
	public let code: String			// Short pattern id, e.g. "RS"
	public let type: NeuronType		// Neuron type (exc/inhib)
	public let weightLimit: Double
	public var parameters: [String : Double] {
		["a": a, "b": b, "c": c, "d": d, "vp": vp,
		 "k": k, "C": C, "vr": vr, "vt": vt]
	}
	public let maxSynapses: Int
	public let vr: Double				// Rest potential

	// CustomStringConvertible
	public var description: String		// Human-readable pattern description

	// Model coefficient parameters
	let a: Double		// Recovery time constant
	let b: Double		// Sensitivity of u to v
	let c: Double		// Reset voltage after spike
	let d: Double		// Reset adjustment for recovery variable
	let vp: Double		// Spike peak threshold
	let v0: Double		// Initial membrane potential
	let vt: Double		// Threshold potential
	let k: Double		// Intrinsic gain
	let C: Double		// Membrane capacitance
	
	let extra: IzhikevichExtra?
		
	// Explicit initializer for clarity
	init(
		a: Double, b: Double, c: Double, d: Double,
		type: NeuronType, code: String, description: String, vr: Double,
		vp: Double, k: Double, C: Double, vt: Double, v0: Double? = nil,
		extra: IzhikevichExtra? = nil, maxSynapses: Int = Int.max,
		weightLimit: Double = 0
	) {
		self.a = a
		self.b = b
		self.c = c
		self.d = d
		self.type = type
		self.code = code
		self.v0 = v0 ?? c
		self.description = description
		self.maxSynapses = maxSynapses
		self.weightLimit = weightLimit
		self.extra = extra
		self.vp = vp
		self.vr = vr
		self.vt = vt
		self.k = k
		self.C = C
	}
}
