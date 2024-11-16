module Page.Update exposing (..)

import Page.Home.Update as Home
import Page.Types as Page exposing (Msg(..))


update : Page.Msg -> Page.Model -> ( Page.Model, Cmd Page.Msg )
update pageMsg pageModel =
    case pageMsg of
        HomeMsg homeMsg ->
            Home.update homeMsg pageModel.home
                |> (\( homeModel, homeCmd ) -> ( { pageModel | home = homeModel }, Cmd.map HomeMsg homeCmd ))


init : Page.Model
init =
    { home = Home.init }
