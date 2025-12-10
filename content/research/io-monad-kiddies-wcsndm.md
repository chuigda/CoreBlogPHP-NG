# Explain IO Monad in 2025

It's 2025 now and I find someone (including myself several days ago) still does not understand IO Monads in functional programming languages. For any ambitious computer scientist (or at least you should call yourself such instead of "programmer"), not understanding this concept will severely reduce the opportunities of bragging on IM channels and tech forums, causing potential mental distress and loss of self-esteem. If that's you, don't worry, this article is here to help you out. Hi, this is Chuigda, let's discuss IO and IO Monads.

## Couldn't you just let me perform the f*cking IO?

Well, I believe you'd ask me this and you won't let me get away without having a satisfactory answer. In fact, when I was learning functional programming languages, I've also asked others this question before and searched on the internet. However, most answers are merely "function should be pure" or "to separate side effects from pure functions". These answers are not satisfactory at all, so now let's construct a convincing answer together.

To begin, let's see what makes a function pure. An important characteristic of pure functions is **referential transparency**. The definition of referential transparency is that **an expression can be replaced with its corresponding value without changing the program's behavior**, and this naturally implies **determinism**: **the function always produces the same output for the same input**. You can see that there's no "must not have side effects" or "must not perform IO" in the literal definition text, but we'll immediately see why performing IO is inherently not referentially transparent:

```lean
/- Let's assume that there's a read function without all the bells and whistles -/
def read (filename : String) : String := magic

/- Could this proposition hold? -/
theorem monika_great_theorem : read "monika.chr" = read "monika.chr" := rfl
```

In the Lean code snippet above, we read the same file twice. However, if the file is modified between the two reads, the two results will be different. If we consider `read` as a referentially transparent function (consider it deterministic), then the proposition above should type check, but actually we have no reason to believe it. We know that once you prove a proposition like `1 = 2`, you can prove anything. Then your world suddenly descends into a state of constant pancake flip-flopping and historical nihilism reminiscent of the Soviet era -- where everything is meaningless and every action is futile, leading to the inevitable collapse of the Union. This is definitely not what you want.

You may argue that referential transparency is only important for theorem proving languages like Lean/Agda, and is completely irrelevant to your dirty dirty industrial codebase where IO happens every time you ping your database. Your argument is solid and correct, and in fact there are not-that-functional functional programming languages that simply allow performing IO without any restriction:

```scheme
(define (drill-launch-missile)
    (display "Missile launched!")
    (display "That's just a drill!"))
```

So for Lean/Agda, the "referential transparency" answer is convincing enough. But for Haskell, we'd better find a more convincing answer.

## It's all about expression evaluation

Aside from determinism, there's another implication of referential transparency: **expressions can be evaluated in any order**, and **we can replace evaluated expressions with their values at any time**. Consider the following code:

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

On the other hand, even if we don't do the above replacement, since expressions can be evaluated in any order, the implementation is theoretically free to evaluate later expression first:

```haskell
militaryDrill :: ()
militaryDrill =
    let x = print "Missile launched!"
        y = print "That's just a drill!"
    in ()
```

Implementation may evaluate `y` first and then `x`, and the two commands, output in reverse order, could confuse the soldiers quite well.

For an eager programming language that does not care about referential transparency, these issues are less deadly, since we can simply require the implementation to always evaluate things, and always evaluate in specific order. However, Haskell is a lazy programming language, and it's lazy by default. And **laziness inherently requires referential transparency to hold**: if and only if expressions can be evaluated in any order, we can safely postpone evaluating an expression until its value is needed.

## Saving the world with the `World`

Thus, for both theorem proving languages and lazy functional programming languages, now we have very convincing reasons why performing IO directly in functions should not be allowed. However, if a program is completely IO free, it will be useless (maybe not for proof assistants, but definitely yes for your dirty dirty industrial codebase). A human cannot live without other people, while programs cannot function without performing IO. So how can we save the world?

Wait, did I mention the "world"? Uh yes, in functional programming languages, we are always `map`ping things, transforming things, take an input and return an output. So why not take the "world" as an input and return a new "world" as an output?

