module TestSpacebrew exposing (..)

import Json.Encode as E
import Json.Decode as D
import Spacebrew as Sb
import Result

--create some dummy encoded data from the server
-- client config message
{-
{
    "config": {
        "name": "PLAYER 2",
        "description": "PLAYER 2 client ",
        "subscribe": {
            "messages": [{
                "name": "control",
                "type": "string"
            }]
        },
        "publish": {
            "messages": [{
                "name": "player2",
                "type": "string",
                "default": ""
            }]
        },
        "remoteAddress": "127.0.0.1"
    },
    "targetType": "admin"
}
-}

config : Result.Result String Sb.ClientConfig -> Maybe Sb.ClientConfig
config res =
    case res of
        Ok x -> Just x
        _ -> Nothing

decodedMessage = D.decodeString Sb.decodeClientConfig mockClientConfig

clientConfigMessage : Sb.Msg
clientConfigMessage =
        case decodedMessage of
            Ok msg -> Sb.MsgClientConfig msg
            Err s -> Sb.MsgInvalid s

client : Maybe Sb.ClientConfig -> String
client c =
    case c of
        Just s -> .config s |> .name 
        _ -> "unknown client"

attemptToDecode : String -> Sb.Msg
attemptToDecode str =
    let
        toSbMsg : Result.Result String a -> (a -> Sb.Msg) -> Sb.Msg
        toSbMsg decoded sbmsg = 
                    case decoded of
                        Ok c -> sbmsg c
                        Err e -> Sb.MsgInvalid e

        attempt str =
            let 
                try decoder sbmsg str =
                    toSbMsg (D.decodeString decoder str) sbmsg

                tryClientConfig = 
                    try Sb.decodeClientConfig (Sb.MsgClientConfig) 

                tryAdminConfig =
                    try Sb.decodeAdminConfig (Sb.MsgAdminConfig) 

            in
                case ( tryClientConfig str) of
                    Sb.MsgInvalid err -> 
                        case ( tryClientConfig str) of
                           _ -> tryAdminConfig str 
                    msg -> 
                        msg

    in
        attempt str

--
-- MulitpleClientConfg
--
--

-- Sample message with one client

mockClientConfig = """
{
    "config": {
        "name": "PLAYER 2",
        "description": "PLAYER 2 client ",
        "subscribe": {
            "messages": [{
                "name": "control",
                "type": "string"
            }]
        },
        "publish": {
            "messages": [{
                "name": "player2",
                "type": "string",
                "default": ""
            }]
        },
        "remoteAddress": "127.0.0.1"
    },
    "targetType": "admin"
}
"""


--Err JSON
error = """ {"config":{"name":"PLAYER 2","description":"PLAYER 2 client ","subscribe":{"messages":[{"name":"control","type":"string"}]},"publish":{"messages":[{"name":"player2","type":"string","default":""}]},"remoteAddress":"127.0.0.1"},\"targetType\":\"admin\"}" """


--
--
-- MulitpleClientConfg
--
--

{- Sample message with one client

[{
    "config": {
        "name": "PLAYER 1",
        "description": "PLAYER 1 client ",
        "subscribe": {
            "messages": [{
                "name": "control",
                "type": "string"
            }]
        },
        "publish": {
            "messages": [{
                "name": "player1",
                "type": "string",
                "default": ""
            }]
        },
        "remoteAddress": "127.0.0.1"
    }
}]
-}


--
--
-- RemoveMessage
--
--

-- remove message
{- Sample message 

{
    "remove": [{
        "name": "PLAYER 1",
        "remoteAddress": "127.0.0.1"
    }],
    "targetType": "admin"
}
-}