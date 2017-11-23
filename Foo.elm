module Foo exposing (..)

import Json.Decode as Decode

type Bar = Bar String
type Baz = Baz Int

type Flag = F Bar | G Baz

type Foo a = Foo a
 --Baz { bar : String , baz : Int }
 --         | Bar { bar : String , baz : Int }



abar = G (Baz 100)
abaz = F (Bar "hello")

test = [abar, abaz]

{- 

```type User = Guest | SignedIn String

guestDecoder : Decoder User
guestDecoder =
  JD.succeed Guest

signedInDecoder : Decoder User
signedInDecoder =
  JD.field "email" JD.string
    |> JD.map SignedIn

```


Since the JSON  has different shapes, you could say:
```userDecoder : Decoder User
userDecoder =
  JD.oneOf [guestDecoder, signedInDecoder, JD.fail "invalid JSON for user"]```

  Alternatively, your back end might provide a `type` field you can check on:
```userDecoder : Decoder User
userDecoder =
  JD.field "type" JD.string |> JD.andThen userFromType

userFromType : String -> Decoder User
userFromType string =
  case string of
    "signed_in" -> signedInDecoder
    "guest" -> guestDecoder
    _ -> JD.fail "invalid JSON for user"```

-- The second is preferred because the first would always succeed with user Guest
--since `guestDecoder` doesn't depend on the structure of the JSON, it will never fail
  
  since `guestDecoder` doesn't depend on the structure of the JSON, it will never fail


[10:04] 
 ```userDecoder : Decoder User
userDecoder =
  JD.oneOf [signedInDecoder, guestDecoder]
```

we'd have to do something like this


new messages
[10:05] 
the `guestDecoder` will still always succeed for _all_ JSONs


[10:05] 
so the `andThen` based approach might be better if you want to sometimes fail (edited)


cjduncana [10:06 AM] 
The idea of a guest user allows the idea if decoding another user fails then succeed with `Guest`.


joelq [10:07 AM] 
In many cases, always falling back to `Guest` is the desired behavior


[10:08] 
in some cases, you might prefer to fail if you are attempting to parse completely unrelated JSON


-}