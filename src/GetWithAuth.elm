module GetWithAuth exposing (..)
import Browser
import Http exposing (..)
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
    Http.request
        { method = "GET"
        , url = "https://postman-echo.com/basic-auth"
        , expect = Http.expectString LoadFeed
        , body = Http.emptyBody
        , tracker =  Nothing
        , timeout = Nothing
        , headers = [Http.header "Authorization" "Basic cG9zdG1hbjpwYXNzd29yZA=="]
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