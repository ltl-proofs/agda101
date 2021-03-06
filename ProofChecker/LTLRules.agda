module LTLRules where

open import Data.Nat
open import LTL
open import Data.Bool

-- Represents LTL rules

data Seq : ℕ → Set where
  ∅ : Seq zero
  _⋆_ : {n : ℕ} → Seq n → LTL → Seq (suc n)

data _⊨_ : {n : ℕ} → (σ : Seq n) → (φ : LTL) → Set where
  var   : ∀{n} {σ : Seq n} {ψ} → (σ ⋆ ψ) ⊨ ψ
  weak  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ ψ → (σ ⋆ φ) ⊨ ψ
  T-i   : ∀{n} {σ : Seq n} → σ ⊨ T'
  ⊥-e   : ∀{n} {σ : Seq n} {ψ} → σ ⊨ ⊥ → σ ⊨ ψ
  ∼-i   : ∀{n} {σ : Seq n} {φ} → (σ ⋆ φ) ⊨ ⊥ → σ ⊨ (∼ φ)
  ∼-e   : ∀{n} {σ : Seq n} {φ} → σ ⊨ φ → σ ⊨ (∼ φ) → σ ⊨ ⊥
  ⇒-i   : ∀{n} {σ : Seq n} {φ ψ} → (σ ⋆ φ) ⊨ ψ → σ ⊨ (φ ⇒ ψ)
  ⇒-e   : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ (φ ⇒ ψ) → σ ⊨ φ → σ ⊨ ψ
  ∧'-i   : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ φ → σ ⊨ ψ → σ ⊨ (φ ∧' ψ)
  ∧'-e₁  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ (φ ∧' ψ) → σ ⊨ φ
  ∧'-e₂  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ (φ ∧' ψ) → σ ⊨ ψ
  ∨'-i₁  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ φ → σ ⊨ (φ ∨' ψ)
  ∨'-i₂  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ ψ → σ ⊨ (φ ∨' ψ)
  ∨'-e   : ∀{n} {σ : Seq n} {φ ψ χ} → σ ⊨ (φ ∨' ψ) → (σ ⋆ φ) ⊨ χ → (σ ⋆ ψ) ⊨ χ → σ ⊨ χ
  lem   : ∀{n} {σ : Seq n} {φ} → σ ⊨ (φ ∨' (∼ φ))
  -- extended with LTL
  init→◇  : ∀{n} {σ : Seq n} {φ} → σ ⊨ φ → σ ⊨ (◇ φ)
  □-e     : ∀{n} {σ : Seq n} {φ} → σ ⊨ □ φ → σ ⊨ φ
  □→◇     : ∀{n} {σ : Seq n} {φ} → σ ⊨ (□ φ) → σ ⊨ ◇ φ
  ∼□      : ∀{n} {σ : Seq n} {φ} → σ ⊨ (∼ (□ φ)) → σ ⊨ ◇ (∼ φ)
  ∼◇      : ∀{n} {σ : Seq n} {φ} → σ ⊨ (∼ (◇ φ)) → σ ⊨ (□ (∼ φ))
  ◇-i     : ∀{n} {σ : Seq n} {φ} → σ ⊨ φ → σ ⊨ ◇ φ
  ◇-∧'-e₁  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ ◇ (φ ∧' ψ) → σ ⊨ ◇ φ
  ◇-∧'-e₂  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ ◇ (φ ∧' ψ) → σ ⊨ ◇ ψ
  □-∧'-i   : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ □ φ → σ ⊨ □ ψ → σ ⊨ □ (φ ∧' ψ)
  □-∧'-e₁  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ □ (φ ∧' ψ) → σ ⊨ □ φ
  □-∧'-e₂  : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ □ (φ ∧' ψ) → σ ⊨ □ ψ
  □→∼>    : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ □ (φ ⇒ (◇ ψ)) → σ ⊨ (φ ~> (◇ ψ))
  ~>→□    : ∀{n} {σ : Seq n} {φ ψ} → σ ⊨ (φ ~> (◇ ψ)) → σ ⊨ □ (φ ⇒ (◇ ψ))


test : ∀{n} {σ : Seq n} {φ} → (σ ⋆ φ) ⊨ ⊥ → σ ⊨ (∼ φ)
test p = ∼-i p

∧'-comm : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ (φ ∧' ψ) → σ ⊨ (ψ ∧' φ)
∧'-comm p = ∧'-i (∧'-e₂ p) (∧'-e₁ p)

∨'-comm : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ (φ ∨' ψ) → σ ⊨ (ψ ∨' φ)
∨'-comm p = ∨'-e p (∨'-i₂ var) (∨'-i₁ var)

∧'→∨' : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ (φ ∧' ψ) → σ ⊨ (φ ∨' ψ)
∧'→∨' p = ∨'-i₂ (∧'-e₂ p)

□-∧'-split₁ : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ □ (φ ∧' ψ) → σ ⊨ ((□ φ) ∧' (□ ψ))
□-∧'-split₁ p = ∧'-i (□-∧'-e₁ p) (□-∧'-e₂ p)

□-∧'-split₂ : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ ((□ φ) ∧' (□ ψ)) → σ ⊨ □ (φ ∧' ψ)
□-∧'-split₂ p = □-∧'-i (∧'-e₁ p) (∧'-e₂ p)

□-∧'-comm : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ □ (φ ∧' ψ) → σ ⊨ □ (ψ ∧' φ)
□-∧'-comm p = □-∧'-i (□-∧'-e₂ p) (□-∧'-e₁ p)

◇-∧'-split : {φ ψ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ ◇ (φ ∧' ψ) → σ ⊨ ((◇ φ) ∧' (◇ ψ))
◇-∧'-split p = ∧'-i (◇-∧'-e₁ p) (◇-∧'-e₂ p)

exLTL : {φ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ φ → LTL
exLTL {φ} p = φ

⇒-trans : {φ ψ χ : LTL} {n : ℕ} {σ : Seq n} → σ ⊨ (φ ⇒ ψ) → σ ⊨ (ψ ⇒ χ) → σ ⊨ (φ ⇒ χ)
⇒-trans p q = ⇒-i (⇒-e (weak q) (⇒-e (weak p) var))
