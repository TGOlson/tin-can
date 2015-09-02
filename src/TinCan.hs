{-# LANGUAGE OverloadedStrings #-}

module TinCan
    ( runTinCan
    ) where

import Control.Concurrent.STM
import Data.IORef
import Data.Aeson
import Data.Woot
import Data.Woot.Operation
import Data.Woot.WChar
import Network.HTTP.Types.Status
import Network.Wai
import Network.Wai.Handler.Warp


instance FromJSON Operation where
    parseJSON (Object v) = Operation <$>
                           v .: "type" <*>
                           v .: "clientId" <*>
                           v .: "wChar"

instance FromJSON OperationType where
    parseJSON = withText "OperationType" $ \o ->
        case o of
            "delete" -> return Delete
            "insert" -> return Insert
            _        -> undefined

instance FromJSON WChar where
    parseJSON (Object v) = WChar <$>
                           v .: "id" <*>
                           v .: "visible" <*>
                           v .: "alpha" <*>
                           v .: "prevId" <*>
                           v .: "nextId"

instance FromJSON WCharId where
    parseJSON (Object v) = WCharId <$>
                           v .: "clientId" <*>
                           v .: "clock"


makeEmptyClient :: IO (IORef WootClient)
makeEmptyClient = newIORef $ makeWootClientEmpty 0


tinCan :: IORef WootClient -> Application
tinCan clientRef req respond = do
    body <- requestBody req

    let mop = decodeStrict body

    case mop of
        Nothing -> return ()
        Just op -> do
            client <- readIORef clientRef
            let newClient = sendOperation op client
            _ <- writeIORef clientRef newClient
            putStrLn "Updated Client"
            putStrLn $ "New String: " ++ show (wootClientString newClient)

    respond $ responseLBS status200 [] "WOOOOT!"


runTinCan :: IO ()
runTinCan = makeEmptyClient >>= run 8000 . tinCan
