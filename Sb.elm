module Sb exposing (..)

import Json.Encode
import Json.Decode as D

type Flag = AdminConfig {admin : Bool, no_msgs: Bool}

adminConfigDecoder : D.Decoder Flag
adminConfigDecoder =
    D.map2 AdminConfig
        (D.field "admin" D.bool)
        (D.field "no_msgs" D.bool)

mockAdminConfig = """
{ "admin" = true
 ,"no_msgs" = true
 }
"""



{-

type Msg = MsgClientConfig ClientConfig
                      | MsgAdminConfig AdminConfig
                      | MsgMultipleClientConfig MultipleClientConfig
                      | MsgSubChannel SubChannel
                      | MsgPubChannel PubChannel
                      | MsgInvalid String

type Decoder = DecoderAdminConfig (Json.Decode.Decoder AdminConfig)
             | DecoderClientConfig (Json.Decode.Decoder ClientConfig)



type alias AdminConfig =
    { admin : Bool
    , no_msgs : Bool
    }

type ChannelType = CString | CBoolean | CRange

type alias SubChannel =
    { name : String
    , ctype : String --type is the spacebrew field name but is a keyword in elm
    }

type alias PubChannel =
    { name : String
    , ctype : String --type is the spacebrew field name but is a keyword in elm
    , default : String
    }

type alias ClientConfig = 
    { config : ClientConfigDetail 
    , remoteAddress : String }


type alias ClientConfigPubMessages =
    { messages : List PubChannel
    }


type alias ClientConfigSubMessages =
    { messages : List SubChannel
    }


type alias ClientConfigDetail =
    { name : String
    , description : String
    , subscribe : ClientConfigSubMessages
    , publish : ClientConfigPubMessages
    }


decodeAdminConfig : Json.Decode.Decoder AdminConfig
decodeAdminConfig =
    Json.Decode.Pipeline.decode AdminConfig
        |> Json.Decode.Pipeline.required "admin" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "no_msgs" (Json.Decode.bool)

encodeAdminConfig : AdminConfig -> Json.Encode.Value
encodeAdminConfig record =
    Json.Encode.object
        [ ("admin",  Json.Encode.bool <| record.admin)
        , ("no_msgs",  Json.Encode.bool <| record.no_msgs)
        ]


decodePubChannel : Json.Decode.Decoder PubChannel
decodePubChannel =
    Json.Decode.Pipeline.decode PubChannel
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "default" (Json.Decode.string)

encodePubChannel : PubChannel -> Json.Encode.Value
encodePubChannel record =
    Json.Encode.object
        [ ("name",  Json.Encode.string <| record.name)
        , ("type",  Json.Encode.string <| record.ctype)
        , ("default",  Json.Encode.string <| record.default)
        ]

decodeClientConfigPubMessages : Json.Decode.Decoder ClientConfigPubMessages
decodeClientConfigPubMessages =
    Json.Decode.Pipeline.decode ClientConfigPubMessages
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodePubChannel)

encodeClientConfigPubMessages : ClientConfigPubMessages -> Json.Encode.Value
encodeClientConfigPubMessages record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodePubChannel <| record.messages)
        ]


decodeSubChannel : Json.Decode.Decoder SubChannel
decodeSubChannel =
    Json.Decode.Pipeline.decode SubChannel
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)

encodeSubChannel : SubChannel -> Json.Encode.Value
encodeSubChannel record =
    Json.Encode.object
        [ ("name",  Json.Encode.string <| record.name)
        , ("type",  Json.Encode.string <| record.ctype)
        ]

decodeClientConfigSubMessages : Json.Decode.Decoder ClientConfigSubMessages
decodeClientConfigSubMessages =
    Json.Decode.Pipeline.decode ClientConfigSubMessages
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodeSubChannel)

encodeClientConfigSubMessages : ClientConfigSubMessages -> Json.Encode.Value
encodeClientConfigSubMessages record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodeSubChannel <| record.messages)
        ]

