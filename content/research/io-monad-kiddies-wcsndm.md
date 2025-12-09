# Explain IO Monad in 2025

It's 2025 now and I find someone (including myself several days before) still does not understand IO Monads in functional programming languages. For any ambitious computer scientist (or at least you should call yourself as such instead of "programmer"), not understanding this concept will severely reduce the opportunity of bragging in IM channels and tech forums, causing potential mental distress and loss of self-esteem. If that's you, don't worry, this article is here to help you out. Hi, this is Chuigda, let's discuss IO and IO Monads.

## Couldn't you just let me perform the f*cking IO?

Well, I believe you'd ask me this and you won't let me get away without having a satisfactory answer. In fact, when I was learning functional programming languages, I've also asked others this question before and searched on the internet. However, most answers are merely "function should be pure" or "to separate side effects from pure functions". These answers are not satisfactory at all, so now let's construct a convincing answer together.

To begin, let's see what makes a function pure. An important characteristic of pure functions is **referential transparency**. The definition of referential transparency is that **an expression can be replaced with its corresponding value without changing the program's behavior**, and this naturally implies **determinism**: **the function always produces the same output for the same input**. You can see that there's no "must not have side effects" or "must not perform IO" in the literal definition text, but we'll immediately see why performing IO is inherently not referentially transparent:

```lean
/- Let's assume that there's a read function without all the bells and whistles -/
def read (filename : String) : String := magic

/- Could this proposition hold? -/
theorem monika_great_theorem : read "monika.chr" = read "monika.chr" := rfl
```

In the code snippet above, we read the same file twice. However, if the file is modified between the two reads, the two results will be different. If we consider `read` as a referentially transparent function (consider it deterministic), then the proposition above should type check, but actually we have no reason to believe it. We know that once you prove a proposition like `1 = 2`, you can prove anything. Then your world suddenly descends into a state of constant pancake flip-flopping and historical nihilism reminiscent of the Soviet era -- where everything is meaningless and every action is futile, leading to the inevitable collapse of the Union. This is definitely not what you want.

You may argue that referential transparency is only important for theorem proving languages like Lean/Agda, and is completely irrelevant to your dirty dirty industrial codebase where IO happen every time you ping your database. Your argument is solid and correct, and in fact there are not-that-functional functional programming languages that simply allow performing IO without any restriction:

```scheme
(define (drill-launch-missile)
    (display "Missile launched!")
    (display "That's just a drill!"))
```

So for Lean/Agda, the "referential transparency" answer is convincing enough. But for Haskell, we'd better find a more convincing answer.

## It's all about expression evaluation

In spite of determinism, there's another implication of referential transparency: **expressions can be evaluated in any order**, and **we can replace evaluated expressions with their values at any time**. Consider the following code:

```haskell
-- Library code
-- Once again, let's assume that there's a print function without all the bells and whistles
print :: String -> ()
print = magic

-- User code
mutualAssuredDestruction :: ()
mutualAssuredDestruction =
    -- Enemy NMD system can intercept our missile launch
    -- So launch multiple times to make sure at least one gets through
    let x = print "Missile launched!"
        y = print "Missile launched!"
        z = print "Missile launched!"
    in ()

main :: ()
main = mutualAssuredDestruction
```

And the implication of referential transparency starts to bother. On the one hand, since the three `print` calls are identical, if `print` is considered referentially transparent, we should be able to replace `y` and `z` with the already evaluated `x`:

```haskell
mutualAssuredDestruction :: ()
mutualAssuredDestruction =
    let x = print "Missile launched!"
        y = x -- What?
        z = x -- What?
    in ()
```

So the general secretary asked you to launch three missiles, and you just launched one missile and claimed that you launched three missiles. That must be great. See you on the court-martial.

On the other hand, even if we don't do the above replacement, since expressions can be evaluated in any order, the compiler is theoretically free to evaluate later expression first:

```haskell
militaryDrill :: ()
militaryDrill =
    let x = print "Missile launched!"
        y = print "That's just a drill!"
    in ()
```

Compiler may evaluate `y` first and then `x`, and the two commands output in reverse order could confuse the soldiers quite well.

What's worse, in a programming langauge with **lazy evaluation** like Haskell, expressions might not be evaluated at all if not needed. So if we never use `x`, `y` or `z`, none of the three `print` calls will be executed:

