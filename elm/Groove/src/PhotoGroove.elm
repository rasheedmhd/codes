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

-- Imports all primitive/attributes the Html modules offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html
import Html exposing (..)
-- Imports all primitive/attributes the Html>Attribute module offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes
import Html.Attributes exposing (..)

urlprefix =
 "http://elm-in-action.com/"

view model =
 div [ class "content" ]
  [ h1 [] [ text "Photo Groove" ]
  , div [ id "thumbnails" ] (List.map viewThumbnail model)
  ]
 -- div [ class "content" ]
 --  [h1 [] [text "Photo Groove" ]
 --   , div [ id "thumbnails" ]
 --   [ img [ src "http://elm-in-action.com/1.jpeg" ] []
 --   , img [ src "http://elm-in-action.com/2.jpeg" ] []
 --   , img [ src "http://elm-in-action.com/3.jpeg" ] []
 --  ]
 -- ]

viewThumbnail thumb =
 img [ src (urlprefix ++ thumb.url) ] []

initialModel =
 [ { url = "1.jpeg" }
 , { url = "2.jpeg" }
 , { url = "3.jpeg" }
 ]

main =
 view initialModel