decodeClientConfig : Json.Decode.Decoder ClientConfig
decodeClientConfig =
    Json.Decode.Pipeline.decode ClientConfig
        |> Json.Decode.Pipeline.required "config" (decodeClientConfigDetail)
        |> Json.Decode.Pipeline.required "targetType" (Json.Decode.string)
}
-}


{- client config message

{"name": "PLAYER 1"
,"description": "PLAYER 1 client"
,"subscribe": {"messages": []}
, "publish" : {"messages": []}
}
-}

{-
decodeClientConfigDetail : Json.Decode.Decoder ClientConfigDetail
decodeClientConfigDetail =
    Json.Decode.Pipeline.decode ClientConfigDetail
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "subscribe" (decodeClientConfigSubMessages)
        |> Json.Decode.Pipeline.required "publish" (decodeClientConfigPubMessages)    


encodeClientConfigDetail : ClientConfigDetail -> Json.Encode.Value
encodeClientConfigDetail record =
    Json.Encode.object
        [ ("name",  Json.Encode.string <| record.name)
        , ("description",  Json.Encode.string <| record.description)
        , ("subscribe",  encodeClientConfigSubMessages <| record.subscribe)
        , ("publish",  encodeClientConfigPubMessages <| record.publish)
        ]



type alias MultipleClientConfig =
    { config : List ClientConfig
    }
-- elm-to-json output for client configuration message with 2 clients
-- most of this is already handled in the above types, encoders and decoders
-- the thing that structure is the JSONArray Decoder to handle the top level JSON Array
-}
{--
type alias ClientConfig =
    { 0 : ClientConfig0
    , 1 : ClientConfig1
    }

type alias ClientConfig0ConfigSubscribe =
    { messages : List ComplexType
    }

type alias ClientConfig0ConfigPublish =
    { messages : List ComplexType
    }

type alias ClientConfig0Config =
    { name : String
    , description : String
    , subscribe : ClientConfig0ConfigSubscribe
    , publish : ClientConfig0ConfigPublish
    , remoteAddress : String
    }

type alias ClientConfig0 =
    { config : ClientConfig0Config
    }

type alias ClientConfig1ConfigSubscribe =
    { messages : List ComplexType
    }

type alias ClientConfig1ConfigPublish =
    { messages : List ComplexType
    }

type alias ClientConfig1Config =
    { name : String
    , description : String
    , subscribe : ClientConfig1ConfigSubscribe
    , publish : ClientConfig1ConfigPublish
    , remoteAddress : String
    }

type alias ClientConfig1 =
    { config : ClientConfig1Config
    }

decodeClientConfig : Json.Decode.Decoder ClientConfig
decodeClientConfig =
    Json.Decode.Pipeline.decode ClientConfig
        |> Json.Decode.Pipeline.required "0" (decodeClientConfig0)
        |> Json.Decode.Pipeline.required "1" (decodeClientConfig1)

decodeClientConfig0ConfigSubscribe : Json.Decode.Decoder ClientConfig0ConfigSubscribe
decodeClientConfig0ConfigSubscribe =
    Json.Decode.Pipeline.decode ClientConfig0ConfigSubscribe
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodeComplexType)

decodeClientConfig0ConfigPublish : Json.Decode.Decoder ClientConfig0ConfigPublish
decodeClientConfig0ConfigPublish =
    Json.Decode.Pipeline.decode ClientConfig0ConfigPublish
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodeComplexType)

decodeClientConfig0Config : Json.Decode.Decoder ClientConfig0Config
decodeClientConfig0Config =
    Json.Decode.Pipeline.decode ClientConfig0Config
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "subscribe" (decodeClientConfig0ConfigSubscribe)
        |> Json.Decode.Pipeline.required "publish" (decodeClientConfig0ConfigPublish)
        |> Json.Decode.Pipeline.required "remoteAddress" (Json.Decode.string)

decodeClientConfig0 : Json.Decode.Decoder ClientConfig0
decodeClientConfig0 =
    Json.Decode.Pipeline.decode ClientConfig0
        |> Json.Decode.Pipeline.required "config" (decodeClientConfig0Config)

