Extension { #name : #RoundBoard }

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> boardWithOnly: cards at: positions Of: boardPositions [

	^ self
		  boardWithOnly: cards
		  at: positions
		  Of: boardPositions
		  with: 100
]

{ #category : #'*IngSoft2-Tests' }
RoundBoard class >> boardWithOnly: effectPositions at: effectTileNumbers Of: numberOfPositions with: aDistance [

	| boardPositions |
	self assertValidNumberOfPositions: numberOfPositions.
	boardPositions := self noEffectPositionBoardWith: numberOfPositions.
	1 to: effectTileNumbers size do: [ :i | 
		boardPositions
			at: (effectTileNumbers at: i)
			put: (effectPositions at: i) ].
	^ self createSome: boardPositions with: aDistance
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
