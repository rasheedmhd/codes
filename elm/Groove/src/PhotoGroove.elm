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
import Array exposing (Array)

photoListUrl : String
photoListUrl =
 "http://elm-in-action.com/"

view : Model -> Html Msg
view model =
 div [ class "content" ]
  [ h1 [] [ text "Photo Groove" ]
  , button [ onClick { description = "ClickedSurpriseMe", data = ""} ]
   [ text "Surprise Me!"]
  , h3 [] [ text "Thumbnail Size:" ]
  , div [ id "choose-size" ]
  -- [ viewSizeChooser Small, viewSizeChooser Medium, viewSizeChooser Large ]
  ( List.map viewSizeChooser [ Small, Medium, Large ] )
  , div [ id "thumbnails",  class (sizeToString model.chosenSize) ]
    (List.map (viewThumbnail model.selectedUrl) model.photos)
  , img
    [ class "large"
    , src (photoListUrl ++ "large/" ++ model.selectedUrl)
    ]
    []
  ]

-- Helper/translation function
viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
-- Return image but in a situation where by the selectedUrl is
-- the same as the url of the thumbnail,
-- there by returning true, add a class attribute
-- with the name of the classList string to the image and return it
 img
  [ src (photoListUrl ++ thumbnail.url)
  , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
  , onClick { description = "ClickedPhoto", data = thumbnail.url }
  ]
  []

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
  label []
   [ input [ type_ "radio", name "size"] []
   , text (sizeToString size)
   ]

sizeToString : ThumbnailSize -> String
sizeToString size =
 case size of 
  Small -> 
   "small"

  Medium -> 
   "med"

  Large -> 
   "large"

type alias Photo =
 { url : String }

type ThumbnailSize
 = Small
 | Medium
 | Large

type alias Model =
-- { a | selectedUrl : String, photos : List { b | url : String } }
 { photos: List Photo
 , selectedUrl : String
 , chosenSize : ThumbnailSize
 }

type alias Msg =
  { description : String, data : String }
initialModel : Model
initialModel =
 { photos =
  [ { url = "1.jpeg" }
  , { url = "2.jpeg" }
  , { url = "3.jpeg" }
  ]
 , selectedUrl = "1.jpeg"
 , chosenSize = Medium
 }

photoArray : Array Photo
photoArray = 
 Array.fromList initialModel.photos

getPhotoUrl : Int -> String
getPhotoUrl index =
 case Array.get index photoArray of
  Just photo ->
   photo.url

  Nothing -> 
   ""

-- { description = "ClickedPhoto", data = "2.jpeg" }
update : Msg -> Model -> Model
update msg model =
 case msg.description of
  "ClickedPhoto" ->
   { model | selectedUrl = msg.data }
  "ClickedSurpriseMe" ->
   { model | selectedUrl = "2.jpeg" }
--  if msg.description == "ClickedPhoto" then
--   { model | selectedUrl = msg.data }
--  else if msg.description == "ClickedSurpriseMe" then
--   { model | selectedUrl = "2.jpeg" }

  _ -> 
   model

main : Program () Model Msg
main =
 Browser.sandbox
  { init = initialModel
  , view = view
  , update = update
  }
