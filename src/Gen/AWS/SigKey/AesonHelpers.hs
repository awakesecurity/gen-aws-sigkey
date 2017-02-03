{-# LANGUAGE LambdaCase #-}

module Gen.AWS.SigKey.AesonHelpers where

underToDash :: String -> String
underToDash = fmap (\case '_' -> '-' ; c -> c)
