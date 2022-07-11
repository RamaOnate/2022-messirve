Extension { #name : #RoundBoard }

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> assignEffectsTo: effectTileNumbers with: boardPositions and: effectPositions [

	| effectTileSequence maxCycle effectPositionSequence |
	effectTileSequence := Sequence formedBy: effectTileNumbers.
	effectPositionSequence := Sequence formedBy: effectPositions.
	maxCycle := effectTileNumbers size max: effectPositions size.

	1 to: maxCycle do: [ :i | 
		boardPositions
			at: effectTileSequence next
			put: effectPositionSequence next ]
]

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> withNoEffectsOf: positions [ 

	^ self withNoEffectsOf: positions with: 100
]

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> withNoEffectsOf: numberOfPositions with: aDistance [

	| boardPositions |
	self assertValidNumberOfPositions: numberOfPositions.
	boardPositions := self noEffectPositionBoardWith: numberOfPositions.
	^ self createSome: boardPositions with: aDistance
]

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> withOnly: cards at: positions Of: boardPositions [

	^ self
		  withOnly: cards
		  at: positions
		  Of: boardPositions
		  with: 100
]

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> withOnly: effectPositions at: effectTileNumbers Of: numberOfPositions with: aDistance [

	| boardPositions |
	self assertValidNumberOfPositions: numberOfPositions.
	boardPositions := self noEffectPositionBoardWith: numberOfPositions.
	self
		assignEffectsTo: effectTileNumbers
		with: boardPositions
		and: effectPositions.
	^ self createSome: boardPositions with: aDistance
]
