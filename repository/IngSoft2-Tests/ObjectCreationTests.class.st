Class {
	#name : #ObjectCreationTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
ObjectCreationTests >> testADieCannotHaveLessThanThreeSides [

	self
		should: [ RandomDie withSides: -1 ]
		raise: Error
		whoseDescriptionIncludes: 'A die cannot have less than three sides'
		description: 'Die sides must be >= 3'
]

{ #category : #tests }
ObjectCreationTests >> testAGameCannotBePlayedWithLessThanTwoLaps [

	| aLoadedDie1 aLoadedDie2 aDiceCup aBoard |
	aLoadedDie1 := LoadedDie rolling: { 3 }.
	aLoadedDie2 := LoadedDie rolling: { 4 }.
	aDiceCup := DiceCup withAll: { 
			            aLoadedDie1.
			            aLoadedDie2 }.
	aBoard := RoundBoard withNoEffectsOf: 6.

	self
		should: [ 
			MessirveSpaceRaceGame
				playedBy: { 'Messi'. 'De Paul' }
				on: aBoard
				rolling: aDiceCup
				withLapsToWin: 1
				handing: { SpeedCard new } ]
		raise: Error
		whoseDescriptionIncludes: 'Laps must be greater than one'
		description: 'Laps must be two or higher for game to start'
]

{ #category : #tests }
ObjectCreationTests >> testAMoonWalkBoardPositionCannotHaveAnNLowerThanOne [

	self
		should: [ 
			MoonWalkEffect takingBack: 0 ]
		raise: Error
		whoseDescriptionIncludes: 'Amount of back positions must be higher than 0'
		description:
		'The N belonging to a MoonWalk position cannot be smaller than 1'
]

{ #category : #tests }
ObjectCreationTests >> testARoundBoardCanAddOneEffectToDifferentPositions [

	| aBoard speedUpEffect |
	speedUpEffect := SpeedUpEffect new.
	aBoard := RoundBoard withOnly: { speedUpEffect } at: { 2 . 4 . 5 } Of: 5.
	self assert: (aBoard boardEffects at: 2) equals: speedUpEffect.
	self assert: (aBoard boardEffects at: 4) equals: speedUpEffect.
	self assert: (aBoard boardEffects at: 5) equals: speedUpEffect.
	
]

{ #category : #tests }
ObjectCreationTests >> testARoundBoardCannotBeCreatedWithLessThanTwoPositions [

	self
		should: [ RoundBoard with: 1 on: (ParsecMeasure of: 100) ]
		raise: Error
		whoseDescriptionIncludes:
		'A board cannot have less than two positions'
		description: 'Board positions must be >1'
]

{ #category : #tests }
ObjectCreationTests >> testASpaceShipBeginsInPositionOne [

	| aSpaceGame aBoard |
	aBoard := RoundBoard with: 100 on: (ParsecMeasure of: 100).
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: ''
		              withLapsToWin: 2
		              handing: { SpeedCard new }.

	self
		assert: 'Messi'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
ObjectCreationTests >> testSpaceShipsPlayingBeginAtLapOne [

	| aSpaceGame aBoard |
	aBoard := RoundBoard with: 100 on: (ParsecMeasure of: 100).
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'De Paul' }
		              on: aBoard
		              rolling: ''
		              withLapsToWin: 2
		              handing: { SpeedCard new }.

	self
		assert: 'Messi'
		isAt: 1
		with: 1
		in: aSpaceGame.

	self
		assert: 'De Paul'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
ObjectCreationTests >> testTwoSpaceshipsWithTheSameNameCannotBeAddedToGame [

	| aSpaceGame aBoard aDiceCup |
	aBoard := RoundBoard with: 100 on: (ParsecMeasure of: 100).
	aDiceCup := DiceCup withAll: { '' }.

	self
		should: [ 
			aSpaceGame := MessirveSpaceRaceGame
				              playedBy: { 'Messi'. 'Messi' }
				              on: aBoard
				              rolling: aDiceCup
				              withLapsToWin: 1
				              handing: { SpeedCard new } ]
		raise: Error
		whoseDescriptionIncludes: 'SpaceShip name duplicated'
		description:
		'Two SpaceShip with the same name cannot be added to game'
]
