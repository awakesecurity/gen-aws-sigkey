{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Main where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as C8L
import           Data.Maybe
import qualified Data.Text.IO               as Text.IO
import           Data.Thyme.Clock
import           Options.Generic

import qualified Gen.AWS.SigKey             as SigKey

main :: IO ()
main = do
  SigKey.Options{..} <- unwrapRecord "Generate a AWS V4 scoped signing key"
  now <- getCurrentTime
  let ssk@SigKey.ScopedSigningKey{..} =
        SigKey.makeKey
          now
          (fromMaybe "us-east-1" region)
          (fromMaybe "s3" service)
          (fromMaybe "aws4_request" protocol)
          key

  if | sigonly   -> Text.IO.putStrLn signing_key
     | otherwise -> C8L.putStrLn $ encode ssk
