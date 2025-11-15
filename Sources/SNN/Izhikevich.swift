//
//  Izhikevich.swift
//  SNNPlayground
//
//  Created by Aleksandr Chitalkin on 15.11.2025.
//

// Izhikevich Neuron Implementation
public final class Izhikevich {
	private(set) public var isStable: Bool = false
	private var state: (v: Double, u: Double)
	public let params: IzhikevichParams
	
	public init(_ params: IzhikevichParams) {
		self.state = (v: params.v0, u: params.v0 * params.b)
		self.params = params
	}
}

extension Izhikevich: Excitable {
	public var V: Double { state.v }
				
	public func updateState(by s: consuming TotalSynapseOutput) -> Bool
	{
		var u_dt = dt
		var b = params.b
		var isFire = false
		let (v0, u0) = state
		let vr = params.vr
		let vt = params.vt
		let v_dt = dt

		if let bLimit = params.extra?.bLimit,
		   let bL = params.extra?.bL, v0 > bLimit
		{
			b = bL
		}
		
		let dv = params.k * (v0 - vr) * (v0 - vt) - u0 + s.Iconst
		let enumer = dv/params.C + s.neuronGiEi
		let v1 = (v0 + v_dt * enumer)/(1 + v_dt * s.neuronG)
				
		if v1 >= params.vp {
			u_dt = (params.vp - v0)/(v1 - v0)
			isFire = true
		}

		let du = params.a * (b * (v0 - vr) - u0)
		var u1 = u0 + du * u_dt
		
		if let uLimit = params.extra?.uLimit, u1 > uLimit {
			u1 = uLimit
		}
		
		if isFire {
			state = (v: params.c, u: u1 + params.d)
		} else {
			state = (v: v1, u: u1)
		}
		
		isStable = abs(dv) < EPSILON && !isFire
		&& abs(du) < EPSILON
		
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
			vr: 50, vp: 3, k: 100, C: -60, vt: -50
		)
		return Izhikevich(p)
	}
}