```lean
opaque World : Type

def read (filename : String) (world : World) : (String × World) := magic
```

And now, the world of determinism is saved! Since the world is passed in as an argument, now `read` does not have to return the same output for the same input filename, because the input worlds are different:

```lean
let (content1, world1) := read "monika.chr" world0
let (content2, world2) := read "monika.chr" world1

/- Now this no longer type checks -/
theorem monika_great_theorem : content1 = content2 := rfl
```

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

> ### Interlude
>
> How can we really put the whole world into a value of type `World`? Well, we can't, but we don't have to. `World` is just an abstract type that **represents** instead of **contains** the entire state of the world. Implementation may even eliminate the storage of `World` instances completely, since they are only tokens used to enforce dataflow dependencies between IO operations.

Till now, we haven't seen either "Monad" or `IO` yet. Since this article is about the `IO` monad, you may naturally think that there's still unresolved issues, and yes, you're right.

## `World` can destroy the world, too

Except that writing boilerplate is not what an ambitious computer scientist should do, since `World` is just a normal type, nothing prevents us from doing something like this:

```haskell
cubanMissileCrisis :: World -> ((), World)
cubanMissileCrisis world0 =
    let ((), world1) = print "Both Captain and Political Officer agree to launch the missile!" world0
        ((), world2) = print "Executive Officer Vasily Arkhipov refuses to launch!" world0 -- Oops!!
    in ((), world2)
```

Here `world0` is used twice, and two parallel universe branches are created. Despite the fact that in one branch humanity will be destroyed, having two universes in one program is obviously problematic, and I believe you can trivially understand why.

## Encapsulating the `World`

To prevent such leaking issues, it's a natural thought to wrap the `World` type and its manipulations into new types and new functions. That's encapsulation -- the bread and butter of software engineering. But contrary to what you may think, we are not going to wrap the `World` itself, but rather its manipulators. Let's define a new type `WorldChanger` that wraps functions that take a `World` and return a new value and a new `World`:

```haskell
newtype WorldChanger a = WorldChanger (World -> (a, World))
--                                    ^~~~~~~~~~~~~~~~~~~~~
--                                    |
--                                    The wrapped "world changing" function: A function that takes a
--                                    World, produces a new value and a new World

runWorldChanger :: WorldChanger a -> World -> (a, World)
runWorldChanger wc world0 =
    let (WorldChanger innerFn) = wc
    in innerFn world0
```

Or use the one-line version:

```haskell
newtype WorldChanger a = WorldChanger { runWorldChanger :: World -> (a, World) }
```

Then our original `print` function which takes a `String` and a `World` can be wrapped as such:

```haskell
-- Library code
originalPrint :: String -> World -> ((), World)
originalPrint = magic

print :: String -> WorldChanger ()
print message = WorldChanger innerFn where
    innerFn :: World -> ((), World)
    innerFn world0 = originalPrint message world0
```

Then, we can define a function `andThen` that chains up two `WorldChanger`s together:

```haskell
-- Library code
andThen :: WorldChanger a -> WorldChanger b -> WorldChanger b
andThen wc1 wc2 = WorldChanger innerFn where
    innerFn :: World -> (b, World)
    innerFn world0 =
        let (result1, world1) = runWorldChanger wc1 world0 -- Remember this unused result1
            (result2, world2) = runWorldChanger wc2 world1
        in (result2, world2)
```

And now we can rewrite our previous `mutualAssuredDestruction` function using only `WorldChanger`, `print` and `andThen`:

```haskell
-- User code
mutualAssuredDestruction :: WorldChanger ()
mutualAssuredDestruction =
    andThen (print "Missile launched!")
            (andThen (print "Missile launched!")
                     (print "Missile launched!"))

main :: WorldChanger ()
main = mutualAssuredDestruction
```

There's still manual world passing in library code, but user code is now clean. When implementing a new IO operation, and thus creating a new function that returns a `WorldChanger`, library authors still need to manually pass the `World` instance in the inner `runWorldChanger` function (and can make mistakes, of course). But once all IO operations are settled, users of the library can just chain up `WorldChanger`s without worrying about world passing.

