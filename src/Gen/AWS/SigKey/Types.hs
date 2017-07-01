{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeOperators      #-}

module Gen.AWS.SigKey.Types where

import           Data.Aeson
import           Data.Aeson.Types            hiding (Options)
import           Options.Generic

import           Gen.AWS.SigKey.AesonHelpers

data Options w = Options
  { region   :: w ::: Maybe Text
    <?> "AWS region  [default: us-east-1]"
  , service  :: w ::: Maybe Text
    <?> "AWS service [default: s3]"
  , protocol :: w ::: Maybe Text
    <?> "AWS protocol [default: aws4_request]"
  , sigonly  :: w ::: Bool
    <?> "Print the signature only"
  , key      :: w ::: Maybe Text
    <?> "AWS secret access key"
  } deriving (Generic)

instance ParseRecord (Options Wrapped)
deriving instance Show (Options Unwrapped)

data ScopedSigningKey = ScopedSigningKey
  { scope       :: Text
  , signing_key :: Text
  } deriving (Generic, Show, Read, Eq, FromJSON)

instance ToJSON ScopedSigningKey where
    toEncoding = genericToEncoding (defaultOptions { fieldLabelModifier = underToDash })
