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

import Array exposing (Array)
import Browser
import Html.Attributes exposing (..)

-- Imports all primitive/attributes the Html modules offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html
import Html exposing (..)
-- Imports all primitive/attributes the Html>Attribute module offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes
import Html.Events exposing (onClick)
import Random

photoListUrl : String
photoListUrl =
 "http://elm-in-action.com/"

type Msg
 = ClickedPhoto String
 | GotSelectedIndex Int
 | ClickedSize ThumbnailSize
 | ClickedSurpriseMe

view : Model -> Html Msg
view model =
 div [ class "content" ]
  [ h1 [] [ text "Photo Groove" ]
  , button [ onClick ClickedSurpriseMe ]
   [ text "Surprise Me!"]
  , h3 [] [ text "Thumbnail Size:" ]
  , div [ id "choose-size" ]
  -- [ viewSizeChooser Small, viewSizeChooser Medium, viewSizeChooser Large ]
  ( List.map viewSizeChooser [  Small, Medium, Large ] )
  , div [ id "thumbnails",  class (sizeToString model.chosenSize) ]
    (List.map (viewThumbnail model.selectedUrl) model.photos)
  , img
    [ class "large"
    , src (photoListUrl ++ "large/" ++ model.selectedUrl)
    ]
    []
  ]

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
 img
  [ src (photoListUrl ++ thumbnail.url)
  , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
  , onClick ( ClickedPhoto thumbnail.url )
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
   "medium"

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

randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
 Random.int 0 (Array.length photoArray - 1)

-- { description = "ClickedPhoto", data = "2.jpeg" }
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
 case msg of
  GotSelectedIndex index ->
    ( { model | selectedUrl = getPhotoUrl index }, Cmd.none )

  ClickedPhoto  url ->
   ( { model | selectedUrl = url }, Cmd.none )

  ClickedSize size ->
   ( { model | chosenSize = size }, Cmd.none )

  ClickedSurpriseMe ->
   ( model, Random.generate GotSelectedIndex randomPhotoPicker )

main : Program () Model Msg
main =
 Browser.element
  { init = \flags -> ( initialModel, Cmd.none )
  , view = view
  , update = update
  , subscriptions = \model -> Sub.none
  }