Finally the caller of `main` is responsible for providing the initial `World` instance and consuming the final `World` instance:

```haskell
-- Caller of main
applicationStart :: ()
applicationStart =
    let initialWorld = getInitialWorld ()
        ((), finalWorld) = runWorldChanger main initialWorld
        x = consumeFinalWorld finalWorld
    in x
```

## `andThen` Pro Plus Super TI

Everything works fine so far. However, there's still one problem we haven't resolved. To explain, let's start from defining a `read` function in the `WorldChanger` style:

```haskell
-- Library code
originalRead :: String -> World -> (String, World)
originalRead = magic

read :: String -> WorldChanger String
read filename = WorldChanger innerFn where
    innerFn :: World -> (String, World)
    innerFn world0 = originalRead filename world0
```

Consider the following requirement: before actually launching a missile, we need to read the password file from a floppy disk, to make sure that the launch order was really issued by the general secretary. And then comes the problem: we want to check the result of `read` before deciding whether to call `print` to launch the missile. However, in the current design of `andThen`, the second `WorldChanger b` does not have access to the result of the first `WorldChanger a`.

We are not going to take apart `WorldChanger`s in user code and acquire `World` instances, since that breaks the encapsulation and brings us back to square one. We need something more powerful than the current `andThen`:

```haskell
-- Library code
andThenPro :: WorldChanger a -> (a -> WorldChanger b) -> WorldChanger b
andThenPro wc1 makeWC2 = WorldChanger innerFn where
    innerFn :: World -> (b, World)
    innerFn world0 =
        let (result1, world1) = runWorldChanger wc1 world0
            wc2 = makeWC2 result1
            (result2, world2) = runWorldChanger wc2 world1
        in (result2, world2)
```

Now the second `WorldChanger` is no more a fixed value, but dynamically constructed with the result of the first `WorldChanger`. With `andThenPro`, we can now define our `launchMissileWithPasswordCheck` function properly:

```haskell
launchMissileWithPasswordCheck :: WorldChanger ()
launchMissileWithPasswordCheck =
    andThenPro (read "A:\\password.txt")
               (\password ->
                    if password == "P2T8M-VJK83-22HF9-MR88B-QQX7Y"
                    then print "Missile launched!"
                    else print "Launch aborted: incorrect password.")
```

And now the world is finally saved (or mutually assured destroyed).

*Still get confused by the fancy `WorldChanger` type and `andThen`/`andThenPro` function? That's the "headache pills" part. To understand how it works in the dumb way, you can evaluate the entire `applicationStart` function by hand, step by step, just like evaluating a mathematical expression. To use things practically, you may just skip these details and think "okay it works anyway" and move on.*

> ### Interlude
>
> Aside from wrapping the `World` manipulations into a `WorldChanger`, there's another way of saving the world: using linear types. Linear types require that a value of a certain type must be used exactly once. Thus, if we define `World` as a linear type, the compiler will prevent us from using `world0` twice in the previous example. However, linear types were not initially supported in Haskell (though support has been added now). Despite this historical reason, monads provide additional goodness, as we'll see later.

## The `IO` Monad

Recall the signature of `andThenPro`:

```haskell
andThenPro :: WorldChanger a -> (a -> WorldChanger b) -> WorldChanger b
```

and the definition of the `Monad` type class in Haskell:

```haskell
-- Simplified definition, just showing the relevant APIs
class Monad m where
    return :: a -> m a                 -- not seen in our example yet
    (>>=)  :: m a -> (a -> m b) -> m b -- !!
```

We can see that `andThenPro` perfectly matches the signature of the bind operator `(>>=)`. Since there are so many useful abstractions and syntactic sugar built on top of the `Monad` type class, why not also make `WorldChanger` an instance of `Monad`?

```haskell
instance Monad WorldChanger where
    return :: a -> WorldChanger a -- We'll be back soon

    (>>=) :: WorldChanger a -> (a -> WorldChanger b) -> WorldChanger b
    (>>=) = andThenPro
```

And the name `WorldChanger` is too long to type, so let's rename it...

```haskell
type IO a = WorldChanger a
```

