module Request exposing (Response, query)

import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Http
import RemoteData exposing (RemoteData)


type alias Response data =
    RemoteData (Graphql.Http.RawError () Http.Error) data


query :
    (Response decodesTo -> msg)
    -> SelectionSet decodesTo RootQuery
    -> Cmd msg
query msgConstructor querySelection =
    querySelection
        |> Graphql.Http.queryRequest "http://localhost:4000/"
        |> Graphql.Http.send
            (\result ->
                result
                    |> Graphql.Http.discardParsedErrorData
                    |> Graphql.Http.withSimpleHttpError
                    |> RemoteData.fromResult
                    |> msgConstructor
            )
