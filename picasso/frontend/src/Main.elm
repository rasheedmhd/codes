-- PicassoFrontend
module Picasso exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html exposing (text)


type Status
 = Loading
 | Loaded  String
 | Errored String

initialModel : Status
initialModel
 = Loading


view model =
 [ div [] [ text model ] ]

main =
 veiw initialModel
