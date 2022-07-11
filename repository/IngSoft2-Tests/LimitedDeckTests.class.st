Class {
	#name : #LimitedDeckTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
LimitedDeckTests >> testACancellationCardUsedOnASpeedCardGoesToTheDiscardDeck [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard overloadCard limitedDeck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	overloadCard := OverloadCard new.
	cancellationCard := CancellationCard new.
	limitedDeck := DeckHolder formedBy: { 
			               speedCard.
			               cancellationCard.
			               overloadCard }.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: limitedDeck.

	self assert: limitedDeck cards equals: { overloadCard } asOrderedCollection.
	
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: cancellationCard on: speedCard.
	
	self assert: limitedDeck discardPile equals: { speedCard . cancellationCard } asOrderedCollection.
]

{ #category : #tests }
LimitedDeckTests >> testADeckOfThreeCardsHandsInTheLastCardAndTheDeckInTheDiscardPileIsShuffledToTheCardsAgain [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard limitedDeck |
	aLoadedDie := LoadedDie rolling: { 1 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	limitedDeck := DeckHolder formedBy: { 
			               speedCard.
			               cancellationCard }.
	aBoard := RoundBoard withNoEffectsOf: 10 with: 100.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: limitedDeck.


	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			speedCard.
			cancellationCard } asOrderedCollection.

	self assert: limitedDeck cards size equals: 0.
	aSpaceGame spaceShip: 'Messi' plays: speedCard on: 'Messi'.
	aSpaceGame spaceShip: 'Messi' plays: cancellationCard on: speedCard.
	self assert: limitedDeck discardPile size equals: 2.
	
]

{ #category : #tests }
LimitedDeckTests >> testALimitedDeckCannotHaveLessThanOneCard [

	self
		should: [ DeckHolder formedBy: {} ]
		raise: Error
		whoseDescriptionIncludes: 'DeckHolder must have at least 1 card'
		description: 'Deck must consist of at least 1 card'
]

{ #category : #tests }
LimitedDeckTests >> testAcardDealerEffectDoesNotHandInAnyCardsBecauseDeckHolderIsEmpty [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard limitedDeck |
	aLoadedDie := LoadedDie rolling: { 2 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	limitedDeck := DeckHolder formedBy: { 
			               speedCard.
			               cancellationCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: limitedDeck) }
		          at: { 3 }
		          Of: 10.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: limitedDeck.

	self
		should: [ aSpaceGame playNextTurn ]
		raise: Error
		whoseDescriptionIncludes: 'No cards available to pick up'
		description: 'No cards available to pick up'
]

{ #category : #tests }
LimitedDeckTests >> testAcardDealerEffectHandsInACardThatIsInTheDeckAndAddsItToTheSpaceShip [

	| aSpaceGame aLoadedDie aBoard speedCard cancellationCard overloadCard limitedDeck |
	aLoadedDie := LoadedDie rolling: { 2 }.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	overloadCard := OverloadCard new.
	limitedDeck := DeckHolder formedBy: { 
			               speedCard.
			               cancellationCard.
			               overloadCard }.
	aBoard := RoundBoard
		          withOnly: { (CardDealerEffect handingFrom: limitedDeck) }
		          at: { 3 }
		          Of: 10.
	aSpaceGame := MessirveSpaceRaceGame
		              playedBy: { 'Messi' }
		              on: aBoard
		              rolling: aLoadedDie
		              withLapsToWin: 2
		              handing: limitedDeck.
	aSpaceGame playNextTurn.
	self assert: (aSpaceGame inventoryFrom: 'Messi') equals: { 
			speedCard.
			cancellationCard.
			overloadCard } asOrderedCollection 
]
