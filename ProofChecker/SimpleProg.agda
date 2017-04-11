{-
  Example module of how to construct a program, a proof and check if it is valid
  or not
-}
module SimpleProg where

{-***** imported modules *****-}
open import Program
open import Label
open import Data.List
open import ProofChecker
open import Rules
open import LTL
open import LTLRule
open import ValidProof
{-****************************-}

{-
  Example of a simple Program (see Program):
prog
(
  block (s 0)
  (
    seg (s 1) < vN 0 :=n nat 0 > ∷
    par (s 2)
    (
      seg (s 3) < vN 0 :=n nat 1 > ∷ 
      seg (s 4) < vN 0 :=n nat 2 > ∷ 
      []
    ) ∷ 
    []
  )
)
-}
simpleProg : Prog
simpleProg = prog main
  where p1 = seg (s 1) < (vN 0) :=n (nat 0) >
        p3 = seg (s 3) < (vN 0) :=n (nat 1) >
        p4 = seg (s 4) < (vN 0) :=n (nat 2) >
        p2 = par (s 2) (p3 ∷ (p4 ∷ []))
        main = block (s 0) (p1 ∷ p2 ∷ [])

{-
  A proof (see ProofChecker) for that if one starts with the LTL formula 
  (at s1), one will eventually end up with (0 EQ 1) (variable 0 will eventually
  have the value 1)
-}
simpleProof : Proof
simpleProof = prf
  where r1 = pStep (progR (seqRule (at (s 0))))
          -- at s1
        r2 = pStep (progR (assRule (at (s 1))))
          -- after s1 ∧ 0 EQ 0
        r3 = pStep (ltlR (∧-e₁))
          -- after s1
        r4 = pStep (progR (atomLive (after (s 1))))
          -- at s2
        r5 = pStep (progR (parRule (at (s 2))))
          -- at s3 ∧ at s4
        r6 = pStep (ltlR ∧-e₁)
          -- at s3
        r7 = pStep (progR (assRule (at (s 3))))
          -- after s3 ∧ 0 EQ 1
        r8 = pStep (ltlR (∧-e₂))
          -- 0 EQ 1
        prf = proof (r1 ∷ (r2 ∷ (r3 ∷ (r4 ∷ r5 ∷ (r6 ∷ r7 ∷ (r8 ∷ []))))))
          -- (at s0) ⇒ ◇(0 EQ 1)

{-
  Simple example of how to use proofCheck (see ProofChecker)
-}
simplePrfCheck : ValidProof
simplePrfCheck = proofCheck simpleProg [] simpleProof ((at (s 0)) ⇒ (◇ (0 EQ 2))) (at (s 7))