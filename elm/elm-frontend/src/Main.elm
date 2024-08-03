module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Http

type alias Model =
 { message : String }

main =
 Browser.element { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }
 -- Browser.sandbox { init = init, update = update, view = view }

init _ =
 -- "Hello World!"
 ( { message = "Loading...." }
 , getMessage
 )

 type Msg =
 GotMessage ( Result Http.Error String)

update msg model =
 case msg of
  GotMessage (Ok message) =>
   { model | message = message }

  GotMessage (Err _) ->
   { modle | message = "Failed to load message }

view model =
 div [] [ text model.message ]

getMessage =
 Http.get
 { url = "http://localhost:8080"
 , expect = Http.expectString GotMessage
 }

-- use Http, Http.Response

-- app "Basic Web Server" provides [main] to platform

-- main = Http.serve 8080 \req ->

-- Http.okWith [("Access-Control-Allow-Origin", "*")] "Hell
-- from Roc!"
