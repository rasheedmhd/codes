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

urlPrefix =
 "http://elm-in-action.com/"

view model =
 div [ class "content" ]
  [ h1 [] [ text "Photo Groove" ]
  , div [ id "thumbnails" ]
    (List.map (createThumbnailUrl model.selectedUrl) model.photos)
  , img
    [ class "large"
    , src (urlPrefix ++ "large/" ++ model.selectedUrl)
    ]
    []
  ]

-- Helper/translation function
createThumbnailUrl selectedUrl thumbnail =
-- Return image but in a situation where by the selectedUrl is
-- the same as the url of the thumbnail,
-- there by returning true, add a class attribute
-- with the name of the classList string to the image and return it
 img
  [ src (urlPrefix ++ thumbnail.url)
  , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
  ]


initialModel =
 { photos =
  [ { url = "1.jpeg" }
  , { url = "2.jpeg" }
  , { url = "3.jpeg" }
  ]
  , selectedUrl = "1.jpeg"
 }


main =
 view initialModel
