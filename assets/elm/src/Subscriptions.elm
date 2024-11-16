module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Page.Subscriptions as Page
import State exposing (State)


subscriptions : State -> Sub Msg
subscriptions state =
    [ mapMsg PageMsg (Page.subscriptions state.page) ]
        |> Sub.batch


mapMsg : (a -> msg) -> Sub a -> Sub msg
mapMsg toMsg sub =
    Sub.map toMsg sub
