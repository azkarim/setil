module Page.Subscriptions exposing (..)

import Page.Home.Subscriptions as Home
import Page.Types as Page


subscriptions : Page.Model -> Sub Page.Msg
subscriptions pageModel =
    [ Home.subscriptions pageModel.home |> Sub.map Page.HomeMsg ]
        |> Sub.batch
