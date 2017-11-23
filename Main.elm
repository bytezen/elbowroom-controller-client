import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket

import Json.Encode
import Json.Decode
import Spacebrew as Sb
import SpacebrewMessage as Sbm




main =
  Html.program
    { init = init
    , view = view
    , subscriptions = subscriptions
    , update = update
    }


echoServer : String
echoServer =
    "ws://localhost:9000"
  --"wss://echo.websocket.org"


sbAdminConfigMsg : Json.Encode.Value
sbAdminConfigMsg = Sb.encodeAdminConfig {admin= True, no_msgs= False}


-- MODEL


type alias Model =
  { input : String
  , messages : List String
  , clients : List Client
  , players : List Player
  }


init : (Model, Cmd Msg)
init =
  (Model "" [] [] [], Cmd.none)



-- UPDATE
type alias PlayerId = String
type alias ChannelName = String
type alias ChannelType = String
type alias ChannelDefault = String

type Player = Player PlayerId

type Client = PlayerClient String String 
            | GameClient String

type PubChannel = PubChannel ChannelName ChannelType ChannelDefault
type SubChannel = SubChannel ChannelName ChannelType 
type Route = Route PubChannel SubChannel

type Msg
  = Input String
  | Send
  | NewMessage String
  | Admin
  | Subscribe String


update : Msg -> Model -> (Model, Cmd Msg)
--update msg {input, messages} =
update msg model =
  case msg of
    Input newInput ->
      --(Model newInput messages, Cmd.none)
      ({ model | input = newInput }
        , Cmd.none
      )

    Send ->
      (model, WebSocket.send echoServer model.input)

    NewMessage str ->
      handleWSMessage str model ! [ Cmd.none ]

    Admin ->
      --model ! [ WebSocket.send echoServer (Json.Encode.encode 0 sbAdminConfigMsg) ]
      model ! [ WebSocket.send echoServer "{\"admin\":true, \"no_msgs\":true}"]

    Subscribe cname ->
       model ! [ WebSocket.send echoServer 
                <| Sbm.subscribe 
                <| Sb.Channel cname "string" ""
                ]


handleWSMessage : String -> Model -> Model
handleWSMessage msg model =
  let
    flags = Json.Decode.decodeString Sb.decode msg

    clientConfigToModel config =
      PlayerClient config.config.name config.config.description

  in
    case flags of 
        Ok (Sb.ClientFlag flag) ->
          { model | messages = msg :: model.messages
                  , clients = (clientConfigToModel flag) :: model.clients }
        _ ->
          { model | messages = msg :: model.messages } 


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    , button [onClick Admin] [text "Test Admin Message"]
    , button [onClick <| Subscribe "testChannel"] [text "Subscribe to test Channel"]
    , div [] (List.map viewMessage (List.reverse model.messages))
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]