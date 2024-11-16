module Page.NotFound exposing (..)

import Browser exposing (Document)
import Html


document : Document msg
document =
    { title = "404 - Not Found"
    , body = [ Html.text "Not Found" ]
    }
