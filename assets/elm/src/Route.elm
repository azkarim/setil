module Route exposing (Route(..), onUrlChange, onUrlRequest, toRoute)

import Browser
import Msg exposing (Msg)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


type Route
    = Home
    | NotFound


toRoute : Url -> Route
toRoute url =
    Parser.parse route url
        |> Maybe.withDefault NotFound


route : Parser (Route -> a) a
route =
    Parser.oneOf
        [ Parser.map Home Parser.top
        ]


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    Msg.OnUrlRequest


onUrlChange : Url -> Msg
onUrlChange _ =
    Msg.OnUrlChange
