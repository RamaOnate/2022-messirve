Class {
	#name : #RepeatCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #private }
RepeatCard >> activatedTo: aTarget poweredBy: anEnginePowerApplicator on: aCardApplicator from: aGame [ 

	anEnginePowerApplicator applyRepeatTargetting: aTarget in: aCardApplicator from: aGame
]

{ #category : #private }
RepeatCard >> inventoriesAfterTargeting: aTarget from: inventories on: aCardApplicator [

	^ inventories
]

{ #category : #asserting }
RepeatCard >> playOf: cardPlayer at: cardTarget on: aCardApplicator from: aGame [

	aCardApplicator handleInstantaneousOf: self.

]
