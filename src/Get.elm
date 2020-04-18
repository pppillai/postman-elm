module Get exposing (main)
import Browser
import Http
import Html exposing (..)

type alias PostManGet =
    {
        request: String
    }

type Msg =
    LoadFeed (Result Http.Error String)

initialModel: PostManGet
initialModel =
   PostManGet "Loading Get From Postman"


init: () -> (PostManGet, Cmd Msg)
init () =
    (initialModel, doGet)

subscriptions: PostManGet -> Sub Msg
subscriptions model =
    Sub.none

doGet: Cmd Msg
doGet =
    Http.get
    {
        url = "https://postman-echo.com/get?foo1=bar1&foo2=bar2"
        , expect = Http.expectString LoadFeed
    }
view : PostManGet -> Html Msg
view postmanget =
    div []
        [ strong [] [ text "Comment: " ]
        , text postmanget.request
        ]

update: Msg -> PostManGet -> ( PostManGet, Cmd Msg)
update msg postmanget =
    case msg of
        LoadFeed (Ok value ) -> ({ postmanget | request = value}, Cmd.none)
        LoadFeed (Err error) -> ({ postmanget | request = buildErrorMessage error}, Cmd.none)


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


main: Program () PostManGet Msg
main = Browser.element {
    init = init
    ,view = view
    , update = update
    , subscriptions = subscriptions
    }