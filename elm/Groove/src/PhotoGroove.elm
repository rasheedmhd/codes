-- Comments
-- Functions that create elements take exactly 2 arguments
-- fn_that_creates_elems [ls_of_attrs] [ls_of_DOM_nodes]
-- 1. A list of attributes
-- 2. A list of DOM Nodes
-- One of the args can empty so we get this
-- 1. h1 [] [ text "Photo Groove" ]
-- 2. img [ src "1.jpeg" ] []
-- or even both empty
-- br [] []
module PhotoGroove exposing (main)

import Html exposing (div, h1, img, text)
import Html.Attributes exposing (..)

view model =
 div [ class "content" ]
  [h1 [] [text "Photo Groove" ]
   , div [ id "thumbnails" ]
   [ img [ src "http://elm-in-action.com/1.jpeg" ] []
   , img [ src "http://elm-in-action.com/2.jpeg" ] []
   , img [ src "http://elm-in-action.com/3.jpeg" ] []
  ]
 ]

initialModel =
 [ { url = "1.jpeg" }
 , { url = "2.jpeg" }
 , { url = "3.jpeg" }
 ]

main =
 view initialModel
