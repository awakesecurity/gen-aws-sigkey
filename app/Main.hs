{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE QuasiQuotes       #-}

module Main where

import qualified Control.Lens
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as C8L
import qualified Data.Ini
import           Data.Maybe
import qualified Data.Text
import qualified Data.Text.IO               as Text.IO
import           Data.Thyme.Clock
import qualified NeatInterpolation
import           Options.Generic
import qualified Turtle
import           Turtle                     ((</>))

import qualified Gen.AWS.SigKey             as SigKey

main :: IO ()
main = do
  SigKey.Options{..} <- unwrapRecord "Generate a AWS V4 scoped signing key"

  now  <- getCurrentTime

  secretAccessKey <- case key of
    Just secretAccessKey -> return secretAccessKey
    Nothing              -> do
      home <- Turtle.home
      let credentialsFile = home </> ".aws" </> "credentials"
      exists <- Turtle.testfile credentialsFile
      if not exists
        then fail (Data.Text.unpack [NeatInterpolation.text|
Error: Cannot obtain secret access key

If you do not provide the `--key` flag then there you must supply a credentials
file at `~/.aws/credentials` instead
|])
        else do
          text <- Turtle.readTextFile credentialsFile
          let fold =
                  Control.Lens._Right
                . Control.Lens.to Data.Ini.unIni
                . Control.Lens.ix "default"
                . Control.Lens.ix "aws_secret_access_key"
          case Control.Lens.preview fold (Data.Ini.parseIni text) of
            Just secretAccessKey -> return secretAccessKey
            Nothing -> fail (Data.Text.unpack [NeatInterpolation.text|
Error: Could not decode the credentials file located at `~/.aws/credentials`
|])

  let ssk@SigKey.ScopedSigningKey{..} =
        SigKey.makeKey
          now
          (fromMaybe "us-east-1" region)
          (fromMaybe "s3" service)
          (fromMaybe "aws4_request" protocol)
          secretAccessKey

  if | sigonly   -> Text.IO.putStrLn signing_key
     | otherwise -> C8L.putStrLn $ encode ssk
