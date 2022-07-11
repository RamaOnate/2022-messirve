Class {
	#name : #SequenceTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SequenceTests >> testColorSequenceGivesTheColorsRedBlueAndGreen [

	| sequence red green blue |
	red := Color red.
	green := Color green.
	blue := Color blue.

	sequence := Sequence formedBy: { 
			            red.
			            green.
			            blue }.

	self assert: sequence next equals: green.
	self assert: sequence next equals: blue.
	self assert: sequence next equals: red.
	self assert: sequence next equals: green
]
