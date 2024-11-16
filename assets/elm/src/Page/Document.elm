module Page.Document exposing (document)

import Browser exposing (Document)
import Html
import Msg exposing (Msg(..))
import Page.Home.View as Home
import Page.NotFound
import Page.Types as Page
import Route
import State exposing (State)


document : State -> Browser.Document Msg
document ({ route } as state) =
    case route of
        Route.Home ->
            state.page.home
                |> Home.document
                |> mapMsg (Page.HomeMsg >> PageMsg)

        Route.NotFound ->
            Page.NotFound.document


mapMsg : (docMsg -> msg) -> Browser.Document docMsg -> Browser.Document msg
mapMsg tagMsg { title, body } =
    body
        |> List.map (Html.map tagMsg)
        |> Document title
