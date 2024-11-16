module State exposing (State, init)

import Page.Types as Page
import Page.Update as Page
import Route exposing (Route)


type alias State =
    { route : Route
    , page : Page.Model
    }


init : State
init =
    { route = Route.Home
    , page = Page.init
    }
