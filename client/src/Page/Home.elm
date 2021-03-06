module Page.Home exposing (Model, Msg, init, update, view)

import Api.Query as Query
import Discount exposing (Discount)
import Element exposing (Element)
import Element.Border
import Element.Events
import Element.Input
import Product exposing (Product)
import RemoteData exposing (RemoteData)
import Request exposing (Response)


type Msg
    = GotResponse (Response Discount)
    | GotProducts (Response (List (Product Product.Summary)))
    | ChangedDiscountCode String
    | ApplyDiscountCode


type alias Model =
    { discountCode : String
    , discountInfo : Response Discount
    , products : Response (List (Product Product.Summary))
    }


update msg model =
    case msg of
        GotResponse response ->
            ( { model | discountInfo = response }, Cmd.none )

        ChangedDiscountCode newDiscountCode ->
            ( { model | discountCode = newDiscountCode }, Cmd.none )

        GotProducts productsResponse ->
            ( { model | products = productsResponse }, Cmd.none )

        ApplyDiscountCode ->
            ( model, discountRequest model.discountCode )


view model =
    Element.column [ Element.spacing 15 ]
        [ Element.text "Products"
        , productsView model
        , discountInputView model
        ]


init : ( Model, Cmd Msg )
init =
    ( { discountCode = ""
      , discountInfo = RemoteData.Success Discount.none
      , products = RemoteData.Loading
      }
    , productsRequest
    )


productsView : Model -> Element Msg
productsView model =
    case RemoteData.map2 Tuple.pair model.discountInfo model.products of
        RemoteData.Success ( discount, products ) ->
            List.map (Product.view discount) products
                |> Element.column []

        RemoteData.Failure error ->
            Element.text <| Debug.toString error

        RemoteData.Loading ->
            Element.text "Loading..."

        RemoteData.NotAsked ->
            Element.text "Not asked..."


discountInputView : Model -> Element Msg
discountInputView model =
    Element.row [ Element.width Element.fill, Element.spacing 20 ]
        [ inputView model
        , applyButton
        , discountView model
        ]


applyButton : Element Msg
applyButton =
    Element.el
        [ Element.Border.width 2
        , Element.padding 10
        , Element.Events.onClick ApplyDiscountCode
        ]
        (Element.text "Apply")


discountView : { model | discountCode : String, discountInfo : RemoteData e Discount.Discount } -> Element msg
discountView { discountCode, discountInfo } =
    case discountInfo of
        RemoteData.NotAsked ->
            Element.text ""

        RemoteData.Loading ->
            Element.text "..."

        RemoteData.Failure e ->
            Element.text "Failed to load"

        RemoteData.Success discount ->
            Discount.view discount


productsRequest : Cmd Msg
productsRequest =
    Query.products Product.selection
        |> Request.query GotProducts


discountRequest : String -> Cmd Msg
discountRequest discountCode =
    Query.discountOrError { discountCode = discountCode } Discount.selection
        |> Request.query GotResponse


inputView : { a | discountCode : String } -> Element Msg
inputView model =
    Element.Input.text [ Element.width Element.fill ]
        { onChange = ChangedDiscountCode
        , text = model.discountCode
        , placeholder = Nothing
        , label = Element.Input.labelLeft [ Element.centerY ] (Element.text "Discount Code")
        }
