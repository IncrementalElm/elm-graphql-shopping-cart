-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Union.DiscountedProductInfoOrError exposing (Fragments, fragments, maybeFragments)

import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.ScalarCodecs
import Api.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (FragmentSelectionSet(..), SelectionSet(..))
import Json.Decode as Decode
import Scalar


type alias Fragments decodesTo =
    { onDiscountExpired : SelectionSet decodesTo Api.Object.DiscountExpired
    , onDiscountedProductInfo : SelectionSet decodesTo Api.Object.DiscountedProductInfo
    , onDiscountNotFound : SelectionSet decodesTo Api.Object.DiscountNotFound
    }


{-| Build up a selection for this Union by passing in a Fragments record.
-}
fragments :
    Fragments decodesTo
    -> SelectionSet decodesTo Api.Union.DiscountedProductInfoOrError
fragments selections =
    Object.exhuastiveFragmentSelection
        [ Object.buildFragment "DiscountExpired" selections.onDiscountExpired
        , Object.buildFragment "DiscountedProductInfo" selections.onDiscountedProductInfo
        , Object.buildFragment "DiscountNotFound" selections.onDiscountNotFound
        ]


{-| Can be used to create a non-exhuastive set of fragments by using the record
update syntax to add `SelectionSet`s for the types you want to handle.
-}
maybeFragments : Fragments (Maybe decodesTo)
maybeFragments =
    { onDiscountExpired = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onDiscountedProductInfo = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onDiscountNotFound = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    }