```haskell
mutualAssuredDestruction :: ()
mutualAssuredDestruction =
    let x = () -- eliminated
        y = () -- eliminated
        z = () -- eliminated
    in () -- None of x, y, z is used, so none of the three print calls is executed
```

And this time there's no court martial anymore -- death penalty carried out immediately!

For an eager programming language that does not care about referential transparency, this problem is less deadly, since we can simply require the implementation to always evaluate things and always evaluate in specific order. However, Haskell is a lazy programming language, and it's lazy by default, and laziness inherently requires referential transparency to hold.

## Saving the world with the `World`

Thus, for both theorem proving languages and lazy functional programming languages, now we have very convincing reasons why performing IO directly in functions should not be allowed. However, if a program is completely IO free, it will be useless (maybe not for proof assistants, but definitely yes for your dirty dirty industrial codebase). Human cannot live without other people, while programs cannot function without performing IO. So how can we save the world?

Wait, did I mention the "world"? Uh yes, in functional programming languages, we are always `map`ping things, transforming things, take an input and return an output. So why not take the "world" as an input and return a new "world" as an output?

```lean
opaque World : Type

def read (filename : String) (world : World) : (String × World) := magic
```

And now, the world of determinism is saved! Since the world is passed in as an argument, now `read` does not have to return the same output for the same input filename, because the input world are different.

Also, we saved evaluation order and lazy evaluation as well:

```haskell
-- Library code
print :: String -> World -> ((), World)
print = magic

-- User code
mutualAssuredDestruction :: World -> ((), World)
mutualAssuredDestruction world0 =
    let ((), world1) = print "Missile launched!" world0
        ((), world2) = print "Missile launched!" world1
        ((), world3) = print "Missile launched!" world2
    in ((), world3)

main :: World -> ((), World)
main world0 = mutualAssuredDestruction world0

-- Caller of main
applicationStart :: ()
applicationStart =
    let initialWorld = getInitialWorld ()
        ((), finalWorld) = main initialWorld
        x = consumeFinalWorld finalWorld
    in x
```

The world passing now introduces a **dataflow dependency** between the two `print` calls, since `world1` is produced by the first `print` and consumed by the second `print`. Thus, the second `print` cannot be evaluated before the first one. Since the caller of `main` expects a `World` instance, the entire chain of `print` calls must be evaluated in order to produce that final `World` instance.

Till now, we haven't seen either "Monad" or `IO` yet. Since this article is about the `IO` monad, you may naturally think that there's still unresolved issues, and yes, you're right.

## `World` can destroy the world, too

Except that writing boilerplates is not what an ambitious computer scientist should do, since `World` is just a normal type, nothing prevents us from doing something like this:

```haskell
cubanMissileCrisis :: World -> ((), World)
cubanMissileCrisis world0 =
    let ((), world1) = print "General secretary orders to launch missile!" world0
        ((), world2) = print "Cancel the missile launch!" world0 -- Oops, we used world0 again!
    in ((), world2)
```

Here `world0` is used twice, and two parallel universe branches are created. Despite the fact that in one branch the humanity will be destroyed, having two universes in one program is obviously problematic, and I believe you can trivially understand why.

## Wrapping the `World` into a safe box

To prevent such problems, we can wrap the `World` type into a restricted new type `WorldBox`. We only allow operating the `WorldBox` via specific functions, and disallow extracting the `World` instance from the `WorldBox`:

```haskell
newtype WorldBox a = WorldBox { runWorldBox :: World -> (a, World) }

andThen :: WorldBox a -> (a -> WorldBox b) -> WorldBox b
andThen action1 f =
    let innerFn world0 =
            let (result1, world1) = runWorldBox action1 world0
                action2 = f result1
                (result2, world2) = runWorldBox action2 world1
            in (result2, world2)
    in WorldBox innerFn
```

And since now, we no more expose the `World` type and instance directly. Only caller of `main` may have access to the initial `World` instance and may construct the initial `WorldBox`:

```haskell
-- Library code
print :: String -> WorldBox ()
print = magic

-- User code
mutualAssuredDestruction :: WorldBox ()
mutualAssuredDestruction =
    andThen (print "Missile launched!")
            (\_ -> andThen (print "Missile launched!")
                           (\_ -> print "Missile launched!"))

main :: WorldBox ()
main = mutualAssuredDestruction

-- Caller of main
applicationStart :: ()
applicationStart =
    let initialWorld = getInitialWorld ()
        ((), finalWorld) = runWorldBox main initialWorld
        x = consumeWorld finalWorld
    in x
```

