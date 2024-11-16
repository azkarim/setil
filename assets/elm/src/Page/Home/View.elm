module Page.Home.View exposing (..)

import Browser exposing (Document)
import Html exposing (Html)
import Page.Home.Types as Home


view : Home.Model -> Html Home.Msg
view _ =
    Html.text "Home"


document : Home.Model -> Document Home.Msg
document model =
    { title = "Home"
    , body = [ view model ]
    }
