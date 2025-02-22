Class {
	#name : #RoundBoard,
	#superclass : #Object,
	#instVars : [
		'startingPosition',
		'boardEffects',
		'lastPosition',
		'parsecs',
		'lastEffectApplied',
		'distance'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #verification }
RoundBoard class >> assertValidBoardPositions: boardPositions [

	boardPositions size < 2 ifTrue: [ 
		Error signal: 'A board cannot have less than two positions' ]
]

{ #category : #verification }
RoundBoard class >> assertValidNumberOfPositions: numberOfPositions [

	numberOfPositions < 2 ifTrue: [ 
		Error signal: 'A board cannot have less than two positions' ]
]

{ #category : #'instance creation' }
RoundBoard class >> createSome: boardPositions with: aDistance [

	^ self new initializeSome: boardPositions with: aDistance
]

{ #category : #verification }
RoundBoard class >> noEffectPositionBoardWith: numberOfTiles [

	| boardPositions |
	boardPositions := OrderedCollection new.
	1 to: numberOfTiles do: [ :i | boardPositions add: NonEffect new ].
	^ boardPositions
]

{ #category : #initialization }
RoundBoard class >> with: numberOfPositions on: aDistance [

	| defaultBoardPositions boardRandomizer |
	self assertValidNumberOfPositions: numberOfPositions.
	boardRandomizer := BoardEffectSpecification new.
	defaultBoardPositions := boardRandomizer distributedBoardOf:
		                         numberOfPositions.
	self assertValidBoardPositions: defaultBoardPositions.
	^ self createSome: defaultBoardPositions with: aDistance
]

{ #category : #private }
RoundBoard >> advance: aStatus from: statuses to: aPosition [

	| newStatus newStatuses |
	newStatus := SpaceShipStatus with: aStatus spaceShip and: aPosition.

	newStatuses := statuses copy.
	newStatuses replaceAll: aStatus with: newStatus.
	^ newStatuses
]

{ #category : #private }
RoundBoard >> applyLastEffectTo: aSpaceShipStatus from: statuses on: aGame [

	| effectApplicator |
	effectApplicator := EffectApplicator new.

	^ effectApplicator
		  apply: lastEffectApplied
		  on: statuses
		  activatedBy: aSpaceShipStatus
		  playedOn: self
		  and: aGame
]

{ #category : #accessing }
RoundBoard >> boardEffects [
	^ boardEffects
]

{ #category : #accessing }
RoundBoard >> effectAppliedOnPosition: aPosition [

	^ boardEffects at: aPosition
]

{ #category : #initialization }
RoundBoard >> initializeSome: boardPositions with: aDistance [

	startingPosition := 1.
	boardEffects := boardPositions asOrderedCollection.
	lastPosition := boardPositions size.
	distance := aDistance.
	lastEffectApplied := {  }
]

{ #category : #private }
RoundBoard >> lapAfter: newDistanceTravelled [

	^ newDistanceTravelled % lastPosition = 0
		  ifTrue: [ newDistanceTravelled // lastPosition ]
		  ifFalse: [ newDistanceTravelled // lastPosition + 1 ]
]

{ #category : #accessing }
RoundBoard >> lastPosition [

	^ lastPosition
]

{ #category : #private }
RoundBoard >> newPositionAfter: aStatus rolled: aDiceResult on: aGame [

	| newDistanceTravelled lastPossibleDistance newTile newLap |
	newDistanceTravelled := aStatus position distanceTraveled
	                        + aDiceResult.

	lastPossibleDistance := lastPosition * aGame lapsToWin.

	newTile := self tileAfter: newDistanceTravelled.

	newLap := self lapAfter: newDistanceTravelled.

	newDistanceTravelled <= 0
		ifTrue: [ ^ SpaceShipPosition with: 1 and: 1 on: self ]
		ifFalse: [ 
			newDistanceTravelled > lastPossibleDistance
				ifTrue: [ 
				^ SpaceShipPosition with: 1 and: aGame lapsToWin on: self ]
				ifFalse: [ ^ SpaceShipPosition with: newTile and: newLap on: self ] ]
]

{ #category : #private }
RoundBoard >> newStatusesAfter: newStatus applyingTheEffectOf: newPosition over: newStatuses on: aGame [

	| effectApplicator |
	lastEffectApplied := self effectAppliedOnPosition: newPosition tile.
	effectApplicator := EffectApplicator new.
	^ effectApplicator
		  apply: lastEffectApplied
		  on: newStatuses
		  activatedBy: newStatus
		  playedOn: self
		  and: aGame
]

{ #category : #private }
RoundBoard >> newStatusesFrom: statuses afterA: diceRoll from: rollingStatus on: aGame [

	| newPosition newStatus newStatuses |
	newPosition := self
		               newPositionAfter: rollingStatus
		               rolled: diceRoll
		               on: aGame.
	newStatus := SpaceShipStatus
		             with: rollingStatus spaceShip
		             and: newPosition.
	newStatuses := statuses copy.
	newStatuses replaceAll: rollingStatus with: newStatus.
	^ self
		  newStatusesAfter: newStatus
		  applyingTheEffectOf: newPosition
		  over: newStatuses
		  on: aGame
]

{ #category : #accessing }
RoundBoard >> parsecsPerPosition [

	^ (distance totalParsecs) / lastPosition
]

{ #category : #accessing }
RoundBoard >> startingPosition [

	^ startingPosition
]

{ #category : #private }
RoundBoard >> tileAfter: newDistanceTravelled [

	^ newDistanceTravelled % lastPosition = 0
		  ifTrue: [ lastPosition ]
		  ifFalse: [ newDistanceTravelled % lastPosition ]
]
