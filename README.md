Virtual CPU build in Elm
====

Some small examples from the `Binary` module:

How to reverse a list of `Int`

```elm
reverse : List Int -> List Int
reverse list =
  let
    reverse_ : List Int -> List Int -> List Int
    reverse_ list result =
      case list of
        [] -> result
        head::tail -> reverse_ tail (head::result) 
  in
    reverse_ list []
```

Or a list of any type (`element`):
```elm
reverse : List element -> List element
reverse list =
  let
    reverse_ : List element -> List element -> List element
    reverse_ list result =
      case list of
        [] -> result
        head::tail -> reverse_ tail (head::result) 
  in
    reverse_ list []

```