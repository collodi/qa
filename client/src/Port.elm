port module Port exposing (Msg(..), question, answer, decodeData)

import Json.Encode as E
import Json.Decode as D exposing (Decoder, field, string, value)

port question : (D.Value -> msg) -> Sub msg
port answer : E.Value -> Cmd msg

type Msg
    = GotText String
    | Ignored

decodeData : D.Value -> Msg
decodeData val =
    let
        dtype = D.decodeValue (field "dtype" string) val
        msg = D.decodeValue (field "msg" string) val

        data = D.decodeValue (field "data" value) val
    in
        Result.andThen (decodeDataValue dtype) data
            |> Result.withDefault Ignored


decodeDataValue : Result D.Error String -> D.Value -> Result D.Error Msg
decodeDataValue dtype data =
    case dtype of
        Ok "text" ->
            Result.map GotText (D.decodeValue string data)

        _ ->
            Ok Ignored
