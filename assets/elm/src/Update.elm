module Update exposing (update)

import Msg exposing (Msg(..))
import Page.Update as Page
import State exposing (State)


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        PageMsg pageMsg ->
            Page.update pageMsg state.page
                |> (\( pageModel, pageCmd ) -> ( { state | page = pageModel }, Cmd.map PageMsg pageCmd ))

        OnUrlRequest ->
            ( state, Cmd.none )

        OnUrlChange ->
            ( state, Cmd.none )
