//
//  TotalOutput.swift
//  SNNPlayground
//
//  Created by Aleksandr Chitalkin on 15.11.2025.
//

public struct TotalSynapseOutput {
	var neuronG: Double = 0		// Total conductances
	var neuronGiEi: Double = 0
	var Iconst: Double = 0		// Constant input for testing purposes
	
	public init(neuronG: Double, neuronGiEi: Double, Iconst: Double) {
		self.neuronG = neuronG
		self.neuronGiEi = neuronGiEi
		self.Iconst = Iconst
	}
}