decodeClientConfig1ConfigSubscribe : Json.Decode.Decoder ClientConfig1ConfigSubscribe
decodeClientConfig1ConfigSubscribe =
    Json.Decode.Pipeline.decode ClientConfig1ConfigSubscribe
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodeComplexType)

decodeClientConfig1ConfigPublish : Json.Decode.Decoder ClientConfig1ConfigPublish
decodeClientConfig1ConfigPublish =
    Json.Decode.Pipeline.decode ClientConfig1ConfigPublish
        |> Json.Decode.Pipeline.required "messages" (Json.Decode.list decodeComplexType)

decodeClientConfig1Config : Json.Decode.Decoder ClientConfig1Config
decodeClientConfig1Config =
    Json.Decode.Pipeline.decode ClientConfig1Config
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "subscribe" (decodeClientConfig1ConfigSubscribe)
        |> Json.Decode.Pipeline.required "publish" (decodeClientConfig1ConfigPublish)
        |> Json.Decode.Pipeline.required "remoteAddress" (Json.Decode.string)

decodeClientConfig1 : Json.Decode.Decoder ClientConfig1
decodeClientConfig1 =
    Json.Decode.Pipeline.decode ClientConfig1
        |> Json.Decode.Pipeline.required "config" (decodeClientConfig1Config)

encodeClientConfig : ClientConfig -> Json.Encode.Value
encodeClientConfig record =
    Json.Encode.object
        [ ("0",  encodeClientConfig0 <| record.0)
        , ("1",  encodeClientConfig1 <| record.1)
        ]

encodeClientConfig0ConfigSubscribe : ClientConfig0ConfigSubscribe -> Json.Encode.Value
encodeClientConfig0ConfigSubscribe record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodeComplexType <| record.messages)
        ]

encodeClientConfig0ConfigPublish : ClientConfig0ConfigPublish -> Json.Encode.Value
encodeClientConfig0ConfigPublish record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodeComplexType <| record.messages)
        ]

encodeClientConfig0Config : ClientConfig0Config -> Json.Encode.Value
encodeClientConfig0Config record =
    Json.Encode.object
        [ ("name",  Json.Encode.string <| record.name)
        , ("description",  Json.Encode.string <| record.description)
        , ("subscribe",  encodeClientConfig0ConfigSubscribe <| record.subscribe)
        , ("publish",  encodeClientConfig0ConfigPublish <| record.publish)
        , ("remoteAddress",  Json.Encode.string <| record.remoteAddress)
        ]

encodeClientConfig0 : ClientConfig0 -> Json.Encode.Value
encodeClientConfig0 record =
    Json.Encode.object
        [ ("config",  encodeClientConfig0Config <| record.config)
        ]

encodeClientConfig1ConfigSubscribe : ClientConfig1ConfigSubscribe -> Json.Encode.Value
encodeClientConfig1ConfigSubscribe record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodeComplexType <| record.messages)
        ]

encodeClientConfig1ConfigPublish : ClientConfig1ConfigPublish -> Json.Encode.Value
encodeClientConfig1ConfigPublish record =
    Json.Encode.object
        [ ("messages",  Json.Encode.list <| List.map encodeComplexType <| record.messages)
        ]

encodeClientConfig1Config : ClientConfig1Config -> Json.Encode.Value
encodeClientConfig1Config record =
    Json.Encode.object
        [ ("name",  Json.Encode.string <| record.name)
        , ("description",  Json.Encode.string <| record.description)
        , ("subscribe",  encodeClientConfig1ConfigSubscribe <| record.subscribe)
        , ("publish",  encodeClientConfig1ConfigPublish <| record.publish)
        , ("remoteAddress",  Json.Encode.string <| record.remoteAddress)
        ]

encodeClientConfig1 : ClientConfig1 -> Json.Encode.Value
encodeClientConfig1 record =
    Json.Encode.object
        [ ("config",  encodeClientConfig1Config <| record.config)
        ]

-}