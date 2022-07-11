Class {
	#name : #CardTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CardTests >> testASpaceShipBeginsTheGameWithTwoCards [

	| aSpaceGame aLoadedDie aBoard |
	aLoadedDie := LoadedDie rolling: { 5 }.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { OverloadCard new }).

	self
		assert: (aSpaceGame inventoryFrom: 'Messi') size
		equals: 2
]

{ #category : #tests }
CardTests >> testASpaceShipCannotPlayACancellationCardOnAnotherCancellationCard [

	| aSpaceGame aLoadedDie aBoard cancellationCardOne cancellationCardTwo speedCard infiniteDeck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	cancellationCardOne := CancellationCard new.
	cancellationCardTwo := CancellationCard new.
	speedCard := SpeedCard new.
	infiniteDeck := InfiniteDeck madeOf: { 
			                cancellationCardOne.
			                speedCard.
			                cancellationCardTwo }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handing: infiniteDeck) }
		          at: { 3 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: infiniteDeck.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		should: [ 
			aSpaceGame
				spaceShip: 'Messi'
				plays: cancellationCardTwo
				on: cancellationCardOne ]
		raise: Error
		whoseDescriptionIncludes:
		'The targeted card is not currently active'
		description: 'Invalid target chosen'
]

{ #category : #tests }
CardTests >> testASpaceShipCannotPlayAPermanentCardWhenItsNotTheirTurn [

	| aSpaceGame aLoadedDie aBoard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { speedCard }).

	self
		should: [ 
		aSpaceGame spaceShip: 'Armani' plays: speedCard on: 'Messi' ]
		raise: Error
		whoseDescriptionIncludes:
		'Permanent cards can only be played during the turn of a Spaceship'
		description:
		'A permanent card is being played during a different turn of the playing spaceship'
]

