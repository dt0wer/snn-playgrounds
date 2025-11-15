//
//  Excitable.swift
//  SNNPlayground
//
//  Created by Aleksandr Chitalkin on 15.11.2025.
//

// Common neuron interface: can update state and expose membrane voltage
public protocol Excitable  {
	var isStable: Bool { get }
	associatedtype Params: ExcitableParams
	// returns true if spike fired
	func updateState(by s: consuming TotalSynapseOutput) -> Bool
	init(_ params: Params) // Initializer from parameters
	var V: Double { get } // Current membrane potential
}