And now the world is finally saved (or mutually assured destroyed).

*Still get confused by the fancy `WorldBox` type and `andThen` function? That's the "headache pills" part. To understand how it works in the dumb way, you can evaluate the entire `applicationStart` function step by step, just like evaluating a mathematical expression. To use things practically, you may just skip these details and think "okay it works anyway" and move on.*

> Interlude
>
> In spite of wrapping the `World` into a safe box, there's another way of saving the world: using linear types. Linear types require that a value of a certain type must be used exactly once. Thus, if we define `World` as a linear type, the compiler will prevent us from using `world0` twice in the previous example. However, linear types were not initially supported in Haskell (though support has been added now). Despite this historical reason, monads provide additional goodness, as we'll see later.

## The `IO` Monad

Recall the definition of `WorldBox`:

```haskell
newtype WorldBox a = WorldBox { runWorldBox :: World -> (a, World) }
andThen :: WorldBox a -> (a -> WorldBox b) -> WorldBox b
```

and the definition of the `Monad` type class in Haskell:

```haskell
-- Simplified definition, just showing the relevant APIs
class Monad m where
    return :: a -> m a                 -- not seen in our example yet but easy to define
    (>>=)  :: m a -> (a -> m b) -> m b -- !
```

We can see that `andThen` perfectly matches the signature of the bind operator `(>>=)`. Since there are so many useful abstractions and syntactic sugar built on top of the `Monad` type class, why not also make `WorldBox` an instance of `Monad`?

That's right, and that is `IO` in Haskell, which is in turn defined as:

```haskell
-- Here State# and (# ... #) are unlifted counterpart to their normal variations, used for performance reasons
newtype IO a = IO (State# RealWorld -> (# State# RealWorld, a #))
```

Now we can rewrite our previous `drillLaunchMissile` function using the bind operator `(>>=)`:

```haskell
mutualAssuredDestruction :: IO ()
mutualAssuredDestruction =
    putStrLn "Missile launched!" >>= \_ ->
    putStrLn "Missile launched!" >>= \_ ->
    putStrLn "Missile launched!"
```

Or `do` notation:

```haskell
mutualAssuredDestruction :: IO ()
mutualAssuredDestruction = do
    putStrLn "Missile launched!"
    putStrLn "Missile launched!"
    putStrLn "Missile launched!"
```

That's it.

## Relations between `IO` and other monads

So as you can see now, `IO`, `List` and `Maybe` are all monads, but they are used for different purposes and their bind implementation actually does different thing. They are in the same pants just because they share the same structure of chaining computations together, and we want to use the same abstractions (`Monad` typeclass), manipulators (high order functions like `mapM`) and syntactic sugar (`do` notation) as much as possible.

## Some tricky word play

If you've read other tutorials prior to this, you may have seen that "`IO` is a type that represents a computation that performs IO", "the `main` function produces a recipe about 'how to perform IO' to the runtime system" and "the Haskell language itself does not have side effects, but the runtime system does", etc. These explanations are not completely wrong, but they are very confusing. To clarify this, let's get back to the definition of `WorldBox` and `andThen`:

```haskell
newtype WorldBox a = WorldBox { runWorldBox :: World -> (a, World) }
andThen :: WorldBox a -> (a -> WorldBox b) -> WorldBox b
--                       ^~~~~~~~~~~~~~~~~    ^~~~~~~~~
--                       |                    |
--                       |                    A new world box constructed from the previous one and a function
--                       |
--                       A function not executed yet, not an evaluated value!
```

Did you see that? When we are doing `andThen`, we are just toying with (not-yet executed!) functions and composing `WorldBox`es into new ones. And when we are doing these, no actual IO and computation is performed. When `main` returns, it just hands the "biggest" `WorldBox` to its caller (runtime system). Only when `runWorldBox` is called with an initial `World` instance, the entire chain of computations is executed. This supports the claims above somehow, but now you can see that it's just a matter of perspective and word play. `read`/`print`/`putStrLn`s of course perform IO when get executed, while in Haskell (and other languages employing monad for IO) the actual execution is just somewhat "postponed". And since now if you see anyone repeats the "language is pure while runtime is not" mantra to newbies once again, you should smile mercilessly and smack them with this article printed in paper rolled into a tube.
