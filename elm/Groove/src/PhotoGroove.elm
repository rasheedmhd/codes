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

import Browser
-- Imports all primitive/attributes the Html modules offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html
import Html exposing (..)
-- Imports all primitive/attributes the Html>Attribute module offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

photoListUrl : String
photoListUrl =
 "http://elm-in-action.com/"

view : { a | selectedUrl : String, photos : List { b | url : String } } -> Html { decription : String, data : String }
view model =
 div [ class "content" ]
  [ h1 [] [ text "Photo Groove" ]
  , div [ id "thumbnails" ]
    (List.map (viewThumbnail model.selectedUrl) model.photos)
  , img
    [ class "large"
    , src (photoListUrl ++ "large/" ++ model.selectedUrl)
    ]
    []
  ]

-- Helper/translation function
viewThumbnail : String -> { a | url : String } -> Html { decription : String, data : String }
viewThumbnail selectedUrl thumbnail =
-- Return image but in a situation where by the selectedUrl is
-- the same as the url of the thumbnail,
-- there by returning true, add a class attribute
-- with the name of the classList string to the image and return it
 img
  [ src (photoListUrl ++ thumbnail.url)
  , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
  , onClick { decription = "ClickedPhoto", data = thumbnail.url }
  ]
  []


initialModel : { photos : List { url : String }, selectedUrl : String }
initialModel =
 { photos =
  [ { url = "1.jpeg" }
  , { url = "2.jpeg" }
  , { url = "3.jpeg" }
  ]
 , selectedUrl = "1.jpeg"
 }


-- { description = "ClickedPhoto", data = "2.jpeg" }
update : { a | decription : String, data : b } -> { c | selectedUrl : b } -> { c | selectedUrl : b }
update msg model =
 if msg.decription == "ClickedPhoto" then
  { model | selectedUrl = msg.data }

 else 
  model

main : Program () { photos : List { url : String }, selectedUrl : String } { decription : String, data : String }
main =
 Browser.sandbox
  { init = initialModel
  , view = view
  , update = update
  }
