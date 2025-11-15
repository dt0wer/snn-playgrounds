//
//  ExcitableParams.swift
//  SNNPlayground
//
//  Created by Александр Читалкин on 15.11.2025.
//


// Basic parameters every excitable element must have
protocol ExcitableParams: CustomStringConvertible,
			Codable, Hashable, Sendable
{
	var code: String { get }
	var type: NeuronType { get }
	var weightLimit: Double { get }
	var maxSynapses: Int { get }
	var vr: Double { get }
	
	var dict: [String: Double] { get }
}