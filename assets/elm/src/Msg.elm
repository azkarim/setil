module Msg exposing (Msg(..))

import Page.Types as Page


type Msg
    = PageMsg Page.Msg
    | OnUrlRequest
    | OnUrlChange