Congratulations, you've re-invented the `IO` monad in Haskell!

> ### Interlude
>
> `IO` in Haskell actually has a slightly more complicated definition:
>
> ```haskell
> newtype IO a = IO (State# RealWorld -> (# State# RealWorld, a #))
> ```
>
> Here `State# RealWorld` serves the same purpose as our `World` type, and `(# ... #)` is just "unboxed" tuple (tuple: `( ... )`, just the same syntax without `#`). If you couldn't understand this definition, don't worry. The high level idea is exactly the same as our `WorldChanger` type. Not understanding these implementation details will not block you from reading the rest of this article.

Now we can rewrite our previous `launchMissileWithPasswordCheck` function using the bind operator `(>>=)`:

*(And from now on I'll use real Haskell functions like `readFile` and `putStrLn` instead of our mock `read` and `print`.)*

```haskell
launchMissileWithPasswordCheck :: IO ()
launchMissileWithPasswordCheck =
    readFile "A:\\password.txt" >>= \password ->
        if password == "P2T8M-VJK83-22HF9-MR88B-QQX7Y"
        then putStrLn "Missile launched!"
        else putStrLn "Launch aborted: incorrect password."
```

Or `do` notation:

```haskell
launchMissileWithPasswordCheck :: IO ()
launchMissileWithPasswordCheck = do
    password <- readFile "A:\\password.txt"
    if password == "P2T8M-VJK83-22HF9-MR88B-QQX7Y"
        then putStrLn "Missile launched!"
        else putStrLn "Launch aborted: incorrect password."
```

That's it.

> ### Interlude
>
> If you look at the signature of `andThen` carefully, you will find it looks similar to another operator in Haskell:
>
> ```haskell
> andThen ::             WorldChanger a -> WorldChanger b -> WorldChanger b
> (>>)    :: Monad m  =>            m a ->            m b ->            m b
> ```
>
> Congratulations, you just found another operator `(>>)` defined for Monads!

## The `return`

In the previous sections, we haven't seen the `return` function required by the `Monad` type class. So yes, we need another example. Imagine that the missile launch password is split into two files and stored on two floppy disks. We want a function that reads the two files and concatenates the passwords together, let's make a try with our existing tools:

```haskell
readPassword :: IO String
readPassword =
    readFile "A:\\password.txt" >>= \part1 ->
    readFile "B:\\password.txt" >>= \part2 ->
    (part1 ++ part2)
--  ^~~~~~~~~~~~~~~
--  |
--  Does not type check
```

The innermost lambda does not typecheck, because it `(part1 ++ part2)` has type `String`, so that lambda has type `String -> String`, while the bind operator `(>>=)` requires the lambda to have type `String -> IO String`. So we need a way to lift a normal value into an `IO`, and this is exactly what `return` does:

```haskell
-- Simplified definition, just showing the relevant APIs
class Monad m where
    return :: a -> m a                 -- !!
    (>>=)  :: m a -> (a -> m b) -> m b
```

With `return`, we can now fix our `readPassword` function:

```haskell
readPassword :: IO String
readPassword =
    readFile "A:\\password.txt" >>= \part1 ->
    readFile "B:\\password.txt" >>= \part2 ->
    return (part1 ++ part2)
```

The implementation of `return` can be quite straightforward. Since you definitely don't want to see the `#` syntax again, let's just show the implementation for our `WorldChanger` type as an illustration:

```haskell
-- Library code
return :: a -> WorldChanger a
return value = WorldChanger innerFn where
    innerFn :: World -> (a, World)
    innerFn world0 = (value, world0)
```

> ### Interlude
>
> And contrary to imperative languages, `return` is just a conventional function, it just lifts a normal value into a monadic value, and does not "return from the current function". For example, you can write code like:
>
> ```haskell
> example :: IO ()
> example = do
>     return ()                    -- Looks like an early exit...
>     putStrLn "I'm still alive!"  -- ...but this still gets executed!
> ```
>
> Which can be desugared to:
>
> ```haskell
> example :: IO ()
> example =
>     return () >>= \_ ->
>     putStrLn "I'm still alive!"
> ```
>
> `return`, what a terrible naming choice, meh. Fortunately, in modern Haskell, `return` is the same as `pure` from the `Applicative` type class:
>
> ```haskell
> -- Simplified definition, just showing the relevant APIs
> class Applicative f where
>     pure :: a -> f a
>
> class Applicative m => Monad m where
>     return :: a -> m a
>     return = pure
> ```
>
> So you can use `pure` to avoid confusion:
>
> ```haskell
> example :: IO ()
> example = do
>    pure ()                      -- No more looks like an early exit
>    putStrLn "I'm still alive!"
> ```

## Relations between `IO` and other monads

So as you can see now, `IO`, `List` and `Maybe` are all monads, but they are used for different purposes and their bind implementation actually does different thing. They are in the same pants just because they share the same structure of chaining computations together, and we want to use the same abstractions (`Monad` typeclass), manipulators (high order functions like `mapM`) and syntactic sugar (`do` notation) as much as possible.

## Some tricky word play

If you've read other tutorials prior to this, you may have seen that "`IO` is a type that represents a computation that performs IO", "the `main` function produces a recipe about 'how to perform IO' to the runtime system" and "the Haskell language itself does not have side effects, but the runtime system does", etc. These explanations are not completely wrong, but they are very confusing. To clarify this, let's get back to the definition of `WorldChanger` and `andThen`/`andThenPro`:

```haskell
newtype WorldChanger a = WorldChanger (World -> (a, World))
--                                    ^~~~~~~~~~~~~~~~~~~~
--                                    |
--                                    A function that takes a World, produces a new value and
--                                    a new World. It is an unevaluated function, not an evaluated
--                                    result

andThen :: WorldChanger a -> WorldChanger b -> WorldChanger b
--         ^~~~~~~~~~~~~~    ^~~~~~~~~~~~~~    ^~~~~~~~~~~~~~
--         |                 |                 |
--         |                 |                 A new world changer constructed from the
--         |                 |                 two inputs, containing a new function,
--         |                 |                 which is also not evaluated yet
--         |                 |
--         |                 Another world changer, also containing a function not executed yet
--         |
--         A world changer, containing a function not executed yet

andThenPro :: WorldChanger a -> (a -> WorldChanger b) -> WorldChanger b
--            ^~~~~~~~~~~~~~    ^~~~~~~~~~~~~~~~~~~~~    ^~~~~~~~~~~~~~
--            |                 |                        |
--            |                 |                        A new world changer constructed from the
--            |                 |                        two inputs, containing a new function,
--            |                 |                        which is also not evaluated yet
--            |                 |
--            |                 A function producing a new world changer, not evaluated yet
--            |
--            The existing world changer, containing a function not executed yet

runWorldChanger :: WorldChanger a -> World -> (a, World)
runWorldChanger wc world0 =
    let (WorldChanger innerFn) = wc
    in innerFn world0
--     ^~~~~~~ ~~~~~~
--     |
--     And here is where innerFn really gets called
```

Did you see that? When we are doing `andThen`/`andThenPro`, we are just toying with (not-yet executed!) functions and composing `WorldChanger`s into new ones. And when we are doing these, no actual IO and computation is performed. When `main` returns, it just hands the "biggest" `WorldChanger` to its caller (runtime system). Only when `runWorldChanger` is called with an initial `World` instance, the entire chain of computations is executed. This supports the claims above somehow, but now you can see that it's just a matter of perspective and word play.

<div class="img-container">
<img src="/extra/blog-images/smack-mercilessly.webp" alt="smack" width="540" height="580"/>
</div>

And since now if you see anyone repeats the "language is pure while runtime is not" mantra to newbies once again, you should smile mercilessly and smack them with a rolled-up printout of this article.

## Acknowledgements

Thanks to [ice1000](https://ice1000.org), [Anqur](https://anqur.lu), [Hoshino Tented](https://github.com/HoshinoTented), [Lyra](https://github.com/Lyra-planet) and [Lyzh](https://github.com/imlyzh) for review and suggestions. Thanks to Gemini and Claude for helping me polish the article.
