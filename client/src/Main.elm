import Browser

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Port
import Json.Encode as E exposing (string)

main = 
    Browser.element
        { init = init, view = view, update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias Model =
    { question : Maybe String
    , answer : String
    }

toJson : Model -> E.Value
toJson model =
    E.object
        [ ( "answer", string "answer here" )
        ]

init : () -> ( Model, Cmd Msg )
init flags =
    ( Model Nothing "", Cmd.none )

-- UPDATE

type Msg
    = GotData Port.Msg
    | EditAnswer String
    | Reply

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotData subMsg ->
            ( updateData subMsg model, Cmd.none )

        EditAnswer answer ->
            ( { model | answer = answer }, Cmd.none )

        Reply ->
            ( model, Port.answer (toJson model) )

updateData : Port.Msg -> Model -> Model
updateData msg model =
    case msg of
        Port.GotText q ->
            { model | question = Just q }

        Port.Ignored ->
            model

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map GotData ( Port.question Port.decodeData )


-- VIEW

view : Model -> Html Msg
view model =
    case model.question of
        Just q ->
            div []
                [ div [] [ text "Question" ]
                , div [] [ text q ]
                , input [ onInput EditAnswer ] []
                ]

        Nothing ->
            div [] [ text "No question yet" ]
