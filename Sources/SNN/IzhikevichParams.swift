import Foundation
import SwiftUI

struct IzhikevichParams: ExcitableParams {
	var a: Double
	var b: Double
	var c: Double
	var d: Double
	
	let type: NeuronType

	var code: String
	var description: String

	var vP: Double
	var v0: Double { c }
	
	var k: Double
	var C: Double
	var vRest: Double
	var vt: Double
	
	var uLimit: Double?
	var bLimit: Double?
	var maxSynapses = Int.max
	var rheobase: Rheobase?
	var weightLimit: Double
	var bL: Double?
	
	var dict: [String : Double] {
		["a": a, "b": b, "c": c, "d": d, "vP": vP,
		 "k": k, "C": C, "vRest": vRest, "vt": vt]
	}
	
//	static var transferRepresentation: some TransferRepresentation {
//		CodableRepresentation(contentType: .excitableParams)
//		ProxyRepresentation(exporting: \.code)
//	}

	init(a: Double, b: Double, c: Double, d: Double, type: NeuronType,
		 code: String, description: String, vP: Double, k: Double, C: Double,
		 vRest: Double, vt: Double, rheobase: Rheobase? = nil,
		 uLimit: Double? = nil, bLimit: Double? = nil, bL: Double? = nil,
		 maxSynapses: Int = Int.max, sMax: Double)
	{
		self.a = a
		self.b = b
		self.c = c
		self.d = d
		self.type = type
		self.code = code
		self.description = description
		self.vP = vP
		self.k = k
		self.C = C
		self.vRest = vRest
		self.vt = vt
		self.rheobase = rheobase
		self.uLimit = uLimit
		self.bLimit = bLimit
		self.bL = bL
		self.maxSynapses = maxSynapses
		self.weightLimit = sMax
	}
}

extension IzhikevichParams {
	func stsp(targetCode: String) -> STSP? {
		let sKind = IzhikevichTemplate(rawValue: self.code)
		let dKind = IzhikevichTemplate(rawValue: targetCode)

		return switch sKind {
		case .bFS:
			switch dKind {
			case .RS: STSP(.FStoRS)
			case .bFS: STSP(.FStoFS)
			default: nil
			}
		case .RS:
			switch dKind {
			case .RS: STSP(.RStoRS)
			case .bFS: STSP(.RStoFS)
			case .nb1LS, .nbLTS: STSP(.RStoLSLTS)
			default: nil
			}
		case .TC:
			switch dKind {
			case .bFS: STSP(.TCtoFS)
			case .RS: STSP(.TCtoRS)
			default: nil
			}
		default: nil
		}
	}
}
