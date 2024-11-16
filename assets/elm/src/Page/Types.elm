module Page.Types exposing (..)

import Page.Home.Types as Home


type Msg
    = HomeMsg Home.Msg


type alias Model =
    { home : Home.Model }
