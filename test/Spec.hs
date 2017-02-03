{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Text
import           Data.Thyme.Clock
import           Data.Thyme.Format
import           System.Locale
import           Test.Tasty
import           Test.Tasty.HUnit

import qualified Gen.AWS.SigKey

secretKey :: Text
secretKey = "TRcWws4vG4QBkIiomqMd8d52jDhq9aYKALVfe9TG"

staticTime :: UTCTime
staticTime = readTime defaultTimeLocale "%Y%m%d" "20170101"

main :: IO ()
main =
  defaultMain
    (testGroup
       "Tests"
       [ testCase "Scoped Signing Key Generation" testGenSigningKey ])

testGenSigningKey :: Assertion
testGenSigningKey =
  scopedSigKey @?= Gen.AWS.SigKey.ScopedSigningKey expectedScope expectedKey
  where
    expectedScope = "20170101/us-east-1/s3/aws4_request"
    expectedKey   = "f/CAPJJVqocGbb76s9BcJgfGwfDfZOEGgi9iB+9yF7g="
    scopedSigKey  =
      Gen.AWS.SigKey.makeKey
        staticTime
        "us-east-1"
        "s3"
        "aws4_request"
        secretKey
