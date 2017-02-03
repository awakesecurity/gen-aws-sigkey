{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE DeriveAnyClass      #-}
{-# LANGUAGE ExplicitNamespaces  #-}
{-# LANGUAGE MultiWayIf          #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}

module Gen.AWS.SigKey.Lib where

import           Crypto.Hash
import           Crypto.MAC.HMAC
import           Data.ByteArray          (ByteArrayAccess)
import           Data.ByteArray.Encoding
import qualified Data.ByteString.Char8   as C8
import           Data.Monoid
import           Data.Text
import           Data.Text.Encoding
import           Data.Thyme.Format
import           System.Locale

import           Gen.AWS.SigKey.Types    (ScopedSigningKey (..))

makeKey :: FormatTime t
        => t    -- Formattable timestamp, usually obtained with getCurrentTime
        -> Text -- AWS region, e.g: us-east-1
        -> Text -- AWS service, e.g: s3
        -> Text -- AWS signing key protocol, e.g: aws4_request
        -> Text -- AWS secret access key
        -> ScopedSigningKey
makeKey ctime region service protocol key = ScopedSigningKey scope' sigkey
  where
    dateStamp = formatTime defaultTimeLocale "%Y%m%d" ctime -- YYYYMMDD
    scope'    = Data.Text.intercalate "/" [ pack dateStamp, region, service, protocol ]

    sign :: ByteArrayAccess ba => ba -> C8.ByteString -> Digest SHA256
    sign k m  = hmacGetDigest $ hmac k m

    kDate     = sign (encodeUtf8 $ "AWS4" <> key) (C8.pack dateStamp)
    kRegion   = sign kDate    (encodeUtf8 region)
    kService  = sign kRegion  (encodeUtf8 service)
    kSigning  = sign kService (encodeUtf8 protocol)
    sigkey    = decodeUtf8 $ convertToBase Base64 kSigning
