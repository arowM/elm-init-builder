module Init exposing
    ( top
    , field
    , noCmd
    , andThen
    )

{-| Build the root init function from submodel init functions.


# Core

@docs top
@docs field
@docs noCmd
@docs andThen

-}


{-| -}
top : (a -> model) -> ( a -> model, Cmd msg )
top f =
    ( f, Cmd.none )


{-| -}
field : ( a, Cmd msg ) -> ( a -> b, Cmd msg ) -> ( b, Cmd msg )
field ( a, subCmd ) ( f, cmd ) =
    ( f a
    , Cmd.batch [ cmd, subCmd ]
    )


{-|

    noCmd a == field ( a, Cmd.none )

-}
noCmd : a -> ( a -> b, Cmd msg ) -> ( b, Cmd msg )
noCmd a =
    field ( a, Cmd.none )


{-| -}
andThen : (model -> ( model, Cmd msg )) -> ( model, Cmd msg ) -> ( model, Cmd msg )
andThen f ( model, cmd ) =
    let
        ( newModel, newCmd ) =
            f model
    in
    ( newModel, Cmd.batch [ cmd, newCmd ] )
