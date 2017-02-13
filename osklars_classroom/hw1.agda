module hw1 where

-- 1

  data Bool : Set where
    true : Bool
    false : Bool

  not : Bool → Bool
  not true = false
  not false = true

  _or_ : Bool → Bool → Bool
  true or _ = true
  false or x = x

  _and_ : Bool → Bool → Bool
  false and _ = false
  true and x = x

  if_then_else_ : {A : Set} → Bool → A → A → A
  if true then x else _ = x
  if false then _ else x = x

  _implies_ : Bool → Bool → Bool
  false implies true = false
  _ implies _ = true

-- 2

-- a

  data Nat : Set where
    O : Nat
    _+1 : Nat → Nat

  _equals_ : Nat → Nat → Bool
  O equals O = true
  O equals n = false
  n equals O = false
  (n +1) equals (m +1) = n equals m

  _odd : Nat → Bool
  O odd = false
  (O +1) odd = true
  ((n +1) +1) odd = n odd

-- b

  _+_ : Nat → Nat → Nat
  O + n = n
  (n +1) + m = (n + m) +1

  _*_ : Nat → Nat → Nat
  O * n = O
  (n +1) * m = m + (n * m)

-- 3

  data Maybe (A : Set) : Set where
    nothing : Maybe A
    just : A → Maybe A

  data List (A : Set) : Set where
    [] : List A
    _,_ : A → List A → List A

  tail : {A : Set} → List A → Maybe (List A)
  tail [] = nothing
  tail (_ , list) = just list

-- 4

-- a

  zipwidth : {A B C : Set} → (A → B → C) → List A → List B → List C
  zipwidth _ _ [] = []
  zipwidth _ [] _ = []
  zipwidth f (a , as) (b , bs) = (f a b) , (zipwidth f as bs)

-- b

  data Vector (A : Set) : Nat → Set where
    0dim : Vector _ O
    _::_ : {n : Nat} → A → Vector A n → Vector A (n +1)

  zipwidthv : {A B C : Set} → {n : Nat} → (A → B → C) → Vector A n → Vector B n → Vector C n
  zipwidthv _ 0dim 0dim = 0dim
  zipwidthv f (a :: as) (b :: bs) = (f a b) :: (zipwidthv f as bs)

  data Pair (A B : Set) : Set where
    pair : A → B → Pair A B

-- 5

-- a

  iterate : {A : Set} → Nat → (A → A) → A → A
  iterate O _ a = a
  iterate (n +1) f a = iterate n f (f a)

  idNat : Nat → Nat
  idNat n = iterate n _+1 O

-- Homework 2

-- 5 cont

  --trans : {A : Set} → {}

-- Concurrency

  -- p and q
  
  data Rowp : Set where
    one : Rowp
    end : Rowp
    
  data Rowq : Set where
    one : Rowq
    two : Rowq
    end : Rowq

  data Loc : Set where
    pair : Rowp → Rowq → Loc
    
  --x and y

  data Val : Set where
    pair : Nat → Nat → Val

  data State : Set where
    loc_val_ : Loc → Val → State
  {-  
  data State : Set where
    init : Loc → Val → State
    p : State → State
    q : State → State
    -}

  init : State
  init = loc (pair one one) val (pair O O)

  p : State → State
  p (loc (pair one q) val (pair x y)) = loc (pair end q) val (pair (O +1) y) --example p1 : x = 1 (atomic)
  --p (loc (pair end q) val v) = loc (pair end q) val v --action at end always returns the same state
  p (loc l val v) = loc l val v

  q : State → State
  q (loc (pair p one) val (pair O y)) = loc (pair p two) val (pair O y) --example q1 : while x==O
  q (loc (pair p one) val (pair x y)) = loc (pair p end) val (pair x y) --still q1
  q (loc (pair p two) val (pair x y)) = loc (pair p one) val (pair x (y +1)) -- example q2 : y = y+1 (atomic)
  q (loc l val v) = loc l val v

  data Real : State → Set where
    Start : Real init
    stepp : {s : State} → Real s → Real (p s)
    stepq : {s : State} → Real s → Real (q s)


  --I wan't a type that is a state but where x is 1
  data Goal : Set where
    


  --proof of type box diamond x=1
  --with other words: every real state can yeild a state with x=1

  proof : {s : State} -> {N  : Nat} -> {L : Loc}   → Real s → Real (loc L val (pair (O +1) N))
  --proof : {s : State} → Real s → {l : Loc} {y : Nat} → Real Goal
  proof Start = stepp Start
  proof stepp s = stepp s
  proof stepq s = stepp (stepq s)
  
 {-
  --PSEUDO CODE
  data Eventually : State → State → Set where 
     : Eventually

  data Always : Bool → Set where
    always true : Always

  --assumption of program excecution
  assumption : State is only constructed through init or p or q.
  --assumption of fair scheduler
  assumption : {s : State} always eventually (p s) and always eventually (q s)

  proof : (real s) implies eventually (x equals (O +1))
  
    use always eventually p of s
  case1 : p (loc (pair one _) val _) → x = 1

    use state only constructed through init or p or q: state  where 
  case2 : p (loc (pair end _) val _) →  x = x (=1 from case1)
  -}