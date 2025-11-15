//
//  ExcitableParams.swift
//  SNNPlayground
//
//  Created by Aleksandr Chitalkin on 15.11.2025.
//

// Types of neurons in biological/inspired models
public enum NeuronType: Sendable, Codable { case excitatory, inhibitory }

// Basic parameters every excitable element must have
public protocol ExcitableParams: CustomStringConvertible,
			Codable, Hashable, Sendable
{
	var code: String { get }		// Short code for firing pattern type
	var type: NeuronType { get }	// Excitatory or inhibitory
	var weightLimit: Double { get }
	var parameters: [String: Double] { get }
	var maxSynapses: Int { get }
	var vr: Double { get }			// Resting membrane potential
}