{ #category : #tests }
CardTests >> testASpaceShipCannotPlayARedoCardOnASpeedCardDuringATurnThatIsNotTheirs [

	| aSpaceGame aLoadedDie aBoard redoCard speedCard |
	aLoadedDie := LoadedDie rolling: { 6 }.
	redoCard := RedoCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard
		          withOnly: { SpeedUpEffect new }
		          at: { 2 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 5
		              handing: (InfiniteDeck madeOf: { 
				              speedCard.
				              speedCard.
				              redoCard.
				              redoCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.

	self
		should: [ 
		aSpaceGame spaceShip: 'Armani' plays: redoCard on: 'Messi' ]
		raise: Error
		whoseDescriptionIncludes:
		'Permanent cards can only be played during the turn of a Spaceship'
		description:
		'A permanent card is being played during a different turn of the playing spaceship'
]

{ #category : #tests }
CardTests >> testASpaceShipLandsOnAPositionHandingASpeedCardAndNowHasThreeCards [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	deck := InfiniteDeck madeOf: { overloadCard . overloadCard . speedCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 2 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.
	aSpaceGame playNextTurn.

	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			overloadCard.
			overloadCard.
			speedCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testASpaceShipLandsOnAPositionHandingASpeedCardTwiceAndNowHasFourCards [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	deck := InfiniteDeck madeOf:{ overloadCard . overloadCard . speedCard . speedCard }.
	aBoard := RoundBoard
		          withOnly: { 
				          (CardDealerEffect handingFrom: deck).
				          (CardDealerEffect handingFrom: deck) }
		          at: { 2. 3 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.
	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.

	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			overloadCard.
			overloadCard.
			speedCard.
			speedCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testASpaceShipLandsOnASpeedUpAndAdvancesToAPositionHandingSpeedCardButDoesntReceiveTheSpeedCard [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard
		          withOnly: { 
				          SpeedUpEffect new.
				          (CardDealerEffect handing: speedCard) }
		          at: { 2. 6 }
		          Of: 10.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { overloadCard }).
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 6
		with: 1
		in: aSpaceGame.

	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			overloadCard.
			overloadCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysACancellationCardOnOneOfTheTwoActiveSpeedCardsAndBothAreRemoved [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard deck |
	aLoadedDie := LoadedDie rolling: { 2 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard.
			        cancellationCard.
			        speedCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 3 }
		          Of: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.

	aSpaceGame playNextTurn.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: cancellationCard on: speedCard.
	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysACancellationCardOnTheActiveAccelerationCardAndMovesOneTileAhead [

	| aSpaceGame aLoadedDie aBoard accelerationCard cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	accelerationCard := AccelerationCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               accelerationCard.
					               cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: accelerationCard on: 'Messi'.
	aSpaceGame
		spaceShip: 'Messi'
		plays: cancellationCard
		on: accelerationCard.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 2
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysACancellationCardOnTheActiveSpeedUpEffectAndTheEngineIsNoLongerPowered [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf:{ 
				              speedCard.
				              cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 3
		with: 1
		in: aSpaceGame.

	aSpaceGame spaceShip: 'Messi' plays: cancellationCard on: speedCard.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysACancellationCardOnTheSpeedCardOfAnotherPlayerAndAdvancesOneLessSpaceNextTurn [

	| aSpaceGame aLoadedDie aBoard speedCardOne speedCardTwo cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCardOne := SpeedCard new.
	speedCardTwo := SpeedCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               speedCardOne.
					               speedCardTwo.
					               cancellationCard.
					               cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCardOne on: 'Messi'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 3
		with: 1
		in: aSpaceGame.

	aSpaceGame
		spaceShip: 'Armani'
		plays: cancellationCard
		on: speedCardOne.
	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.
	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysACardThatDoesntOwnAndAnErrorExceptionIsRaised [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard
		          withOnly: { 
				          SpeedUpEffect new.
				          (CardDealerEffect handing: speedCard) }
		          at: { 2. 6 }
		          Of: 10.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { overloadCard }).

	self
		should: [ 
		aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi' ]
		raise: Error
		whoseDescriptionIncludes: 'SpaceShip doesnt own that card'
		description: 'SpaceShip doesnt own that card'
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterACancellationWasPlayedAndTheRedoCardCancelsAnActiveAccelerationCard [

	| aSpaceGame aLoadedDie aBoard accelerationCardM accelerationCardA redoCard cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	accelerationCardM := AccelerationCard new.
	accelerationCardA := AccelerationCard new.
	redoCard := RedoCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               accelerationCardM.
					               accelerationCardA.
					               redoCard.
					               cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: accelerationCardM on: aSpaceGame.
	aSpaceGame playNextTurn.

	aSpaceGame
		spaceShip: 'Armani'
		plays: accelerationCardA
		on: aSpaceGame.
	aSpaceGame
		spaceShip: 'Armani'
		plays: cancellationCard
		on: accelerationCardM.
	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Messi' plays: redoCard on: accelerationCardA.

	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame inventoryFrom: 'Armani') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Armani') isEmpty
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterACancellationWasPlayedAndTheRedoCardCancelsAnActiveOverloadCard [

	| aSpaceGame aLoadedDie aBoard overLoadCardM overLoadCardA redoCard cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overLoadCardM := OverloadCard new.
	overLoadCardA := OverloadCard new.
	redoCard := RedoCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overLoadCardM.
					               overLoadCardA.
					               redoCard.
					               cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: overLoadCardM on: 'Messi'.
	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Armani' plays: overLoadCardA on: 'Armani'.
	aSpaceGame
		spaceShip: 'Armani'
		plays: cancellationCard
		on: overLoadCardM.
	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Messi' plays: redoCard on: overLoadCardA.

	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame inventoryFrom: 'Armani') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Armani') isEmpty
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterACancellationWasPlayedAndTheRedoCardCancelsAnActiveSpeedCard [

	| aSpaceGame aLoadedDie aBoard speedCardM speedCardA redoCard cancellationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCardM := SpeedCard new.
	speedCardA := SpeedCard new.
	redoCard := RedoCard new.
	cancellationCard := CancellationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               speedCardM.
					               speedCardA.
					               redoCard.
					               cancellationCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCardM on: 'Messi'.
	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Armani' plays: speedCardA on: 'Armani'.
	aSpaceGame spaceShip: 'Armani' plays: cancellationCard on: speedCardM.
	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Messi' plays: redoCard on: speedCardA.

	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame inventoryFrom: 'Armani') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Armani') isEmpty
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterACancellationWasUsedOnASpeedAndTheRedoCancellsTheLastSpeed [

	| aSpaceGame aLoadedDie aBoard speedCard1 speedCard2 redoCard cancellationCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard1 := SpeedCard new.
	speedCard2 := SpeedCard new.
	redoCard := RedoCard new.
	cancellationCard := CancellationCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard1.
			        speedCard2.
			        redoCard.
			        cancellationCard }.
	aBoard := RoundBoard
		          withOnly: { 
				          (CardDealerEffect handingFrom: deck).
				          (CardDealerEffect handingFrom: deck) }
		          at: { 2. 3 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 3
		              handing: deck.

	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.


	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			speedCard1.
			speedCard2.
			redoCard.
			cancellationCard } asOrderedCollection.

	aSpaceGame spaceShip: 'Messi' plays: speedCard1 on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedCard2 on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: cancellationCard on: speedCard1.

	self
		assert: (aSpaceGame inventoryFrom: 'Messi')
		equals: { redoCard } asOrderedCollection.
	self
		assert: (aSpaceGame activeCardsFrom: 'Messi')
		equals: { speedCard2 } asOrderedCollection.

	aSpaceGame spaceShip: 'Messi' plays: redoCard on: speedCard2.

	self
		assert: aSpaceGame cardApplicator lastCardPlayed
		equals: cancellationCard.

	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty.

	self assert: (aSpaceGame activeCardsFrom: 'Messi') isEmpty.

	aSpaceGame playNextTurn.
	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterARedoCardAndStillAppliesTheSpeedCardFirstlyPlayed [

	| aSpaceGame aLoadedDie aBoard speedCard redoCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard.
			        redoCard.
			        redoCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 2 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 3
		              handing: deck.

	aSpaceGame playNextTurn.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.


	self assert: (aSpaceGame activeCardsFrom: 'Messi') equals: { 
			speedCard.
			speedCard.
			speedCard } asOrderedCollection.

	self
		assert: aSpaceGame cardApplicator lastCardPlayed
		equals: speedCard.

	aSpaceGame playNextTurn.
	self
		assert: 'Messi'
		isAt: 1
		with: 2
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterASpeedCardWasPlayedAndTheSpeedEffectIsTriggeredTwiceToAdvanceToPositionFour [

	| aSpaceGame aLoadedDie aBoard speedCard redoCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               speedCard.
					               redoCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardAfterAnOverloadCardWasPlayedAndTheOverloadEffectIsTriggeredTwiceToGoBackToPositionOne [

	| aSpaceGame aLoadedDie aBoard overloadCard redoCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	redoCard := RedoCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               redoCard }).
	aSpaceGame playNextTurn.
	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardButIsNotSavedAsLastCardPlayed [

	| aSpaceGame aLoadedDie aBoard speedCard redoCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               speedCard.
					               redoCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		assert: aSpaceGame cardApplicator lastCardPlayed
		equals: speedCard
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARedoCardThreeTimesAfterAnOverloadCardWasPlayedAndNextTurnGoesBackOneLap [

	| aSpaceGame aLoadedDie aBoard overloadCard redoCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	redoCard := RedoCard new.
	deck := InfiniteDeck madeOf: { 
			        overloadCard.
			        redoCard.
			        redoCard.
			        redoCard }.
	aBoard := RoundBoard
		          withOnly: { 
				          (CardDealerEffect handingFrom: deck).
				          (CardDealerEffect handingFrom: deck) }
		          at: { 2. 3 }
		          Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 3
		              handing: deck.

	1 to: 5 do: [ :i | aSpaceGame playNextTurn ].

	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: redoCard on: 'Messi'.


	self assert: (aSpaceGame inventoryFrom: 'Messi') isEmpty.
	self assert: (aSpaceGame activeCardsFrom: 'Messi') equals: { 
			overloadCard.
			overloadCard.
			overloadCard.
			overloadCard } asOrderedCollection.

	self
		assert: 'Messi'
		isAt: 1
		with: 2
		in: aSpaceGame.

	aSpaceGame playNextTurn.
	self
		assert: 'Messi'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysARepeatCardAndAdvancesFourTilesBecauseASpeedUpWasThePreviousEffect [

	| aSpaceGame aLoadedDie aBoard repeatCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	repeatCard := RepeatCard new.
	aBoard := RoundBoard withOnly: { SpeedUpEffect new } at: { 2 } Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 5
		              handing: (InfiniteDeck madeOf: { 
					               repeatCard.
					               repeatCard }).

	aSpaceGame playNextTurn.
	aSpaceGame spaceShip: 'Messi' plays: repeatCard on: 'Messi'.

	self
		assert: 'Messi'
		isAt: 5
		with: 2
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysASpeedCardOnAnotherSpaceShipAndItselfAndAnotherSpaceShipPlaysASpeedBoostAndBothGetDoubleEffect [

	| aSpaceGame aLoadedDie aBoard speedCard deck speedBoost |
	aLoadedDie := LoadedDie rolling: { 2 }.
	speedCard := SpeedCard new.
	speedBoost := SpeedBoostCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard.
			        speedBoost.
			        speedCard.
			        speedBoost }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 3 }
		          Of: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Armani'.
	aSpaceGame spaceShip: 'Armani' plays: speedBoost on: speedCard.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 5
		with: 1
		in: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Armani'
		isAt: 5
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysASpeedCardOnAnotherSpaceShipAndTheOtherSpaceShipAdvancesOneExtraSpacePerTurn [

	| aSpaceGame aLoadedDie aBoard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Armani'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 2
		with: 1
		in: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Armani'
		isAt: 3
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysASpeedCardOnItselfAndAdvancesAnExtraPositionEveryTurn [

	| aSpaceGame aLoadedDie aBoard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 3
		with: 1
		in: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 5
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysASpeedCardOnItselfTwiceAndAdvancesThreePositions [

	| aSpaceGame aLoadedDie aBoard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysAnOverloadCardOnAnotherOneAndTheCardGoesToActiveCardsOfTheOtherSpaceShip [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard |
	aLoadedDie := LoadedDie rolling: { 5 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Armani'.

	self
		assert: (aSpaceGame inventoryFrom: 'Messi')
		equals: { overloadCard } asOrderedCollection.

	self assert: (aSpaceGame inventoryFrom: 'Armani') equals: { 
			speedCard.
			speedCard } asOrderedCollection.

	self assert: (aSpaceGame activeCardsFrom: 'Messi') isEmpty.

	self
		assert: (aSpaceGame activeCardsFrom: 'Armani')
		equals: { overloadCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysAnOverloadCardOnAnotherSpaceShipAndItDoesntMoveAfterRollingOne [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Armani'.
	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 2
		with: 1
		in: aSpaceGame.

	self
		assert: 'Armani'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysAnOverloadCardOnItselfAndHasOnlyOneCardLeft [

	| aSpaceGame aLoadedDie aBoard overloadCard speedCard |
	aLoadedDie := LoadedDie rolling: { 5 }.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               speedCard }).

	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Messi'.

	self assert: (aSpaceGame inventoryFrom: 'Messi') size equals: 1.

	self
		assert: (aSpaceGame inventoryFrom: 'Messi')
		equals: { speedCard } asOrderedCollection.

	self
		assert: (aSpaceGame activeCardsFrom: 'Messi')
		equals: { overloadCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysSpeedBoostOnASpeedCardAndAdvancesTwoSpaces [

	| aSpaceGame aLoadedDie aBoard speedCard deck speedBoost|
	aLoadedDie := LoadedDie rolling: { 2 }.
	speedCard := SpeedCard new.
	speedBoost := SpeedBoostCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard.
			        speedBoost }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 3 }
		          Of: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedBoost on: speedCard.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 5
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipPlaysTwoSpeedCardsOnItSelfPlaysTheTurnReceivesASpeedCardPlaysTheNewlyReceivedSpeedCardPlaysTheNextTurnAndAdvancesOneLap [

	| aSpaceGame aLoadedDie aBoard speedCard deck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	deck := InfiniteDeck madeOf: { 
			        speedCard.
			        speedCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: deck) }
		          at: { 4 }
		          Of: 7.

	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: deck.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 4
		with: 1
		in: aSpaceGame.

	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 1
		with: 2
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipUsesARepeatCardAfterAnotherSpaceShipLandedOnASpeedEffect [

	| aSpaceGame aLoadedDie aBoard repeatCard |
	aLoadedDie := LoadedDie rolling: { 6 }.
	repeatCard := RepeatCard new.
	aBoard := RoundBoard withOnly: { SpeedUpEffect new } at: { 2 } Of: 5.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Paredes'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 5
		              handing: (InfiniteDeck madeOf: { repeatCard }).

	aSpaceGame playNextTurn.
	self
		assert: 'Messi'
		isAt: 1
		with: 3
		in: aSpaceGame.
	aSpaceGame spaceShip: 'Armani' plays: repeatCard on: 'Armani'.
	self
		assert: 'Armani'
		isAt: 5
		with: 1
		in: aSpaceGame.
	aSpaceGame spaceShip: 'Paredes' plays: repeatCard on: 'Armani'.
	self
		assert: 'Armani'
		isAt: 4
		with: 2
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipUsesAnAccelerationAndAfterPlayingNextTurnAdvancesToNextLap [

	| aSpaceGame aLoadedDie aBoard accelerationCard |
	aLoadedDie := LoadedDie rolling: { 4 }.
	accelerationCard := AccelerationCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 5
		              handing: (InfiniteDeck madeOf: { accelerationCard }).

	aSpaceGame spaceShip: 'Messi' plays: accelerationCard on: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 1
		with: 2
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testASpaceShipUsesAnAccelerationAndIncreasesEnginePowerOfAllSpaceShipsInOne [

	| aSpaceGame aLoadedDie aBoard accelerationCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	accelerationCard := AccelerationCard new.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { accelerationCard }).

	aSpaceGame spaceShip: 'Messi' plays: accelerationCard on: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 3
		with: 1
		in: aSpaceGame.

	aSpaceGame playNextTurn.

	self
		assert: 'Armani'
		isAt: 3
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testAllPlayingSpaceShipsPlayOverloadCardOnItselfTwiceAndAfterNextTurnGoesBackOneLap [

	| aSpaceGame aLoadedDie aBoard overloadCard |
	aLoadedDie := LoadedDie rolling: { 1 }.
	overloadCard := OverloadCard new.
	aBoard := RoundBoard withNoEffectsOf: 3 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 3
		              handing: (InfiniteDeck madeOf: { overloadCard }).

	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.
	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 1
		with: 2
		in: aSpaceGame.

	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: overloadCard on: 'Messi'.

	aSpaceGame playNextTurn.

	self
		assert: 'Messi'
		isAt: 1
		with: 1
		in: aSpaceGame
]

{ #category : #tests }
CardTests >> testSixSpaceShipsBeginTheGameWithOverloadAndSpeedCards [

	| aSpaceGame aLoadedDie aBoard speedCard overloadCard |
	aLoadedDie := LoadedDie rolling: { 5 }.
	speedCard := SpeedCard new.
	overloadCard := OverloadCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy:
		              { 'Messi'. 'Armani'. 'De Paul'. 'Di Maria'. 'Lo Celso'.
		              'Paredes' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               speedCard.
					               overloadCard }).
	aSpaceGame playNextTurn.

	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			overloadCard.
			overloadCard } asOrderedCollection.

	self assert: (aSpaceGame inventoryFrom: 'Armani') equals: { 
			speedCard.
			speedCard } asOrderedCollection.
	self assert: (aSpaceGame inventoryFrom: 'De Paul') equals: { 
			overloadCard.
			overloadCard } asOrderedCollection.
	self assert: (aSpaceGame inventoryFrom: 'Di Maria') equals: { 
			overloadCard.
			overloadCard } asOrderedCollection.
	self assert: (aSpaceGame inventoryFrom: 'Lo Celso') equals: { 
			speedCard.
			speedCard } asOrderedCollection.
	self assert: (aSpaceGame inventoryFrom: 'Paredes') equals: { 
			overloadCard.
			overloadCard } asOrderedCollection
]

{ #category : #tests }
CardTests >> testTwoSpaceShipsBeginTheGameWithOverloadAndSpeedCards [

	| aSpaceGame aLoadedDie aBoard speedCard overloadCard |
	aLoadedDie := LoadedDie rolling: { 5 }.
	speedCard := SpeedCard new.
	overloadCard := OverloadCard new.
	aBoard := RoundBoard withNoEffectsOf: 5 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi'. 'Armani' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: (InfiniteDeck madeOf: { 
					               overloadCard.
					               speedCard.
					               speedCard.
					               overloadCard }).
	aSpaceGame playNextTurn.

	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			overloadCard.
			speedCard } asOrderedCollection.

	self assert: (aSpaceGame inventoryFrom: 'Armani') equals: { 
			speedCard.
			overloadCard } asOrderedCollection
]
