{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    ) where

import Prelude hiding (log)
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import System.IO
import Control.Exception hiding (Handler)
import qualified Data.ByteString as BS

data PaymentRequest = PaymentRequest
  { amount :: Double
  }
$(deriveJSON defaultOptions ''PaymentRequest)

data PaymentResponse = PaymentResponse
  { authorised :: Bool
  }
$(deriveJSON defaultOptions ''PaymentResponse)

type API =
  "paymentAuth" :>
  ReqBody '[JSON] PaymentRequest :>
  Post '[JSON] PaymentResponse

log s = do
  hPutStrLn stderr s

startApp :: IO ()
startApp = do
  log "Starting..."
  run 80 app

logBody req = do
  chunk <- requestBody req
  if BS.length chunk == 0
    then return ()
    else do
      BS.hPut stderr chunk
      logBody req

app :: Application
app request responder = do
  log (show request)
  serve api server request responder

api :: Proxy API
api = Proxy

server :: PaymentRequest -> Handler PaymentResponse -- == Server API
server req | amount req >= 42 = return $ PaymentResponse False
server _ = return $ PaymentResponse True
