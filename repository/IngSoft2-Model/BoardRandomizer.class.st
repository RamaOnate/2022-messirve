Class {
	#name : #BoardRandomizer,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #creation }
BoardRandomizer >> assignDistributedBoardOf: numberOfPositions [

	| source probabilityEvents discreteProbabilityDistribution |
	probabilityEvents := self effectProbabilityEvents.

	discreteProbabilityDistribution := DiscreteProbabilityDistribution 
		                                   withAll: probabilityEvents.
	source := DiscreteProbabilityEventSource with:
		          discreteProbabilityDistribution.

	^ source next: numberOfPositions
]

{ #category : #creation }
BoardRandomizer >> effectProbabilityEvents [

	| atomicBomb hyperJumpEffect moonwalkEffect speedUpEffect wormholeEffect cardDealerEffect nonEffect |
	atomicBomb := AtomicBombEffect new.
	cardDealerEffect := CardDealerEffect handingRandomCards.
	hyperJumpEffect := HyperJumpEffect withAll: { 
			                   (ParsecMeasure of: 50).
			                   (ParsecMeasure of: 40).
			                   (ParsecMeasure of: 30).
			                   (ParsecMeasure of: 20).
			                   (ParsecMeasure of: 10) }.
	moonwalkEffect := MoonWalkEffect randomlyDistributed.
	nonEffect := NonEffect new.
	speedUpEffect := SpeedUpEffect new.
	wormholeEffect := WormHoleEffect new.
	nonEffect := NonEffect new.


	^ { 
		  (ProbabilityEvent of: atomicBomb with: 0.02).
		  (ProbabilityEvent of: cardDealerEffect with: 0.1).
		  (ProbabilityEvent of: hyperJumpEffect with: 0.08).
		  (ProbabilityEvent of: moonwalkEffect with: 0.1).
		  (ProbabilityEvent of: nonEffect with: 0.3).
		  (ProbabilityEvent of: speedUpEffect with: 0.2).
		  (ProbabilityEvent of: wormholeEffect with: 0.2) }
]
