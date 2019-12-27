module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    { text : String, content : String }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { text = "no text requested", content = "0" }, Cmd.none )


type Msg
    = GetText1
    | GetText2
    | GetText3
    | GetText4
    | GotText (Result Http.Error String)
    | Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = newContent }, Cmd.none )

        GetText1  ->
            ( model, getText1 )

        GetText2 ->
            ( model, getText2 )

        GetText3 ->
            ( model, getText3 )

        GetText4 ->
            ( model, getGamerByNumber model.content )

        GotText (Ok value) ->
            ( { model | text = value }, Cmd.none )

        GotText (Err error) ->
            ( { model | text = "an error occured" }, Cmd.none )


getText1 : Cmd Msg
getText1 =
    Http.get
        { url = "http://localhost:550/getGamer"
        , expect = Http.expectString GotText
        }

getGamerByNumber: String -> Cmd Msg
getGamerByNumber someNumberAsAString =
    Http.get
        { url = "http://localhost:550/getGamer/" ++ someNumberAsAString
        , expect = Http.expectString GotText
        }


getText2 : Cmd Msg
getText2 =
    Http.get
        { url = "http://localhost:550/getGamer/1"
        , expect = Http.expectString GotText
        }


getText3 : Cmd Msg
getText3 =
    Http.get
        { url = "http://localhost:550/getGamer/2"
        , expect = Http.expectString GotText
        }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetText1 ] [ text "Get all gamers" ]
        , button [ onClick GetText2 ] [ text "Gamer 1" ]
        , button [ onClick GetText3 ] [ text "Gamer 2" ]
        , button [ onClick GetText4 ] [ text "Get Gamer by number" ]
        , input [ placeholder "Enter a number", value model.content, onInput Change ] []
        , p [] [ text model.text ]
        ]

