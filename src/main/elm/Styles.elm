module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, td)
import Css.Namespace exposing (namespace)

type CssClasses
    = RedCell
    | GreenCell

css : Stylesheet
css =
    (stylesheet << namespace "template")
    [ body
        [ margin auto
        , backgroundColor (hex "FFFFFF")

        ]
    , (.) RedCell
        [ backgroundColor (hex "FFCCCC")
        ]
    , (.) GreenCell
        [ border3 (px 2) solid (hex "00FF00")
        ]
    ]
