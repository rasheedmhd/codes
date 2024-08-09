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
import Html.Attributes exposing (..)

-- Imports all primitive/attributes the Html modules offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html
import Html exposing (..)
-- Imports all primitive/attributes the Html>Attribute module offers
-- https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes
import Html.Events exposing (onClick)
import Random

urlPrefix : String
urlPrefix =
 "http://elm-in-action.com/"

type Msg
 = ClickedPhoto String
 | ClickedSize ThumbnailSize
 | ClickedSurpriseMe
 | GotRandomPhoto Photo

view : Model -> Html Msg
view model =
 div [ class "content" ] <|
  case model.status of 
   Loaded photos selectedUrl -> 
    viewLoaded photos selectedUrl model.chosenSize
    
   Loading -> 
    []
    
   Errored errorMessage -> 
    [ text ("Error: " ++ errorMessage) ]

viewLoaded : List Photo -> String -> ThumbnailSize -> List (Html Msg) 
viewLoaded photos selectedUrl chosenSize =
 [ h1 [] [ text "Photo Groove" ]
 , button
  [ onClick ClickedSurpriseMe ]
  [ text "Surprise Me!" ]
 , h3 [] [ text "Thumbnail Size:" ]
 , div [ id "choose-size" ]
  (List.map viewSizeChooser [ Small, Medium, Large ])
 , div [ id "thumbnails", class (sizeToString chosenSize) ]
  (List.map (viewThumbnail selectedUrl) photos) , img
  [ class "large"
 , src (urlPrefix ++ "large/" ++ selectedUrl)
  ]
  []
 ]

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
 img
  [ src (urlPrefix ++ thumbnail.url)
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


type Status
 = Loading
 | Loaded (List Photo) String
 | Errored String


type alias Model =
 { status : Status
 , chosenSize : ThumbnailSize
 }

initialModel : Model
initialModel =
 { status = Loading
 , chosenSize = Medium
 }
-- { description = "ClickedPhoto", data = "2.jpeg" }
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
 case msg of
  GotRandomPhoto photo  ->
    ( { model | status = selectUrl photo.url model.status }, Cmd.none )

  ClickedPhoto  url ->
   ( { model | status = selectUrl url model.status }, Cmd.none )

  ClickedSize size ->
   ( { model | chosenSize = size }, Cmd.none )

  ClickedSurpriseMe ->
   case model.status of 
    Loaded (firstPhoto :: otherPhotos ) _ -> 
      Random.uniform firstPhoto otherPhotos
      |> Random.generate GotRandomPhoto
      |> Tuple.pair model 
      
    Loaded [] _ -> 
     ( model, Cmd.none )

    Loading -> 
     ( model, Cmd.none )

    Errored errorMessage -> 
     ( model, Cmd.none )


selectUrl : String -> Status -> Status
selectUrl url status =
 case status of
 Loaded photos _ ->
  Loaded photos url

 Loading ->
  status thought

 Errored errorMessage -> 
  status


main : Program () Model Msg
main =
 Browser.element
  { init = \flags -> ( initialModel, Cmd.none )
  , view = view
  , update = update
  , subscriptions = \model -> Sub.none
  }
