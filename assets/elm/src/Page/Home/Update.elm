module Page.Home.Update exposing (..)

import Page.Home.Types as Home


update : Home.Msg -> Home.Model -> ( Home.Model, Cmd Home.Msg )
update _ model =
    ( model, Cmd.none )


init : Home.Model
init =
    ()
