module SpacebrewMessage exposing (..)

import Spacebrew as Sb
import Json.Encode as E

test : Sb.Channel
test = Sb.Channel "testChannel" "string" "nothing" 

--send a subscription message
subscribe : Sb.Channel -> String 
subscribe channel =
    E.encode 0 <| Sb.encodeChannel channel
